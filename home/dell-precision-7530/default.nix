{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports = [ 
    ../programs/zsh.nix 
    ../programs/vim.nix
    ../programs/emacs.nix
    ../programs/kitty.nix
    ../programs/nnn.nix
    ../programs/xmobar.nix
    ../programs/git.nix
    ../scripts
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mparus";
  home.homeDirectory = "/home/mparus";
  
  home.packages = with pkgs; [
    git
    keepassxc
    bat
    fzf
    thefuck
    mc
    tree
    discord
    spotify
    htop
    baobab
    jq
    bottom
    stellarium
    pulsemixer
    mangohud
    gamescope
    direnv
    rofi
    ripgrep
    dunst
    w3m
    autorandr
    appimage-run
    ghc
    bottom
    iotop
    comma
  ];

  services.syncthing = {
    enable = true;
  };

  programs.bat = {
    config.theme = "base16";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zathura = {
    enable = true;
    # package = "zathura-pdf-mupdf";
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
