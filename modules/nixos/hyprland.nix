{ lib, config, pkgs, ... }:

# let
#   wallpaper = builtins.fetchurl {
#     url = "https://i.redd.it/t0ofiw8c1rqc1.jpeg";
#     sha256 = "sha256:1yz8dl0czycawwgglg8gx23ak530sbbjhz1mdj1ghdbd2kqa5nq2";
#   };
# in
{
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  environment.systemPackages = with pkgs; [
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    ) # TODO: try out eww
    rofi-wayland
    xfce.thunar
    light
    lxqt.lxqt-policykit
    dunst
    libnotify
    hyprpaper
    brightnessctl
    playerctl
  ];

  services.libinput = {
    enable = true;
    touchpad.tapping = false;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    font-awesome
  ];

  # XDG portals
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
}
