{ config, pkgs, lib, modulesPath, ... }:

{
  imports = 
    [ ./gandicloud.nix 
      ../common/hosts.nix
      ../common/users.nix
    ];

  networking.hostName = "heavens"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [
    vim 
    git
  ];

  # Changing SSH port
  services.openssh = {
    enable = true;
    ports = [2222];
  };

  # Tailscale
  services.tailscale.enable = true;
}
