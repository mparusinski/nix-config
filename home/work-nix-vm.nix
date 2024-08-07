{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports = [ 
    ./programs/zsh.nix 
    ./programs/vim.nix
    ./programs/emacs.nix
    ./programs/nnn.nix
    ./programs/kitty.nix
    ./programs/gnome.nix
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
    htop
    baobab
    jq
    bottom
    direnv
    ripgrep
    gnumake
    w3m
    tmux
    bottom
    iotop
    comma
    taskwarrior
    taskwarrior-tui
    nomacs
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  dconf.settings = {
    "org/gnome/desktop/session" = {
      idle-delay = 0;
    };
    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
    };
  };

  programs.home-manager.enable = true;
}
