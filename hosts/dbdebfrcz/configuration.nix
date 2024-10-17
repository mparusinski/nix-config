{ config, pkgs, ... }:
{
  imports = [
    ./vpsadminos.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  users.users.mparus = {
    isNormalUser  = true;
    extraGroups  = [ "wheel" ];
    openssh.authorizedKeys.keys  = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSZMXih0bhOeWWZ/scrXJsaxwxVqPqBCvML1OCPhMw/ michal@parusinski.me" ];
  };

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  services.openssh.ports = [ 2222 ];
  #users.extraUsers.root.openssh.authorizedKeys.keys =
  #  [ "..." ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 2222 ];
  };
  networking.hostName = "dbdebfrcz";

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  time.timeZone = "Europe/Amsterdam";

  system.stateVersion = "24.05";
}
