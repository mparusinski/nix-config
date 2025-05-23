{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    pre-commit
    cachix
  ];

  # This line is not working
  # nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
}
