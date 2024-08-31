{ config, lib, pkgs, ...}:

{
  programs.kitty = {
    enable = true;
    settings.enable_audio_bell = false;
    settings.confirm_os_window_close = 0;
    settings.font_size = "12.0";
    settings.font_family = "Fira Code";
    settings.allow_remote_control = true;
    settings.listen_on = "unix:/tmp/mykitty";
    settings.enabled_layouts = "splits";
  };
  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];
}
