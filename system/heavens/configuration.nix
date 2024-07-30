{ config, pkgs, lib, modulesPath, ... }:

{
  imports = 
    [ ./gandicloud.nix 
      ../common/hosts.nix
      ../common/users.nix
      ../common/gc.nix
      ../common/ssh.nix
      ../common/pg.nix
    ];

  networking.hostName = "heavens"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [
    vim 
    git
  ];

  # Tailscale
  services.tailscale.enable = true;

  security.pam.services.nginx.setEnvironment = false;
  systemd.services.nginx.serviceConfig = {
    SupplementaryGroups = [ "shadow" ];
  };
  # Setting NGINX
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "michal+acme@parusinski.me";
  services.nginx = {
    enable = true;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    additionalModules = [ pkgs.nginxModules.pam ];
    virtualHosts."nassie-waker.parusinski.me" = {
      addSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://rpi1.parusinski.me:9000";
        basicAuth = { nassie = "hello"; };
      };
      locations."/ping" = {
        # Intentionally omitting authentication because we want 
        # this monitored by UptimeRobot
        proxyPass = "http://rpi1.parusinski.me:9000/ping";
      };
    };
  };

  services = {
    syncthing = {
      enable = true;
      user = "michalparusinski";
      dataDir = "/home/michalparusinski/Documents";
      configDir = "/home/michalparusinski/Documents/.config/syncthing";
      guiAddress = "0.0.0.0:8384";
    };
  };

  # Set up ZSH
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  networking.firewall.allowedTCPPorts = [ 80 443 2222 8384 ];
}
