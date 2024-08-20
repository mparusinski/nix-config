{ config, pkgs, ... }:

{
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.mparus = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "cdrom" "libvirtd" ];
    hashedPassword = "$6$l1uvr/ebtdbjkm5q$77lijykp01hcqq9ghcai0oijdbf5f8duwd6b7ln.h1fyhirtjbmcagy3a6c0mqw2tnnepmrejji6fuvjppumw.";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 aaaac3nzac1lzdi1nte5aaaaigszmxih0bhoewwz/scrxjsaxwxvqpqbcvml1ocphmw/"
    ];
  };
}
