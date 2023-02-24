{ config, lib, pkgs, ...}:

{
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.9";
      enable_audio_bell = false;
      font_size = "12.0";
      font_family = "Fira Code";
    };
  };
}
