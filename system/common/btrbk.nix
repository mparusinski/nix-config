{ config, pkgs, ... }:

{
  # Setting BTRBK services
  services.btrbk = {
    instances."home-snapshots" = {
      onCalendar = "hourly";
      settings = {
        snapshot_preserve = "14d";
        snapshot_preserve_min = "3d";
        
        volume."/btr_pool" = {
          snapshot_dir = "btrbk_snapshots";
          subvolume = "home";
        };
      };
    };
  };

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "${pkgs.coreutils-full}/bin/test";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.coreutils-full}/bin/readlink";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.btrfs-progs}/bin/btrfs";
          options = [ "NOPASSWD" ];
        }
      ];
      users = [ "btrbk" ];
    }];
  };
}
