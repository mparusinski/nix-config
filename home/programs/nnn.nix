{ config, lib, pkgs, ... }:

{
  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override { 
      withNerdIcons = true;
    };
    plugins = {
      # It is essential to specify something here
      # to have plugins otherwise the plugins folder is
      # empty. And none of the plugins will work
      src = (pkgs.fetchFromGitHub {
        owner = "jarun";
        repo = "nnn";
        rev = "v4.0";
        sha256 = "sha256-Hpc8YaJeAzJoEi7aJ6DntH2VLkoR6ToP6tPYn3llR7k=";
      }) + "/plugins";
      mappings = {
        i = "ipinfo";
        p = "preview-tui";
        c = "fzcd";
      };
    };
  };
}
