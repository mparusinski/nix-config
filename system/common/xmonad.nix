{ config, pkgs, ... }:

let
  wallpaper = builtins.fetchurl {
    url = "https://i.redd.it/t0ofiw8c1rqc1.jpeg";
    sha256 = "sha256:1yz8dl0czycawwgglg8gx23ak530sbbjhz1mdj1ghdbd2kqa5nq2";
  };
in
{
  # Xmonad
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
  services.displayManager.defaultSession = "none+xmonad";
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.feh}/bin/feh --bg-fill ${wallpaper}
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: 96
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
  services.xserver.windowManager.xmonad.config = builtins.readFile ../common/xmonad.hs;

  # GDM
  services.xserver.enable = true;
  services.libinput = {
    enable = true;
    touchpad.tapping = false;
  };
  services.xserver.dpi = 96;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    font-awesome
  ];

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
