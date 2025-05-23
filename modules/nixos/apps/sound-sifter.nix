{ config, lib, pkgs, ... }:

let
  djangoEnv = (pkgs.python3.withPackages (ps: with ps; [
    django
    # django-registration
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
  systemd = {
    tmpfiles.settings = {
      "sound-sifter" = {
        "/srv/sound_sifter" = {
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
      # preStart
      serviceConfig = {
        ExecStart = ''${djangoEnv}/bin/celery --version'';
        RemainAfterExit = true;
        User = "sound_sifter";
      };
    };
  };
}
