{ config, pkgs, ... }:

let 
  wallpaper = builtins.fetchurl {
    url = "https://i.redd.it/0d7drj9okdv91.jpg";
    sha256 = "sha256:0jz5id588nlvlprnvhw12p919br3lqm27bfd7lqv3pm35qxw6d8j";
  };
in
{
  # GDM
  services.xserver.enable = true;
  services.xserver.libinput = {
    enable = true;
    touchpad.tapping = false;
  };
  services.xserver.displayManager = {
    defaultSession = "none+xmonad";
    sessionCommands = ''
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
      ${pkgs.xorg.xset}/bin/xset r rate 150 50
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option caps:super
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:ralt
    '';
  };
  services.xserver.windowManager = {
    xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = builtins.readFile ../xmonad/xmonad.hs;
    };
  };
  services.xserver.dpi = 192;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Packages for XMonad
  environment.systemPackages = with pkgs; [
    xfce.thunar
    arandr
    picom
    dmenu
  ];

  services.udisks2.enable = true;
}
