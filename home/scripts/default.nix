{ config, lib, pkgs, ...}:

{
  home.file = {
    ".local/bin" = {
      source = ./bin;
      recursive = true;
    };
  };
}
