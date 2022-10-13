# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # Enable searching for and installing unfree packages
  nixpkgs.config.allowUnfree = true;

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

  networking.hostName = "dell-precision-7530-nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
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

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable the X11 windowing system.
  # services.xserver = {
  #   enable = true;
  #   synaptics = {
  #     enable = true;
  #     vertTwoFingerScroll = true;
  #     tapButtons = false;
  #   };
  #   displayManager = {
  #     defaultSession = "none+xmonad";
  #     autoLogin = {
  #       enable = true;
  #       user = "michalparusinski";
  #     };
  #     sessionCommands = ''
  #       ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
  #         Xft.dpi: 192
  #         Xft.autohint:0
  #         Xft.lcdfilter: lcddefault
  #         Xft.hintstyle: hintfull
  #         Xft.hinting: 1
  #         Xft.antialias: 1
  #         Xft.rgba: rgb
  #         
  #         st.font:			-*-dejavu sans mono-*-*-*-*-28-*-*-*-*-*-*-1
  #         ! st.bold_font:			0
  #         ! st.background:			#131415
  #         ! st.foreground:			#A3BAD0
  #         ! st.cursorColor:			#8d9b53
  #         ! st.termname:			xterm-256color
  #         ! st.shell:			/bin/sh
  #         ! st.bellvolume:			100
  #         ! st.tabspaces:			8
  #         ! st.chscale:			1.0
  #         ! st.cwscale:			1.0
  #         
  #         #define nord0 #2E3440
  #         #define nord1 #3B4252
  #         #define nord2 #434C5E
  #         #define nord3 #4C566A
  #         #define nord4 #D8DEE9
  #         #define nord5 #E5E9F0
  #         #define nord6 #ECEFF4
  #         #define nord7 #8FBCBB
  #         #define nord8 #88C0D0
  #         #define nord9 #81A1C1
  #         #define nord10 #5E81AC
  #         #define nord11 #BF616A
  #         #define nord12 #D08770
  #         #define nord13 #EBCB8B
  #         #define nord14 #A3BE8C
  #         #define nord15 #B48EAD
  #         
  #         *.foreground:   nord4
  #         *.background:   nord0
  #         *.cursorColor:  nord4
  #         *fading: 35
  #         *fadeColor: nord3
  #         
  #         *.color0: nord1
  #         *.color1: nord11
  #         *.color2: nord14
  #         *.color3: nord13
  #         *.color4: nord9
  #         *.color5: nord15
  #         *.color6: nord8
  #         *.color7: nord5
  #         *.color8: nord3
  #         *.color9: nord11
  #         *.color10: nord14
  #         *.color11: nord13
  #         *.color12: nord9
  #         *.color13: nord15
  #         *.color14: nord7
  #         *.color15: nord6
  #         *.alpha: 0.8
  #       EOF
  #       ${pkgs.xorg.xset}/bin/xset r rate 200 50
  #       ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option caps:super
  #       ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:ralt
  #     '';
  #   };
  #   windowManager.xmonad = {
  #     enable = true;
  #     enableContribAndExtras = true;
  #   };
  #   dpi = 192;
  # };

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.michalparusinski = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$6$l1uvR/ebtdbjkm5q$77LijykP01hCqq9GhCai0OiJdBf5F8DUWd6b7lN.h1fYHIrTjbmCaGy3A6c0mQw2tnNEPmrejJI6fuVjppumW.";
    packages = with pkgs; [
      firefox
      kitty
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

  # Enable Docker
  virtualisation.docker.enable = true;

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

