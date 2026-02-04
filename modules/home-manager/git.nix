{ config
, lib
, pkgs
, ...
}:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings.user.name = "Michal Parusinski";
    settings.user.email = "michal@parusinski.me";
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "store";
      pull.rebase = false;
    };
  };
}
