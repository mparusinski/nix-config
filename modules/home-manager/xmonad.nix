{
  config,
  lib,
  pkgs,
  ...
}:

{
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ./xmonad.hs;
  };

  home.file.".local/bin/what-dpi.sh" = {
    source = ./what-dpi.sh;
    recursive = true;
  };

  home.file.".local/bin/switch-dpi.sh" = {
    source = ./switch-dpi.sh;
    recursive = true;
  };

  home.file.".config/xsession/xsession.hidpi" = {
    source = ./xsession.hidpi;
    recursive = true;
  };

  home.file.".config/xsession/xsession.lowdpi" = {
    source = ./xsession.lowdpi;
    recursive = true;
  };

  home.packages = with pkgs; [
    xorg.xdpyinfo
    killall
    xfce.thunar
    autorandr
    arandr
  ];

}
