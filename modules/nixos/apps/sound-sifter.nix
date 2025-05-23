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
  ]));
in
{
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
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };
  services.rabbitmq = {
    enable = true;
    # managementPlugin.enable = true;
  };
  systemd = {
    tmpfiles.settings = {
      "sound-sifter" = {
        soundSifterDeployment = {
          d = {
            group = "users";
            user = "sound_sifter";
            mode = "0700";
          };
        };
      };
    };
    services.sound-sifter = {
      description = "Sound sifter deployment";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target"];
      preStart = ''
        ${djangoEnv}/bin/python ${soundSifterDeployment}/bin/manage.py migrate;
        ${djangoEnv}/bin/python ${soundSifterDeployment}/bin/manage.py collectstatic --no-input;
      '';
      serviceConfig = {
        ExecStart = ''${djangoEnv}/bin/celery --version'';
        RemainAfterExit = true;
        User = "sound_sifter";
      };
    };
  };
}
