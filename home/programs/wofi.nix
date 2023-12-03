{ config, lib, pkgs, ... }:

let
  colors = {
    bg_dimmer = "1e2326";
    bg_dim = "232a2e";
    bg0 = "2d353b";
    bg1 = "343f44";
    bg2 = "3d484d";
    bg3 = "475258";
    bg4 = "4f585e";
    bg5 = "56635f";
    bg_visual = "543a48";
    bg_reg = "514045";
    bg_green = "425047";
    bg_blue = "3a515d";
    bg_yellow = "4d4c43";
    fg = "d3c6aa";
    red = "e67e80";
    orange = "e69875";
    yellow = "dbbc7f";
    green = "a7c080";
    aqua = "83c092";
    blue = "7fbbb3";
    purple = "d699b6";
    grey0 = "7a8478";
    grey1 = "859289";
    grey2 = "9da9a0";
  };
in
{
  # Menus
  programs.wofi.style = ''
    window {
      margin: 0px;
      border: 2px solid #${colors.bg0};
      background-color: #${colors.bg0};
      border-radius: 15px;
    }

    #input {
      all: unset;
      min-height: 36px;
      padding: 4px 10px;
      margin: 4px;
      border: none;
      color: #${colors.fg};
      font-weight: bold;
      outline: none;
      border-radius: 15px;
      margin: 10px;
      margin-bottom: 2px;
      background-color: #${colors.bg_dim};
    }

    #inner-box {
      margin: 4px;
      padding: 10px;
      font-weight: bold;
      border-radius: 15px;
    }

    #outer-box {
      margin: 0px;
      padding: 3px;
      border: none;
      border-radius: 15px;
      border: 2px solid #${colors.bg0};
    }

    #scroll {
      margin-top: 5px;
      border: none;
      border-radius: 15px;
      margin-bottom: 5px;
    }

    #text {
      color: #${colors.fg};
    }

    #text:selected {
      color: #${colors.fg};
      margin: 0px 0px;
      border: none;
      border-radius: 15px;
      text-shadow: 2px 2px #${colors.bg4};
    }

    #entry {
      margin: 0px 0px;
      border: none;
      border-radius: 15px;
      background-color: transparent;
    }

    #entry:selected {
      margin: 0px 0px;
      border: none;
      border-radius: 15px;
      border: 2px solid #${colors.green};
      background-color: #${colors.bg_dim};
    }
  '';

}
