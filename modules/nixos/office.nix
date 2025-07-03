{
  lib,
  config,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    libreoffice
    hunspell
    hunspellDicts.fr_FR
    hunspellDicts.en_IE
  ];
}
