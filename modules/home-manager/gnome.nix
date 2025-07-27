{
  config,
  lib,
  pkgs,
  ...
}:

{
  dconf.enable = true;
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-battery-type = "nothing";
    };
    "/org/gnome/mutter" = {
      workspaces-only-on-primary = "false";
    };
    "/org/gnome/desktop/interface" = {
      accent-color = "purple";
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
  };

}
