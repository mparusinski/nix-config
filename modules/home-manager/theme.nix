{
  config,
  lib,
  pkgs,
  ...
}:

{
  gtk = {
    enable = true;

    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Modern-Ice";

    theme.package = pkgs.dracula-theme;
    theme.name = "Dracula";

    iconTheme.package = pkgs.dracula-icon-theme;
    iconTheme.name = "Dracula";
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };
}
