{ pkgs
, ...
}:

{
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
