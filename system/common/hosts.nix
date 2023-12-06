{ config, pkgs, ... }:

{
  networking.extraHosts = 
    ''
      46.226.104.203 heavens
    '';
}
