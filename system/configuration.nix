# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./machines/dell-precision-7530/hardware-configuration.nix
    ];

  # Enable searching for and installing unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/75cf08b9-e72b-4a4d-9561-669c8c900ae7";
      preLVM =  true;
    };
  };

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.hostName = "dell-precision-7530"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
    font-awesome_5
    font-awesome
    jetbrains-mono
  ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    synaptics = {
      enable = true;
      vertTwoFingerScroll = true;
      tapButtons = false;
    };
    displayManager = {
      defaultSession = "none+xmonad";
      autoLogin = {
        enable = true;
        user = "michalparusinski";
      };
      sessionCommands = ''
        ${pkgs.feh}/bin/feh --bg-fill ${builtins.fetchurl "https://i.redd.it/0d7drj9okdv91.jpg"}
        ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
          Xft.dpi: 192
          Xft.autohint:0
          Xft.lcdfilter: lcddefault
          Xft.hintstyle: hintfull
          Xft.hinting: 1
          Xft.antialias: 1
          Xft.rgba: rgb
          
          ! special
          *.foreground:   #d8caac
          *.background:   #323d43
          *.cursorColor:  #d8caac
          
          ! black
          *.color0:       #868d80
          *.color8:       #868d80
          
          ! red
          *.color1:       #e68183
          *.color9:       #e68183
          
          ! green
          *.color2:       #a7c080
          *.color10:      #a7c080
          
          ! yellow
          *.color3:       #d9bb80
          *.color11:      #d9bb80
          
          ! blue
          *.color4:       #89beba
          *.color12:      #89beba
          
          ! magenta
          *.color5:       #d3a0bc
          *.color13:      #d3a0bc
          
          ! cyan
          *.color6:       #87c095
          *.color14:      #87c095
          
          ! white
          *.color7:       #d8caac
          *.color15:      #d8caac

          *.alpha: 0.8
        EOF
        ${pkgs.xorg.xset}/bin/xset r rate 200 50
        ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option caps:super
        ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:ralt
      '';
    };
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
    dpi = 192;
  };

  # Handling HiDPI
  # environment.variables = {
  #   GDK_SCALE = "2";
  #   GDK_DPI_SCALE = "0.5";
  #   _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  # };
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Backlight settings
  hardware.acpilight.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.michalparusinski = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$6$l1uvR/ebtdbjkm5q$77LijykP01hCqq9GhCai0OiJdBf5F8DUWd6b7lN.h1fYHIrTjbmCaGy3A6c0mQw2tnNEPmrejJI6fuVjppumW.";
    packages = with pkgs; [
      firefox
      kitty
      blueman
      arandr
      autorandr
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    dmenu
    xmobar
  ];

  # Enable steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  systemd.services.upower.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  
  # Enable snapper
  services.snapper = {
    configs.home = {
      subvolume = "/home";
      extraConfig = ''
        ALLOW_USERS="michalparusinski"
        TIMELINE_CREATE=yes
        TIMELINE_CLEANUP=yes
      '';
    };
  };

  # Enable flatpak (useful for packages like Spotify)
  # services.flatpak.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

