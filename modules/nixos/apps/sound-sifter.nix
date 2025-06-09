{ config, lib, pkgs, ... }:

let
  soundSifterDeployment = "/srv/sound_sifter";
  applyDBConf =
    {
      database,
      username,
      passwordFile
    } :
    pkgs.writeShellScript "applyDBConf"
    ''
      PASSWORD=$(cat ${passwordFile})
      ${pkgs.postgresql}/bin/psql -c "ALTER USER ${username} PASSWORD '$PASSWORD';"
      ${pkgs.postgresql}/bin/psql -c "ALTER ROLE ${username} SET client_encoding TO 'utf8';"
      ${pkgs.postgresql}/bin/psql -c "ALTER ROLE ${username} SET default_transaction_isolation TO 'read committed';"
      ${pkgs.postgresql}/bin/psql -c "ALTER ROLE ${username} SET timezone TO 'UTC';"
      ${pkgs.postgresql}/bin/psql -c "GRANT ALL PRIVILEGES ON DATABASE ${database} TO ${username};"
      ${pkgs.postgresql}/bin/psql -c "ALTER DATABASE ${database} OWNER TO ${username};"
    '';
  dbConfig = {
    database = "sound_sifter_db";
    username = "sound_sifter_rw";
    passwordFile = config.age.secrets.soundSifterDBPass.path;
  };
  dbConfigScript = applyDBConf dbConfig;
  djangoEnv = let
    django-registration = pkgs.python3.pkgs.buildPythonPackage rec {
      pname = "django-registration";
      version = "5.2.1";
      pyproject = true;

      src = pkgs.fetchFromGitHub {
        owner = "ubernostrum";
        repo = "django-registration";
        tag = version;
        hash = "sha256-02kAZXxzTdLBvgff+WNUww2k/yGqxIG5gv8gXy9z7KE=";
      };

      dependencies = [
        pkgs.python3.pkgs.confusable-homoglyphs
      ];

      nativeCheckInputs = [
        pkgs.python3.pkgs.coverage
        pkgs.python3.pkgs.django
      ];

      build-system = [ pkgs.python3.pkgs.pdm-backend ];
    };
  in
  (pkgs.python3.withPackages (ps: with ps; [
    django
    django-registration
    django-autocomplete-light
    django-tables2
    psycopg2
    spotipy
    celery
    redis
    dj-database-url
    django-celery-results
    flower
    hypercorn
  ]));
  # # TODO: Require sudo for this command
  # soundSifter_createSuperUser = pkgs.writeScriptBin "soundSifter_createSuperUser" ''
  #   ${djangoEnv}/bin/python ${soundSifterDeployment}/bin/manage.py createsuperuser
  # '';
in
{
  age.secrets.soundSifterEnv.file = ../../../secrets/soundSifterEnv.age;
  age.secrets.soundSifterDBPass.file = ../../../secrets/soundSifterDBPass.age;
  users.users.sound_sifter = {
    isNormalUser = true;
    description = "Robotic account for Sound Sifter application";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSZMXih0bhOeWWZ/scrXJsaxwxVqPqBCvML1OCPhMw/ michal@parusinski.me"
    ];
  };

  services.redis.servers."sndsft".enable = true;
  services.redis.servers."sndsft".port = 6379;
  services.postgresql = {
    enable = true;
    ensureDatabases = [ dbConfig.database ];
    ensureUsers = [
      {
        name = dbConfig.username;
      }
    ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  origin-address  auth-method
      local all       all     trust
      host  all       all     127.0.0.1/32    trust
      host  all       all     ::1/128         trust
    '';
  };
  systemd.services.applySoundSifterDBConf = {
    description = "Apply Sound Sifter DB Configuration";
    wants = [ "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      PermissionsStartOnly = true;
      RemainAfterExit = true;
      ExecStart = ''
        ${dbConfigScript}
      '';
      User = "postgres";
    };
  };
  systemd = {
    tmpfiles.settings = {
      "sound-sifter" = {
        "${soundSifterDeployment}" = {
          d = {
            group = "users";
            user = "sound_sifter";
            mode = "0755";
          };
        };
        "${soundSifterDeployment}/bin" = {
          d = {
            group = "users";
            user = "sound_sifter";
            mode = "0755";
          };
        };
        "${soundSifterDeployment}/static" = {
          d = {
            group = "users";
            user = "sound_sifter";
            mode = "0755";
          };
        };
        "/var/log/sound_sifter" = {
          d = {
            group = "users";
            user = "sound_sifter";
            mode = "0755";
          };
        };
      };
    };
    services.sound-sifter-web = {
      description = "Sound sifter deployment";
      after = [ "network.target" ];
      wants = [ "applySoundSifterDBConf.service" ];
      wantedBy = [ "multi-user.target"];
      preStart = ''
        mkdir -p ${soundSifterDeployment}/static
        # ${djangoEnv}/bin/python ${soundSifterDeployment}/bin/manage.py createsuperuser --username mparus --no-input
        ${djangoEnv}/bin/python ${soundSifterDeployment}/bin/manage.py migrate
        ${djangoEnv}/bin/python ${soundSifterDeployment}/bin/manage.py collectstatic --no-input
      '';
      serviceConfig = {
        EnvironmentFile = "${config.age.secrets.soundSifterEnv.path}";
        WorkingDirectory = "${soundSifterDeployment}/bin";
        # Setting the umask to 777 is overkill but couldn't find a reliable way to set the file of the socket
        ExecStart = ''
          ${djangoEnv}/bin/hypercorn --workers 2 --umask 0777 --bind unix:/${soundSifterDeployment}/app.sock sound_sifter.asgi:application
        '';
        User = "sound_sifter";
      };
    };
    services.sound-sifter-worker = {
      description = "Sound sifter deployment";
      after = [ "network.target" ];
      wants = [ "applySoundSifterDBConf.service" ];
      wantedBy = [ "multi-user.target"];
      serviceConfig = {
        EnvironmentFile = "${config.age.secrets.soundSifterEnv.path}";
        WorkingDirectory = "${soundSifterDeployment}/bin";
        # Setting the umask to 777 is overkill but couldn't find a reliable way to set the file of the socket
        ExecStart = ''
          ${djangoEnv}/bin/celery -A sound_sifter worker --loglevel=info
        '';
        User = "sound_sifter";
      };
    };
  };
  security.acme.certs."snd-sifter.parusinski.me".email = "michal@parusinski.me";
  services.nginx.recommendedProxySettings = true;
  services.nginx.virtualHosts = {
    "snd-sifter.parusinski.me" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          #proxyPass = "http://localhost:8080";
          #Socket not working for some reason
          proxyPass = "http://unix:/${soundSifterDeployment}/app.sock";
        };
        "/static/" = {
          root = "${soundSifterDeployment}/static";
          extraConfig = ''
            expires 365d;
            add_header Cache-Control "public, immutable";
          '';
        };
      };
    };
  };
}
