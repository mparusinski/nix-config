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
    hunspellDicts.fr-any
    hunspellDicts.en_GB-ise
  ];
}
