{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michalparusinski = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "cdrom" "libvirtd" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$6$l1uvR/ebtdbjkm5q$77LijykP01hCqq9GhCai0OiJdBf5F8DUWd6b7lN.h1fYHIrTjbmCaGy3A6c0mQw2tnNEPmrejJI6fuVjppumW.";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEdFq2P7sTwlSFXtNFo6COusxYsurhplAqfVKUYTTdtK michalparusinski@thor-2023-10-15"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQGLsxxOqk73YS+kYTm3Vmv3vGBrjAuBYhzER2nSJ2R michal@parusinski.me"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0aD+rWthlxWD2ruuqiz0NOuG4lLxF4SFQmOfQO/tgK michal@parusinski.me"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPpkr01G9ysaV64zmETrwhpwqQoRDaMCzmbUOy0wMHpr michal@parusinski.me"
    ];
  };
  users.users.marjolaineperez = {
    isNormalUser = true;
    hashedPassword = "$6$Ug3dp395tU9ZZrUj$urA8z3p61DIMUjdH3aT9HjzM9vm4q09GEibMP3BByvPO1ACu9L.TtF3O.a3OpRUVLyrJ0YPZFzccuL7UTchou0";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
