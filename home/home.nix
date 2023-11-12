{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports = [ 
    ./programs/zsh.nix 
    ./programs/vim.nix
    ./programs/kitty.nix
    ./themes/default.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "michalparusinski";
  home.homeDirectory = "/home/michalparusinski";
  
  home.packages = [
    pkgs.git
    pkgs.keepassxc
    pkgs.bat
    pkgs.fzf
    pkgs.thefuck
    pkgs.mc
    pkgs.tree
    pkgs.restic
    pkgs.pulsemixer
    pkgs.arandr
    pkgs.autorandr
    pkgs.discord
    pkgs.spotify
    pkgs.htop
    pkgs.waybar
    pkgs.baobab
    pkgs.jq
  ];

  services.syncthing = {
    enable = true;
  };

  services.udiskie = {
    enable = true;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Michal Parusinski";
    userEmail = "michal@parusinski.me";
  };

}
