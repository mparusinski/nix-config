{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports = [ 
    ../../modules/home-manager/zsh.nix 
    ../../modules/home-manager/vim.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/bat.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mparus";
  home.homeDirectory = "/home/mparus";
  
  home.packages = with pkgs; [
    git
    fzf
    mc
    tree
    htop
    ripgrep
    iotop
    comma
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";
}
