# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/users.nix
    # ../../modules/nixos/xmonad.nix
    ../../modules/nixos/hyprland.nix
    # ../../modules/nixos/gnome.nix
    # ../../modules/nixos/plasma.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/zramswap.nix
    ../../modules/nixos/btrbk.nix
    ../../modules/nixos/omv1.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/printing.nix
    ../../modules/nixos/homeassistant.nix
    ../../modules/nixos/gc.nix
    # ../../modules/nixos/proton.nix
    ../../modules/nixos/appimage.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/docker.nix
  ];

  # Enable searching for and installing unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
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

  # Hardware acceleration
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  programs.gamemode.enable = true;
  services.fwupd.enable = true;

  virtualisation.docker.storageDriver = "btrfs";
  environment.systemPackages = [ pkgs.distrobox ];

  system.stateVersion = "24.11";
}
