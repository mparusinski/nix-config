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
  };

}
