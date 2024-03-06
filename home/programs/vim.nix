{ config, lib, pkgs, ...}:

{
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline ];
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
    plugins = with pkgs.vimPlugins; [ vim-airline ];
    extraConfig = ''
      set number
      set expandtab
      set ignorecase
      set shiftwidth=4
      set tabstop=4
      au BufRead,BufNewFile xmobarrc set filetype=haskell
      inoremap jk <Esc>
    '';
    coc = {
      enable = true;
      settings = {
        "suggest.noselect" = true;
        "suggest.enablePreview" = true;
        "suggest.enablePreselect" = false;
        "suggest.disableKind" = true;
        languageserver = {
          haskell = {
            command = "haskell-language-server-wrapper";
            args = [ "--lsp" ];
            rootPatterns = [
              "*.cabal"
              "stack.yaml"
              "cabal.project"
              "package.yaml"
              "hie.yaml"
            ];
            filetypes = [ "haskell" "lhaskell" ];
          };
        };
      };
    };
  };
}
