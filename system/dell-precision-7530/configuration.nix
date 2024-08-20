# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

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

  networking.hostName = "dell-precision-7530";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";
  time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u32n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mparus = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "cdrom" "libvirtd" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$6$l1uvR/ebtdbjkm5q$77LijykP01hCqq9GhCai0OiJdBf5F8DUWd6b7lN.h1fYHIrTjbmCaGy3A6c0mQw2tnNEPmrejJI6fuVjppumW.";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSZMXih0bhOeWWZ/scrXJsaxwxVqPqBCvML1OCPhMw/"
    ];
  };
  users.users.mperez = {
    isNormalUser = true;
    hashedPassword = "$6$Ug3dp395tU9ZZrUj$urA8z3p61DIMUjdH3aT9HjzM9vm4q09GEibMP3BByvPO1ACu9L.TtF3O.a3OpRUVLyrJ0YPZFzccuL7UTchou0";
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # environment.systemPackages = with pkgs; [
  #   vim
  # ];

  # XMONAD
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
  services.displayManager.defaultSession = "none+xmonad";
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: 192
      Xft.autohint:0
      Xft.lcdfilter: lcddefault
      Xft.hintstyle: hintfull
      Xft.hinting: 1
      Xft.antialias: 1
      Xft.rgba: rgb
    EOF
    ${pkgs.xorg.xset}/bin/xset r rate 200 50
    ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option caps:super
    ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:ralt
  '';

  # GDM
  services.xserver.enable = true;
  services.libinput = {
    enable = true;
    touchpad.tapping = false;
  };
  services.xserver.dpi = 192;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    font-awesome
  ];

  # Enable brightness control
  programs.light.enable = true;

  # Packages for XMonad
  environment.systemPackages = with pkgs; [
    xfce.thunar
    arandr
    picom
    dmenu
    xmobar
    glxinfo
    vulkan-tools
    vim
    git
    kitty
    firefox
    fzf
    keepassxc
  ];

  services.udisks2.enable = true;

  # Enable steam
  programs.steam = {
    enable = true;
  };

  # Enabling tailscale
  services.tailscale.enable = true;

  system.copySystemConfiguration = true;
  system.stateVersion = "24.05"; # Did you read the comment?

}

