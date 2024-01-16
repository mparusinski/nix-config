{ config, lib, pkgs, ...}:

{
  programs.kitty = {
    enable = true;
    settings.enable_audio_bell = false;
    settings.confirm_os_window_close = 0;
    settings.font_size = "12.0";
    settings.font_family = "Fira Code";
    theme = "Everforest Dark Medium";
  };
}
