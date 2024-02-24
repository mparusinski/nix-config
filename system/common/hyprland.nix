{ config, pkgs, ... }:

{
  # Hyprland
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  # We also enable sway (for swaylock)
  programs.sway.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    font-awesome
  ];

  # Enable brightness control
  programs.light.enable = true;

  # Packages for Hyprland
  environment.systemPackages = with pkgs; [
    wofi
    waybar
    glxinfo
    vulkan-tools
    hyprpaper
    pulseaudio
    kitty
  ];

  # File manager
  programs.thunar.enable = true;

  # Xdg portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  services.udisks2.enable = true;
}
