{ config, pkgs, ... }:

let 
  wallpaper = builtins.fetchurl {
    url = "https://i.redd.it/wkp1biib47da1.png";
    sha256 = "sha256:1n7qvpynyvvv84ma6c9fwnhy1mnbdx17i0cnmvjnhpfaxbkss6hp";
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
      ${pkgs.xorg.xset}/bin/xset r rate 200 50
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

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
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
  ];

  services.udisks2.enable = true;
}
