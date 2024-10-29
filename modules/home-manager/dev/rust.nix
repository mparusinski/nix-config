{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    rust-analyzer
    cargo
    gcc
    rustc
    rustfmt
    jetbrains.rust-rover
  ];
}
