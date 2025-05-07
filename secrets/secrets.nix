let
  # SSH public keys of the users who will be adding secrets through agenix
  mparus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSZMXih0bhOeWWZ/scrXJsaxwxVqPqBCvML1OCPhMw/";
  users = [ mparus ];

  # SSH public keys of the systems who will need to access the secrets
  frcz-vps1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQQIL4nT/ydLmWaWjLL9FDmckNCcDzgnO3PVsJEbZ9g";
  systems = [ frcz-vps1 ];
in
{
  # Specify for each secret who has access to it
  "hassBearerToken.age".publicKeys = users ++ systems;
  "statsDBPass.age".publicKeys = users ++ systems;
  "metricsRWPass.age".publicKeys = users ++ systems;
}
