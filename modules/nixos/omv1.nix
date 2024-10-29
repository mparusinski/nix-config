{ config, pkgs, ... }:

{
  fileSystems."/media/omv1/NAS" = {
    device = "//omv1/NAS";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100" ];
  };
}
