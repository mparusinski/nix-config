{ pkgs
, ...
}:

{
  # programs.neovim.plugins = with pkgs.vimPlugins; [
  #   coc-rust-analyzer
  # ];
  programs.neovim.coc.settings.languageserver = {
    python = {
      command = "jedi-language-server";
      filetypes = [
        "python"
      ];
      rootPatterns = [
        "venv"
      ];
    };
  };
}
