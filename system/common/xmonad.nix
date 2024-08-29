{ lib, config, pkgs, ... }:

let
  wallpaper = builtins.fetchurl {
    url = "https://i.redd.it/t0ofiw8c1rqc1.jpeg";
    sha256 = "sha256:1yz8dl0czycawwgglg8gx23ak530sbbjhz1mdj1ghdbd2kqa5nq2";
  };
in
{
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.displayManager = {
    defaultSession = "none+xmonad";
    autoLogin.enable = true;
    autoLogin.user = "mparus";
  };
    
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.feh}/bin/feh --bg-fill ${wallpaper}
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: 192
      Xft.autohint:0
      Xft.lcdfilter: lcddefault
      Xft.hintstyle: hintfull
      Xft.hinting: 1
      Xft.antialias: 1
      Xft.rgba: rgb
    EOF
    ${pkgs.xorg.xset}/bin/xset r rate 200 50
    ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option caps:super
    ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:ralt
  '';

  # GDM
  services.xserver.enable = true;
  services.libinput = {
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

  # Enable brightness control
  hardware.acpilight.enable = true;

  # Packages for XMonad
  environment.systemPackages = with pkgs; [
    xfce.thunar
    arandr
    picom
    dmenu
    xmobar
    glxinfo
    vulkan-tools
    kitty
    xmobar
    light
    lxqt.lxqt-policykit
  ];

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.gvfs.package = lib.mkForce pkgs.gnome3.gvfs;
}
