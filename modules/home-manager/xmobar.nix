{ config, lib, pkgs, ...}:

{
  programs.xmobar.enable = true;
  home.file.".config/xmobar/xmobarrc.hidpi" = {
    source = ./xmobarrc.hidpi;
    recursive = true;
  };
  home.file.".config/xmobar/xmobarrc.lowdpi" = {
    source = ./xmobarrc.lowdpi;
    recursive = true;
  };
}
