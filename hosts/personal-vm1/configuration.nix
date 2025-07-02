{ pkgs, lib, config, ... }: {
  imports = [
    ./gandicloud.nix
    ../../modules/nixos/users.nix
  ];

  mainUser.enable = true;
  mainUser.ssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.ports = [ 2222 ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      2222
    ];
  };

  networking.hostName = "personal-vm1";

  time.timeZone = "Europe/Paris";
  services.tailscale.enable = true;
}
