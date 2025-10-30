{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Michal Parusinski";
    userEmail = "michal@parusinski.me";
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "store";
      pull.rebase = false;
    };
  };
}
