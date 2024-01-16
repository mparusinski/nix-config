{ config, pkgs, ... }:

{
  # GDM
  services.xserver.enable = true;
  services.xserver.libinput = {
    enable = true;
    touchpad.tapping = false;
  };
  services.xserver.dpi = 192;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    font-awesome
  ];

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable brightness control
  programs.light.enable = true;

  # Packages for XMonad
  environment.systemPackages = with pkgs; [
    xfce.thunar
    arandr
    picom
    dmenu
    xmobar
    glxinfo
    vulkan-tools
  ];

  services.udisks2.enable = true;
}
