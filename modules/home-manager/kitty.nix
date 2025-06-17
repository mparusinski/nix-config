{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.kitty = {
    enable = true;
    settings.enable_audio_bell = false;
    settings.background_opacity = "0.9";
    settings.visual_bell_duration = "0.5";
    settings.confirm_os_window_close = 0;
    settings.font_size = "12.0";
    settings.font_family = "iosevka";
    settings.allow_remote_control = true;
    settings.listen_on = "unix:/tmp/mykitty";
    settings.enabled_layouts = "splits";
    settings.themeFile = "Dracula";
  };
  home.packages = with pkgs; [
    iosevka
  ];
}
