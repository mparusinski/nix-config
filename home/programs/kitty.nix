{ config, lib, pkgs, ...}:

{
  programs.kitty = {
    enable = true;
    settings.enable_audio_bell = false;
    settings.background_opacity = "0.9";
    settings.confirm_os_window_close = 0;
    settings.font_size = "12.0";
    settings.font_family = "Fira Code";

    # ============
    # Color scheme
    # ============
    settings.background = "#323d43";
    settings.foreground = "#d8caac";
    settings.cursor = "#d8caac";
    settings.selection_foreground = "#d8caac";
    settings.selection_background = "#505a60";
    settings.color0 = "#3c474d";
    settings.color8 = "#868d80";
    # red
    settings.color1 = "#e68183";
    # light red
    settings.color9 = "#e68183";
    # green
    settings.color2 = "#a7c080";
    # light green
    settings.color10 = "#a7c080";
    # yellow
    settings.color3 = "#d9bb80";
    # light yellow
    settings.color11 = "#d9bb80";
    # blue
    settings.color4 = "#83b6af";
    # light blue
    settings.color12 = "#83b6af";
    # magenta
    settings.color5 = "#d39bb6";
    # light magenta
    settings.color13 = "#d39bb6";
    # cyan
    settings.color6 = "#87c095";
    # light cyan
    settings.color14 = "#87c095";
    # light gray
    settings.color7 = "#868d80";
    # dark gray
    settings.color15 = "#868d80";
  };
}
