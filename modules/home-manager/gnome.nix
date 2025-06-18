{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs.gnomeExtensions; [
    gsconnect
    dash-to-dock
    caffeine
  ];

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-battery-type = "nothing";
    };
  };

}
