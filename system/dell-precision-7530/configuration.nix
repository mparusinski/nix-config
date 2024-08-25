# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common/users.nix
      ../common/xmonad.nix
      ../common/pipewire.nix
      ../common/zramswap.nix
      ../common/btrbk.nix
      ../common/omv1.nix
      ../common/bluetooth.nix
      ../common/printing.nix
      ../common/homeassistant.nix
    ];

  # Enable searching for and installing unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.plymouth.enable = true;

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

  environment.systemPackages = with pkgs; [
    firefox
    fzf
    keepassxc
    git
    vim
  ];

  programs.steam.enable = true;
  services.tailscale.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?
}

