{ config, pkgs, ... }:

{
  # GDM
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.flatpak.enable = true;

  # Enable sound.
  sound.enable = true;

  # Gnome extras
  environment.systemPackages = with pkgs; [
    gnome3.gnome-tweaks
    evince
  ];
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Enable DConf
  programs.dconf.enable = true;
}
