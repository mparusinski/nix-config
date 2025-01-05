let
  # SSH public keys of the users who will be adding secrets through agenix
  mparus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSZMXih0bhOeWWZ/scrXJsaxwxVqPqBCvML1OCPhMw/";
  users = [ mparus ];

  # SSH public keys of the systems who will need to access the secrets
  vps-nix-vpsfreecz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGog+SaFVPhrq36aO9A7rC5Y/DUzSAdLcBjUdyZDdg1R";
  systems = [ vps-nix-vpsfreecz ];
in
{
  # Specify for each secret who has access to it
  "hassBearerToken.age".publicKeys = users ++ systems;
  "statsDBPass.age".publicKeys = users ++ systems;
}
