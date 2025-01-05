{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./vpsadminos.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/gc.nix
    ../../modules/nixos/prometheusclient.nix
  ];

  # Specifying secrets
  age.secrets.hassBearerToken.file = ../../secrets/hassBearerToken.age;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
    inputs.agenix.packages.x86_64-linux.default
  ];

  mainUser.enable = true;
  mainUser.ssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.ports = [ 2222 ];

  services.fail2ban.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 2222 ];
  };
  networking.hostName = "vps-nix-vpsfreecz";

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  time.timeZone = "Europe/Amsterdam";

  services.tailscale.enable = true;

  # MariaDB
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    # Users configuration
    # - create users metrics_ro and metrics_rw for database metricsdb
    ensureDatabases = [
      "metricsdb"
    ];
    ensureUsers = [
      {
        name = "metrics_ro";
        ensurePermissions = {
          "metricsdb.*" = "SELECT";
        };
      }
      {
        name = "metrics_rw";
        ensurePermissions = {
          "metricsdb.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  services.grafana.enable = true;
  services.grafana.settings = {
    server = {
      http_addr = "0.0.0.0";
      http_port = 3000;
    };
  };

  # Rerouting michal.parusinski.me to localhost temporarily
  networking.hosts = {
    "127.0.1.1" = [
      "michal.parusinski.me"
      "en.michal.parusinski.me"
      "fr.michal.parusinski.me"
    ];
  };

  # Wordpress
  services.wordpress.webserver = "nginx";
  services.wordpress.sites."michal.parusinski.me" = {
    package = pkgs.wordpress_6_7;
    settings = {
      WPLANG = "en_IE";
      WP_ALLOW_MULTISITE = true;
    };
  };

  # Nginx
  services.prometheus.exporters.nginx.enable = true;

  # Prometheus
  services.prometheus = {
    enable = true;
    checkConfig = false; # Otherwise will complain about secret path
    globalConfig.scrape_interval = "1m"; # "1m"
    scrapeConfigs = [
      {
        job_name = "node_dbdebfrcz";
        static_configs = [
          {
            targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
      {
        job_name = "node_homeassistant";
        metrics_path = "/metrics";
        static_configs = [
          {
            targets = [ "homeassistant:9100" ];
          }
        ];
      }
      {
        job_name = "home_mols";
        metrics_path = "/api/prometheus";
        bearer_token_file = config.age.secrets.hassBearerToken.path;
        static_configs = [
          {
            targets = [ "homeassistant:8123" ];
          }
        ];
      }
      {
        job_name = "nginx";
        static_configs = [
          {
            targets = [ "localhost:9113" ];
          }
        ];
      }
    ];
  };

  system.stateVersion = "24.11";
}
