{ config, pkgs, ... }:

{
  # Setting up PostgreSQL
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "simpleDailyInput" ];
    authentication = pkgs.lib.mkOverride 10 ''
      # type database  DBuser auth-method
      local all all trust
    '';
  };
}
