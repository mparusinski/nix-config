{ config, pkgs, lib, modulesPath, ... }:

{
  imports = 
    [ ./gandicloud.nix 
      ../common/hosts.nix
      ../common/users.nix
      ../common/gc.nix
      ../common/ssh.nix
    ];

  networking.hostName = "database"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # nix.registry.splitwise-exporter.flake = inputs.splitwise-exporter;
  environment.systemPackages = with pkgs; [
    vim 
    git
  ];

  # Tailscale
  services.tailscale.enable = true;

  # Set up ZSH
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  networking.firewall.allowedTCPPorts = [ 2222 ];
}
