{ config, lib, pkgs, ... }:

let
  soundSifterDeployment = "/srv/sound_sifter";
  dbConfig = {
    database = "sound_sifter_db";
    username = "sound_sifter_rw";
    passwordFile = config.age.secrets.soundSifterDBPass.path;
    hostname = "localhost";
  };
  djangoEnv = pkgs.python3.withPackages (ps: with ps; [
    django
    django-registration
    django-autocomplete-light
    django-tables2
    mysqlclient
    spotipy
    celery
    redis
    dj-database-url
    django-celery-results
    flower
    hypercorn
    django-bootstrap5
  ]);
  # # TODO: Require sudo for this command
  # soundSifter_createSuperUser = pkgs.writeScriptBin "soundSifter_createSuperUser" ''
  #   ${djangoEnv}/bin/python ${soundSifterDeployment}/bin/manage.py createsuperuser
  # '';
in
{
  imports = [
    ../mysql.nix
  ];

  age.secrets.soundSifterEnv.file = ../../../secrets/soundSifterEnv.age;
  age.secrets.soundSifterDBPass.file = ../../../secrets/soundSifterDBPass.age;

  users.users.sound_sifter = {
    isNormalUser = true;
    description = "Robotic account for Sound Sifter application";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSZMXih0bhOeWWZ/scrXJsaxwxVqPqBCvML1OCPhMw/ michal@parusinski.me"
    ];
  };

  services.mysql = {
    enable = true;
    ensureDatabases = [
      "${dbConfig.database}"
    ];
    ensureUsers = [
      {
        name = "${dbConfig.username}";
        ensurePermissions = {
          "${dbConfig.database}.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  mysqlInitialConfiguration.enable = true;
  mysqlInitialConfiguration.configurations = [
    dbConfig
  ];

  services.redis.servers."sndsft".enable = true;
  services.redis.servers."sndsft".port = 6379;
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
          root = "${soundSifterDeployment}";
          extraConfig = ''
            expires 365d;
            add_header Cache-Control "public, immutable";
          '';
        };
      };
    };
  };
}
