{
  lib,
  config,
  pkgs,
  ...
}:

let
  wallpaper = builtins.fetchurl {
    url = "https://get.wallhere.com/photo/mountains-digital-art-fantasy-art-pixel-art-castle-wilderness-Alps-Terrain-mountain-screenshot-computer-wallpaper-mountainous-landforms-geological-phenomenon-mountain-range-extreme-sport-623308.jpg";
    sha256 = "sha256:19nlqck4ij3symg85z46h6kmbc1nwx6r7wc7jad1rxxby11bgw1h";
  };
  cfg = config.personalXMonad;
in
{
  options.personalXMonad = {
    enable = lib.mkEnableOption "Enable XMonad";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
    services.xserver.displayManager = {
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

    services.libinput = {
      enable = true;
      touchpad.tapping = false;
    };
    services.xserver.dpi = 192;

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      fira-code
      fira-code-symbols
      font-awesome
    ];

    # Enable brightness control
    hardware.acpilight.enable = true;

    # Packages for XMonad
    environment.systemPackages = with pkgs; [
      picom
      dmenu
      glxinfo
      vulkan-tools
      kitty
    ];

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    services.udisks2.enable = true;
    services.gvfs.enable = true;
  };
}
