{ config, pkgs, lib, ... }:

{
  # Changing SSH port
  services.openssh = {
    enable = true;
    ports = [2222];
    PermitRootLogin = "no";
  };
}
