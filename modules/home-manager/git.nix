{ config
, lib
, pkgs
, ...
}:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.email = "michal@parusinski.me";
      user.name = "Michal Parusinski";
      init.defaultBranch = "main";
      credential.helper = "store";
      pull.rebase = false;
    };
  };
}
