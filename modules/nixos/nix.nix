{ lib, config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.nixfmt-rfc-style ];
}
