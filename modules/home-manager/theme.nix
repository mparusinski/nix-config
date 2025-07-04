{
  config,
  lib,
  pkgs,
  ...
}:

{
  gtk = {
    enable = true;

    theme.package = pkgs.dracula-theme;
    theme.name = "Dracula";

    iconTheme.package = pkgs.dracula-icon-theme;
    iconTheme.name = "Dracula";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };
}
