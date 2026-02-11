{ lib
, config
, pkgs
, ...
}:

let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  session = "${pkgs.hyprland}/bin/Hyprland";
  cfg = config.personalHyprland;
in
{
  options.personalHyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
  };

  config = lib.mkIf cfg.enable {
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
    # Enable this for debugging hyprland`

    # Force chromium and electron apps to use wayland
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    environment.systemPackages = with pkgs; [
      waybar
      rofi
      light
      lxqt.lxqt-policykit
      dunst
      libnotify
      hyprpaper
      brightnessctl
      playerctl
      pass-secret-service
      alsa-utils
    ];

    services.libinput = {
      enable = true;
      touchpad.tapping = false;
    };

    # XDG portals
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

    services.gvfs.enable = true;

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      hermit
      font-awesome
      nerd-fonts.hurmit
    ];

    # Power saving stuff
    services.tlp.enable = true;
  };
}
