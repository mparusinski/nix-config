{ lib, config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true; 
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mparus";

  environment.systemPackages = with pkgs; [
    playerctl
    kitty
  ];
}
