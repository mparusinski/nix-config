{ config
, lib
, pkgs
, ...
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
      SimpylFold
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
      nnoremap <C-J> <C-W><C-J>
      nnoremap <C-K> <C-W><C-K>
      nnoremap <C-L> <C-W><C-L>
      nnoremap <C-H> <C-W><C-H>
      set foldmethod=indent
      set foldlevel=99
      let g:SimpylFold_docstring_preview=1

      au BufNewFile,BufRead *.py set tabstop=4
      au BufNewFile,BufRead *.py set softtabstop=4
      au BufNewFile,BufRead *.py set shiftwidth=4
      au BufNewFile,BufRead *.py set textwidth=79
      au BufNewFile,BufRead *.py set expandtab
      au BufNewFile,BufRead *.py set autoindent
      au BufNewFile,BufRead *.py set fileformat=unix
    '';
  };
}
