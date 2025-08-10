{
  config,
  lib,
  pkgs,
  ...
}:

let
  wallpaper = ../../static/wallpaper.png;
in
{
  home.file.".config/hypr/hyprland.conf".source = ../../dotfiles/hyprland.conf;
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ${wallpaper}
    wallpaper = ,${wallpaper}
  '';

}
