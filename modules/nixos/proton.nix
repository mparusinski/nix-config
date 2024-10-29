{ config, pkgs, ... }:

{
  # Proton is configured imperatively (see https://medium.com/@vdugnist/how-to-send-emails-programmatically-with-protonmail-c1d760985957)
  environment.systemPackages = with pkgs; [
    protonmail-bridge
    protonmail-bridge-gui
    pass
    pinentry-curses
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  systemd.services.protonmailbridge = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Protonmail Bridge";
    serviceConfig = {
      Type = "simple";
      User = "mparus";
      ExecStart = ''${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive'';
    };
  };
}
