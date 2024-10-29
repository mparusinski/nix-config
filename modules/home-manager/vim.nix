{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-orgmode
      vim-speeddating
    ];
    settings = {
      ignorecase = true;
      expandtab = true;
      number = true;
      shiftwidth = 4;
      tabstop = 4;
    };
    extraConfig = ''
      au BufRead,BufNewFile xmobarrc set filetype=haskell
      inoremap jk <Esc>
    '';
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-orgmode
      vim-speeddating
    ];
    extraConfig = ''
      syntax on
      set number
      set shiftwidth=4
      set tabstop=4
      set ignorecase
      set expandtab
      au BufRead,BufNewFile xmobarrc set filetype=haskell
      inoremap jk <Esc>
    '';
  };
}
