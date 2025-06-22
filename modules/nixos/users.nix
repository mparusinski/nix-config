{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.mainUser;
in
{
  options.mainUser = {
    enable = lib.mkEnableOption "Enable personal user";
    userName = lib.mkOption {
      default = "mparus";
      description = ''
        Main user for the system
      '';
    };
    extraGroups = lib.mkOption {
      default = [ "wheel" ];
      description = ''
        Extra groups for the main user. By default wheel for sudo access
      '';
    };
    ssh.enable = lib.mkEnableOption "Enable SSH keys for user";
    ssh.authorizedKeys = lib.mkOption {
      default = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSZMXih0bhOeWWZ/scrXJsaxwxVqPqBCvML1OCPhMw/ michal@parusinski.me"
      ];
      description = ''
        Keys for default user
      '';
    };
    password.enable = lib.mkEnableOption "Enable hashed password file for user";
    password.hashedPasswordFile = lib.mkOption {
      description = ''
        Password file for user
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    users.users.${cfg.userName} = {
      isNormalUser = true;
      extraGroups = cfg.extraGroups;
      openssh.authorizedKeys.keys = lib.mkIf cfg.ssh.enable cfg.ssh.authorizedKeys;
      hashedPasswordFile = lib.mkIf cfg.password.enable cfg.password.hashedPasswordFile;
    };
  };
}
