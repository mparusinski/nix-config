{
  lib,
  config,
  pkgs,
  ...
}:

{
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
