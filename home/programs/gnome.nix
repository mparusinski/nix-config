{ config, lib, pkgs, ... }:

let
  wallpaper = builtins.fetchurl {
    url = "https://files.catbox.moe/io9ug6.jpeg";
    sha256 = "sha256:1901xjk719inl14ix4gm9wyylawn0wd1p6wdsamk8p0lj5dpjjvm";
  };
in
{
  dconf.settings = {
    "org/gnome/shell" = {
      "favorite-apps" = [
        "firefox.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/desktop/background" = {
      picture-uri = wallpaper;
    };
  };
}
