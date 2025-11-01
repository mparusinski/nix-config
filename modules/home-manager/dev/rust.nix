{ pkgs
, ...
}:

{
  home.packages = with pkgs; [
    rust-analyzer
    cargo
    gcc
    rustc
    rustfmt
  ];

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
