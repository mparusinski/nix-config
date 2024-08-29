{ config, lib, pkgs, ...}:

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
    };
    history = {
      size = 10000;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "wd" "fzf" "vi-mode" ];
      theme = "gianu";
    };
    envExtra = ''
      EDITOR=vim
      TERM=xterm
    '';
    initExtra = ''
      , () {
        nix-shell -p $1 --run $1
      }
    '';
  };
}
