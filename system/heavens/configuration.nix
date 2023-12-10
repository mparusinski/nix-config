{ config, pkgs, lib, modulesPath, ... }:

{
  imports = 
    [ ./gandicloud.nix 
      ../common/hosts.nix
      ../common/users.nix
    ];

  # networking.hostName = "heavens"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [
    vim 
    git
  ];
}
