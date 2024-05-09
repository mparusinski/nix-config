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

  # Setting up PostgreSQL
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "dailyInput" ];
    authentication = pkgs.lib.mkOverride 10 ''
      # type database  DBuser auth-method
      local all all trust
    '';
    enableTCPIP = true;
  };

  networking.firewall.allowedTCPPorts = [ 2222 5432 ];
}
