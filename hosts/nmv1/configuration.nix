# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/gc.nix
    ../../modules/nixos/users.nix
  ];

  # Use systemd boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nmv1"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  mainUser.enable = true;
  mainUser.ssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.btrbk = {
    # TODO: Factorize this
    instances."nas_localdrive-snapshots" = {
      onCalendar = "hourly";
      settings = {
        snapshot_preserve = "7d";
        snapshot_preserve_min = "3d";
        volume."/btr_pool0" = {
          snapshot_dir = "snapshots";
          subvolume = "@nas";
        };
      };
    };
    instances."nas_ext1-snapshots" = {
      onCalendar = "hourly";
      settings = {
        snapshot_preserve = "7d";
        snapshot_preserve_min = "3d";
        volume."/btr_pool1" = {
          snapshot_dir = "snapshots";
          subvolume = "@nas";
        };
      };
    };
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    dataDir = "/btr_pool0/jellyfin_data";
  };
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  security.sudo = {
    enable = true;
    extraRules = [
      {
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
            command = "${pkgs.coreutils-full}/bin/btrfs";
            options = [ "NOPASSWD" ];
          }
        ];
        users = [ "btrbk" ];
      }
    ];
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    # You will still need to set up the user accounts to begin with:
    # $ sudo smbpasswd -a yourusername

    settings = {
      nas_localdrive = {
        path = "/media/nas_localdrive";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
      };
      nas_localdrive_snapshots = {
        path = "/btr_pool0/snapshots";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "no";
      };
      nas_ext1 = {
        path = "/media/nas_ext1";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
      };
      nas_ext1_snapshots = {
        path = "/btr_pool1/snapshots";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "no";
      };
    };
  };

  systemd.timers."auto-shutdown" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 4:00:00";
      Unit = "auto-shutdown.service";
    };
  };

  systemd.services."auto-shutdown" = {
    script = ''
      /run/current-system/sw/bin/poweroff
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  services.tailscale.enable = true;

  networking.firewall.enable = true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
