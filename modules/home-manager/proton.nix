{ pkgs
, ...
}:

{
  services.protonmail-bridge.enable = true;
  services.protonmail-bridge.extraPackages = with pkgs; [
    pass
  ];
}
