{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      am = "pulsemixer";
      gp = "git push";
      ga = "git add";
      gd = "git diff";
      nix-shell = "nix-shell --run $SHELL";
      saq = "eval \"$(ssh-agent -s)\"";
    };
    history = {
      size = 10000;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "wd"
        "vi-mode"
      ];
      theme = "gallois";
    };
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
