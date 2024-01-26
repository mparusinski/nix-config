{ config, pkgs, lib, modulesPath, splitwise-exporter, ... }:

{
  imports = 
    [ ./gandicloud.nix 
      ../common/hosts.nix
      ../common/users.nix
    ];

  networking.hostName = "heavens"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # nix.registry.splitwise-exporter.flake = inputs.splitwise-exporter;
  environment.systemPackages = with pkgs; [
    vim 
    git
    splitwise-exporter.packages.${pkgs.system}.splitwise-exporter
  ];

  # Changing SSH port
  services.openssh = {
    enable = true;
    ports = [2222];
  };

  # Tailscale
  services.tailscale.enable = true;

  # Setting NGINX
  security.pam.services.nginx.setEnvironment = false;
  systemd.services.nginx.serviceConfig = {
    SupplementaryGroups = [ "shadow" ];
  };

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
        extraConfig = ''
          auth_pam  "Password Required";
          auth_pam_service_name "nginx";
        '';
      };
      locations."/ping" = {
        # Intentionally omitting authentication because we want 
        # this monitored by UptimeRobot
        proxyPass = "http://rpi1.parusinski.me:9000/ping";
      };
    };
  };

  # # Autoexporting splitwise systemd unit
  # systemd.services.splitwise-exporter = {
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network.target" ];
  #   description = "Automatic export of splitwise data (SERVICE)";
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "michalparusinski";
  #     ExecStart = ''${inputs.splitwise-exporter.packages.x86_64-linux.splitwise-exporter}/bin/splitwise_exporter'';
  #   };
  # };
  # systemd.timers.splitwise-exporter = {
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network.target" ];
  #   description = "Automatic export of splitwise data (TIMER)";
  #   timerConfig = {
  #     OnCalendar = "daily";
  #     Unit = "splitwise-exporter.service";
  #   };
  # };

  # Set up ZSH
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  networking.firewall.allowedTCPPorts = [ 80 443 2222 ];
}
