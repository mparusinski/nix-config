{ config, lib, pkgs, ...}:

{
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.9";
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      font_size = "12.0";
      font_family = "xft:Jet Brains Mono";
      # Black
      color0  = "#868d80";
      color8  = "#868d80";
      # Red
      color1  = "#e68183";
      color9  = "#e68183";
      # Green
      color2  = "#a7c080";
      color10 = "#a7c080";
      # Yello
      color3  = "#d9bb80";
      color11 = "#d9bb80";
      # Blue
      color4  = "#89beba";
      color12 = "#89beba";
      # Magenta
      color5  = "#d3a0bc";
      color13 = "#d3a0bc";
      # Cyan
      color6  = "#87c095";
      color14 = "#87c095";
      # White
      color7  = "#d8caac";
      color15 = "#d8caac";
    };
  };
}
