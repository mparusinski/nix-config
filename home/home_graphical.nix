{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports = [ 
    ./programs/zsh.nix 
    ./programs/vim.nix
    ./programs/kitty.nix
    ./programs/kdeconnect.nix
    ./programs/waybar.nix
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
    pkgs.discord
    pkgs.spotify
    pkgs.htop
    pkgs.baobab
    pkgs.jq
    pkgs.bottom
    pkgs.libreoffice
    pkgs.thunderbird
    pkgs.stellarium
    pkgs.pulsemixer
    pkgs.mangohud
    pkgs.gamescope
    pkgs.direnv
  ];

  services.syncthing = {
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
  home.stateVersion = "23.11";

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Michal Parusinski";
    userEmail = "michal@parusinski.me";
  };

  programs.bat = {
    config.theme = "base16";
  };

  programs.home-manager.enable = true;
}
