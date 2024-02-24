{ config, lib, pkgs, ...}:

let
  nixoslogo = builtins.fetchurl {
    url = "https://nixos.wiki/images/thumb/2/20/Home-nixos-logo.png/414px-Home-nixos-logo.png";
    sha256 = "sha256:10yx6vxj5k3nw1lb697jmm2nwil7aaq1w21c53j3h8mnyz3n6p4l";
  };
in
{
  programs.waybar = {
    enable = true;
    # systemd.enable = true;
    style = ''
      ${builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/style.css"}

      #workspaces button {
        padding: 0 0.5em;
        background-color: @surface0;
        color: @text;
        margin: 0.25em;
      }

      #workspaces button.empty {
        color: @red;
      }

      #workspaces button.visible {
        color: @blue;
      }

      #workspace button.active {
        color: @green;
      }

      #workspaces button.urgent {
        background-color: @red;
        border-radius: 1em;
        color: @text;
      }
    '';
    settings = [{
      layer = "top";
    #   position = "top";
      height = 30;
      modules-left = ["image" "hyprland/workspaces"];
      modules-center = ["hyprland/window"];
      modules-right = [
        "battery" "pulseaudio" "network" 
        "disk" "CPU" "memory" "temperature" "clock"
        "tray"
      ];
      "hyprland/workspaces" = {
        format = "{icon}";
        "disable-scroll" = false;
        "on-scroll-down" = "hyprctl dispatch workspace -1";
        "on-scroll-up" = "hyprctl dispatch workspace +1";
        "format-icons" = {
          "1" = "一";
          "2" = "二";
          "3" = "三";
          "4" = "四";
          "5" = "五";
          "6" = "六";
          "7" = "七";
          "8" = "八";
          "9" = "九";
          "10" = "〇";
        };
      };
      image = {
        "path" = nixoslogo;
        "size" = 24;
      };
    }];
  };
}
