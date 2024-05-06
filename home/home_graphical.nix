{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports = [ 
    ./programs/zsh.nix 
    ./programs/vim.nix
    ./programs/kitty.nix
    # ./programs/waybar.nix
    ./programs/xmonad.nix
    ./programs/xmobar.nix
    # ./programs/hyprland.nix
    ./programs/nnn.nix
    ./themes/default.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "michalparusinski";
  home.homeDirectory = "/home/michalparusinski";
  
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
    libreoffice
    thunderbird
    stellarium
    pulsemixer
    mangohud
    gamescope
    direnv
    rofi
    ripgrep
    fractal
    dunst
    gpodder
    vlc
    gnumake
    w3m
    tmux
    autorandr
    appimage-run
    ihp-new
    ghc
    cabal2nix
    cabal-install
    nodejs # For coc-nvim
    haskellPackages.haskell-language-server
    bottom
    iotop
    taskwarrior
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
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.bat = {
    config.theme = "base16";
  };

  programs.zathura = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.home-manager.enable = true;
}
