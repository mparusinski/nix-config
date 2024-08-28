{ config, lib, pkgs, ...}:

{
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ../programs/xmonad.hs;
  };

  home.file.".local/bin/what-dpi.sh" = {
    source = ./what-dpi.sh;
    recursive = true;
  };

  home.packages = with pkgs; [
    xorg.xdpyinfo
  ];

}
