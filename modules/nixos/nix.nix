{
  lib,
  config,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    pre-commit
    cabal-install
  ];
}
