{ config, pkgs, ... }:
{
  imports = [
    ./vpsadminos.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/gc.nix
    ../../modules/nixos/prometheusclient.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  mainUser.enable = true;
  mainUser.ssh.enable = true;

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.ports = [ 2222 ];

  services.fail2ban.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 2222 ];
  };
  networking.hostName = "dbdebfrcz";

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  time.timeZone = "Europe/Amsterdam";

  services.tailscale.enable = true;

  # PostgreSQL
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      host  pgmetricsdb  pgmetricsuser     0.0.0.0/0 scram-sha-256
      host  pgmetricsdb  pgmetricsuser     ::1/128 scram-sha-256
    '';
  };

  services.grafana.enable = true;
  services.grafana.settings = {
    server = {
      http_addr = "0.0.0.0";
      http_port = 3000;
    };
  };

  # Prometheus
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "1m"; # "1m"
    scrapeConfigs = [
      {
        job_name = "node_dbdebfrcz";
        static_configs = [{
          targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
      {
        job_name = "node_homeassistant";
        metrics_path = "/metrics";
        static_configs = [{
          targets = [ "homeassistant:9100" ];
        }];
      }
      {
        job_name = "home_mols";
        metrics_path = "/api/prometheus";
        bearer_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJkZmU5MDhhYzEwZDI0ZmQ4ODE0MWYxMTA5ODM4OWMxNCIsImlhdCI6MTcyODc1ODMzNywiZXhwIjoyMDQ0MTE4MzM3fQ.gSd9LfPm2QultokAAcALIeZTLcgbAZU6uy0U-Z05_LA";
        # bearer_token_file = "/etc/secrets/homeassistant_bearer_token";
        static_configs = [{
          targets = [ "homeassistant:8123" ];
        }];
      }
    ];
  };

  system.stateVersion = "24.05";
}
