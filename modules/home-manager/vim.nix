{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-orgmode
      vim-speeddating
      vim-better-whitespace
      dracula-vim
    ];
    # settings = {
    #   ignorecase = true;
    #   expandtab = true;
    #   number = true;
    #   shiftwidth = 4;
    #   tabstop = 4;
    # };
    extraConfig = ''
      set ignorecase
      set expandtab
      set number
      set shiftwidth=2
      set tabstop=2
      au BufRead,BufNewFile xmobarrc set filetype=haskell
      inoremap jk <Esc>
      nnoremap tt :tabedit<Space>
    '';
  };
}
