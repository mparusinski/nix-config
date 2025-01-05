{
  config,
  pkgs,
  inputs,
  ...
}:
let
  statsConfig = {
    db = "statsdb";
    user = "stats_rw";
  };

  setStatsDBPass = pkgs.writeShellScriptBin "set-stats-db-pass" ''
    PASSWORD=$(cat ${config.age.secrets.statsDBPass.path})
    ${pkgs.mariadb}/bin/mysql -u root -e "GRANT ALL PRIVILEGES ON ${statsConfig.db}.* TO '${statsConfig.user}'@'localhost' IDENTIFIED BY '$PASSWORD';"
  '';
in
{
  imports = [
    ./vpsadminos.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/gc.nix
    ../../modules/nixos/prometheusclient.nix
  ];

  # Specifying secrets
  age.secrets.hassBearerToken.file = ../../secrets/hassBearerToken.age;
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
      "${statsConfig.db}"
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
      {
        name = "${statsConfig.user}";
        ensurePermissions = {
          "${statsConfig.db}.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  # TODO: Create units for all DB users
  systemd.services.setdbpass = {
    description = "Set MariaDB stats db password";
    wants = [ "mysql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      PermissionsStartOnly = true;
      RemainAfterExit = true;
      ExecStart = ''
        ${setStatsDBPass}/bin/set-stats-db-pass
      '';
    };
  };

  services.grafana.enable = true;
  services.grafana.settings = {
    server = {
      http_addr = "0.0.0.0";
      http_port = 3000;
    };
  };

  # Nginx
  services.nginx.enable = true;
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
      # {
      #   job_name = "nginx";
      #   static_configs = [
      #     {
      #       targets = [ "localhost:9113" ];
      #     }
      #   ];
      # }
    ];
  };

  system.stateVersion = "24.11";
}
