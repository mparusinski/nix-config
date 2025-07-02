{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/vim.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/bat.nix
    ../../modules/home-manager/theme.nix
    ../../modules/home-manager/dev/rust.nix
    ../../modules/home-manager/networks.nix
    ../../modules/home-manager/direnv.nix
    ../../modules/home-manager/vscode.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mparus";
  home.homeDirectory = "/home/mparus";

  home.packages = with pkgs; [
    keepassxc
    fzf
    thefuck
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
    ripgrep
    dunst
    w3m
    appimage-run
    bottom
    iotop
    comma
    firefox
    xonotic
    thunderbird
    openssl
    acpi
    fastfetch
    sil
  ];

  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  services.syncthing = {
    enable = true;
  };

  programs.bat = {
    config.theme = "base16";
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
