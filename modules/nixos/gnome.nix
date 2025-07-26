{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.personalGnome;
in
{
  options.personalGnome = {
    enable = lib.mkEnableOption "Enable Gnome personal configuration";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.displayManager.autoLogin.user = "mparus";

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnomeExtensions.caffeine
    ];

    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}
