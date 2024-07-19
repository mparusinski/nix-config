{ config, lib, pkgs, ... }:

let
  wallpaper = builtins.fetchurl {
    url = "https://i.redd.it/t0ofiw8c1rqc1.jpeg";
    sha256 = "sha256:1yz8dl0czycawwgglg8gx23ak530sbbjhz1mdj1ghdbd2kqa5nq2";
  };
in
{
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/desktop/background" = {
      picture-uri = wallpaper;
    };
  };
}
