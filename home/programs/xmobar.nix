{ config, lib, pkgs, ...}:

{
  programs.xmobar.enable = true;
  programs.xmobar.extraConfig = builtins.readFile ./xmobarrc;
}
