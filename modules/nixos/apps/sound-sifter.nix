{ config, lib, pkgs, ... }:

let
  soundSifterDeployment = "/srv/sound_sifter";
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
    dj-database-url
    django-celery-results
    flower
    hypercorn
  ]));
in
{
  age.secrets.soundSifterEnv.file = ../../../secrets/soundSifterEnv.age;
  users.users.sound_sifter = {
    isNormalUser = true;
    description = "Robotic account for Sound Sifter application";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSZMXih0bhOeWWZ/scrXJsaxwxVqPqBCvML1OCPhMw/ michal@parusinski.me"
    ];
  };
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "sound_sifter" ];
    ensureUsers = [
      {
        name = "sound_sifter";
        ensureDBOwnership = true;
      }
    ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  origin-address  auth-method
      local all       all     trust
      host  all       all     127.0.0.1/32    trust
      host  all       all     ::1/128         trust
    '';
  };
  services.rabbitmq = {
    enable = true;
    # managementPlugin.enable = true;
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
      };
    };
    services.sound-sifter-web = {
      description = "Sound sifter deployment";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target"];
      environment = {
        REGISTRATION_OPEN = "Y";
        STATIC_ROOT="${soundSifterDeployment}/static";
      };
      preStart = ''
        mkdir -p ${soundSifterDeployment}/static
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
  };
  services.nginx.virtualHosts = {
    "frcz-vps1" = {
      # enableACME = true;
      # forceSSL = true;
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
