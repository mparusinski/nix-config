# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

let
  wallpaper = builtins.fetchurl {
    url = "https://i.redd.it/0d7drj9okdv91.jpg";
    sha256 = "sha256:0jz5id588nlvlprnvhw12p919br3lqm27bfd7lqv3pm35qxw6d8j";
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable searching for and installing unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" "ntfs" ];

  networking.hostName = "thor"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Paris";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Handling fonts
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    dejavu_fonts
    vistafonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # XMonad
  services.xserver = {
    enable = true;
    libinput = {
      enable = true;
      touchpad.tapping = false;
    };
    displayManager = {
      defaultSession = "none+xmonad";
      autoLogin = {
        enable = true;
        user = "michalparusinski";
      };
      sessionCommands = ''
        ${pkgs.feh}/bin/feh --bg-fill ${wallpaper}
        ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
          Xft.dpi: 192
          Xft.autohint:0
          Xft.lcdfilter: lcddefault
          Xft.hintstyle: hintfull
          Xft.hinting: 1
          Xft.antialias: 1
          Xft.rgba: rgb
        EOF
        ${pkgs.xorg.xset}/bin/xset r rate 150 50
        ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option caps:super
        ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:ralt
      '';
    };
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = builtins.readFile ../xmonad/xmonad.hs;
    };
    dpi = 192;
  };

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michalparusinski = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "docker" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$6$l1uvR/ebtdbjkm5q$77LijykP01hCqq9GhCai0OiJdBf5F8DUWd6b7lN.h1fYHIrTjbmCaGy3A6c0mQw2tnNEPmrejJI6fuVjppumW.";
    packages = with pkgs; [
      firefox
      kitty
      blueman
      arandr
      autorandr
      docker-compose
      git
      picom
      light
      distrobox
      dmenu
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wofi
    cifs-utils
  ];

  # Enable steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # List services that you want to enable:
  services.udisks2.enable = true;  
  virtualisation.docker.enable = true;

  # Setting zswap
  zramSwap = {
    enable = true;
    memoryPercent = 10;
  };

  # Setting BTRBK services
  services.btrbk = {
    instances."home-snapshots" = {
      onCalendar = "hourly";
      settings = {
        snapshot_preserve = "7d";
        snapshot_preserve_min = "2d";
        
        volume."/btr_pool" = {
          snapshot_dir = "snapshots";
          subvolume = "home";
        };
      };
    };
    instances."root-snapshots" = {
      onCalendar = "daily";
      settings = {
        snapshot_preserve = "14d";
        snapshot_preserve_min = "3d";

        volume."/btr_pool" = {
          snapshot_dir = "snapshots";
          subvolume = "root";
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

  # Enable network shares
  fileSystems."/media/nassie/public" = {
    device = "//nassie/public";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
  };
  fileSystems."/media/nassie/snapshots" = {
    device = "//nassie/snapshots";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

