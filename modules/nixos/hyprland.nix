{
  lib,
  config,
  pkgs,
  ...
}:

# let
#   wallpaper = builtins.fetchurl {
#     url = "https://i.redd.it/t0ofiw8c1rqc1.jpeg";
#     sha256 = "sha256:1yz8dl0czycawwgglg8gx23ak530sbbjhz1mdj1ghdbd2kqa5nq2";
#   };
# in
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "${pkgs.hyprland}/bin/Hyprland";
  username = "mparus";
in
{
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${session}";
        user = "mparus";
      };
      default_session = {
        command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd ${session}";
        user = "mparus";
      };
    };
  };

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  environment.systemPackages = with pkgs; [
    waybar
    rofi-wayland
    xfce.thunar
    light
    lxqt.lxqt-policykit
    dunst
    libnotify
    hyprpaper
    brightnessctl
    playerctl
    pass-secret-service
  ];

  services.libinput = {
    enable = true;
    touchpad.tapping = false;
  };

  # XDG portals
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  services.gvfs.enable = true;

  services.flatpak.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    cantarell-fonts
    fira-code
    fira-code-symbols
    font-awesome
  ];

  security.pam.services.greetd.enableGnomeKeyring = true;
}
