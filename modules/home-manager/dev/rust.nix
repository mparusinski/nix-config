{ pkgs
, ...
}:

{
  # programs.neovim.plugins = with pkgs.vimPlugins; [
  #   coc-rust-analyzer
  # ];
  programs.neovim.coc.settings.languageserver = {
    rust = {
      command = "rust-analyzer";
      filetypes = [
        "rust"
      ];
      rootPatterns = [
        "Cargo.toml"
      ];
    };
  };
}
