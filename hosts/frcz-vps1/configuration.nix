{
  config,
  pkgs,
  inputs,
  ...
}:
let
  statsConfig = {
    database = "statsdb";
    passwordFile = config.age.secrets.statsDBPass.path;
    username = "stats_rw";
    hostname = "localhost";
  };
  statsConfig_remote = {
    database = "statsdb";
    passwordFile = config.age.secrets.statsDBPass.path;
    username = "stats_rw";
    hostname = "dell-precision-7530-1.taild5a36.ts.net";
  };
in
{
  imports = [
    ./vpsadminos.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/gc.nix
    ../../modules/nixos/prometheusclient.nix
    ../../modules/nixos/mysql.nix
  ];

  # Specifying secrets
  age.secrets.statsDBPass.file = ../../secrets/statsDBPass.age;

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
  services.fail2ban.jails = {
    nginx-http-auth = ''
      enabled  = true
      port     = http,https
      logpath  = /var/log/nginx/*.log
      backend  = polling
      journalmatch =
    '';
    nginx-botsearch = ''
      enabled  = true
      port     = http,https
      logpath  = /var/log/nginx/*.log
      backend  = polling
      journalmatch =
    '';
    nginx-bad-request = ''
      enabled  = true
      port     = http,https
      logpath  = /var/log/nginx/*.log
      backend  = polling
      journalmatch =
    '';
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
      2222
    ];
  };
  networking.hostName = "frcz-vps1";

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  time.timeZone = "Europe/Amsterdam";

  services.tailscale.enable = true;

  # MariaDB
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    settings = {
      mysqld = {
        skip-networking = "0";
        # We allow localhost connections, and one via tailscale (the IP below
        # is the tailscale IP of frcz-vps1)
        bind-address = "localhost,100.122.154.117";
      };
    };
    # Users configuration
    # - create users metrics_ro and metrics_rw for database metricsdb
    ensureDatabases = [
      "${statsConfig.database}"
    ];
    ensureUsers = [
      {
        name = "${statsConfig.username}";
        ensurePermissions = {
          "${statsConfig.database}.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  mysqlInitialConfiguration.enable = true;
  mysqlInitialConfiguration.configurations = [
    statsConfig
    statsConfig_remote
  ];

  services.grafana.enable = true;
  services.grafana.settings = {
    server = {
      http_addr = "0.0.0.0";
      http_port = 3000;
    };
  };

  # Nginx
  services.nginx.enable = true;
  services.nginx.statusPage = true;
  services.prometheus.exporters.nginx.enable = true;

  # Matomo (self hosted alternative to Google Analytics)
  services.matomo = {
    enable = true;
    package = pkgs.matomo_5;
    hostname = "stats.parusinski.me";
    nginx = {
      serverName = "stats.parusinski.me";
    };
  };
  security.acme.certs."stats.parusinski.me".email = "michal@parusinski.me";
  security.acme.acceptTerms = true;

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
