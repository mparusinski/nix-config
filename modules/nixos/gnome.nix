{ lib
, config
, pkgs
, ...
}:

let
  cfg = config.personalGnome;
in
{
  options.personalGnome = {
    enable = lib.mkEnableOption "Enable Gnome personal configuration";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
    services.displayManager.autoLogin.user = "mparus";

    environment.systemPackages = with pkgs; [
      gnomeExtensions.caffeine
      gnomeExtensions.blur-my-shell
    ];

    environment.gnome.excludePackages = with pkgs; [
      epiphany
      geary
    ];

    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}
