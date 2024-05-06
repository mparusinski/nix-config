{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports = [ 
    ./programs/zsh_server.nix 
    ./programs/vim.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "michalparusinski";
  home.homeDirectory = "/home/michalparusinski";
  
  home.packages = with pkgs; [
    git
    bat
    fzf
    thefuck
    mc
    tree
    restic
    htop
    jq
    ripgrep
    taskwarrior
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Michal Parusinski";
    userEmail = "michal@parusinski.me";
  };

}
