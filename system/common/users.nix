{ lib, config, pkgs, ... }:

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
      default = ["wheel"];
      description = ''
        Extra groups for the main user. By default wheel for sudo access
      '';
    };
    hashedPassword = lib.mkOption {
      default = "$6$l1uvr/ebtdbjkm5q$77lijykp01hcqq9ghcai0oijdbf5f8duwd6b7ln.h1fyhirtjbmcagy3a6c0mqw2tnnepmrejji6fuvjppumw.";
      description = ''
        Hashed password for main user
      '';
    };
    ssh.enable = lib.mkEnableOption "Enable SSH keys for user";
    ssh.authorizedKeys = lib.mkOption {
      default = [
        "ssh-ed25519 aaaac3nzac1lzdi1nte5aaaaigszmxih0bhoewwz/scrxjsaxwxvqpqbcvml1ocphmw/"
      ];
      description = ''
        Keys for default user
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    users.users.${cfg.userName} = {
      isNormalUser = true;
      extraGroups = cfg.extraGroups;
      hashedPassword = cfg.hashedPassword;
      openssh.authorizedKeys.keys = lib.mkIf cfg.ssh.enable cfg.authorizedKeys;
    };
  };
}
