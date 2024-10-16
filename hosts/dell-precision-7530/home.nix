{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports = [ 
    ../../modules/home-manager/zsh.nix 
    ../../modules/home-manager/vim.nix
    ../../modules/home-manager/emacs.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/nnn.nix
    ../../modules/home-manager/xmobar.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/xmonad.nix
    ../../modules/home-manager/bat.nix
    ../../modules/home-manager/theme.nix
    ../../modules/home-manager/dev/rust.nix
    ../../modules/home-manager/networks.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mparus";
  home.homeDirectory = "/home/mparus";
  
  home.packages = with pkgs; [
    keepassxc
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
    openarena
    firefox
    xonotic
    thunderbird
    chromium
    dbeaver-bin
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
