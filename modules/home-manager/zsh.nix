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
      saq = "eval \"$(ssh-agent -s)\"";
      emacs = "emacs -nw";
      nnn = "NNN_FIFO=/tmp/nnn.fifo nnn -de";
    };
    history = {
      size = 10000;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "wd"
        "fzf"
        "vi-mode"
      ];
      theme = "gallois";
    };
    sessionVariables = {
      EDITOR = "vim";
    };
  };
}
