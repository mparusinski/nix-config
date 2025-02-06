{
  lib,
  config,
  pkgs,
  ...
}:
let
  applyMySQLConf =
    {
      database,
      passwordFile,
      username,
      hostname,
    }:
    pkgs.writeShellScript "applyMySQLConf" ''
      PASSWORD=$(cat ${passwordFile})
      ${pkgs.mariadb}/bin/mysql -u root -e "GRANT ALL PRIVILEGES ON ${database}.* TO '${username}'@'${hostname}' IDENTIFIED BY '$PASSWORD';"
    '';

  # Function taking a list as input and returns a string
  genSystemdScript = list: lib.strings.concatStrings (map (conf: applyMySQLConf conf + "\n") list);
  systemdScript = pkgs.writeShellScript "mysqlInitialConfiguration" ''
    ${genSystemdScript cfg.configurations}
  '';

  cfg = config.mysqlInitialConfiguration;
in
{
  options.mysqlInitialConfiguration = {
    enable = lib.mkEnableOption "Enable initial MySQL configuration";
    configurations = lib.mkOption {
      default = [ ];
      description = ''
        List of initial MySQL configurations
        For instance :
        [
            {
                database = "statsdb";
                passwordFile = config.age.secrets.statsDBPass.path;
                username = "stats_rw";
                hostname = "localhost";
            },
            ...
        ];
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.mysqlInitialConfiguration = {
      description = "Initial MySQL configuration";
      wants = [ "mysql.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        PermissionsStartOnly = true;
        RemainAfterExit = true;
        ExecStart = "${systemdScript}";
      };
    };
  };
}
