{ config
, lib
, pkgs
, inputs
, ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/zramswap.nix
    ../../modules/nixos/btrbk.nix
    ../../modules/nixos/printing.nix
    ../../modules/nixos/gc.nix
    ../../modules/nixos/appimage.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/office.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/gnome.nix
    # ../../modules/nixos/hyprland.nix
    # ../../modules/nixos/thunar.nix
  ];

  # Enable searching for and installing unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "dell-precision-7530";
  networking.networkmanager.enable = true;

  mainUser.enable = true;
  mainUser.extraGroups = [
    "wheel"
    "docker"
    "audio"
  ];
  mainUser.ssh.enable = true;

  time.timeZone = "Europe/Paris";
  time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u32n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    useXkbConfig = true; # use xkb.options in tty.
  };

  services.tailscale.enable = true;

  personalGnome.enable = true;

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Show battery charge of Bluetooth devices
      };
    };
  };

  # Flatpak
  services.flatpak.enable = true;

  # Hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.gamemode.enable = true;
  services.fwupd.enable = true;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  services.thermald.enable = true;

  virtualisation.docker.storageDriver = "btrfs";

  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome.gvfs;
  };

  # theming
  dracula.enable = true;

  system.stateVersion = "24.11";
}
