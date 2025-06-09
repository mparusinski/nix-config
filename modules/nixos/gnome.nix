{
  lib,
  config,
  pkgs,
  ...
}:

{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mparus";

  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ];

  services.flatpak.enable = true;
}
