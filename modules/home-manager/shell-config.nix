{ pkgs
, ...
}:

{
  programs.fish.enable = true;
  programs.fish.shellAliases = {
    ls = "${pkgs.eza}/bin/eza -al --color=always --group-directories-first";
    nix-shell = "nix-shell --run $SHELL";
  };
  programs.fish.plugins = [
    { name = "done"; src = pkgs.fishPlugins.done.src; }
  ];
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.direnv.enable = true;
  programs.starship.enable = true;
}
