{ config
, ...
}:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "Michal Parusinski";
      user.email = "michal@parusinski.me";
      init.defaultBranch = "main";
      credential.helper = "store";
      pull.rebase = false;
    };
  };
}
