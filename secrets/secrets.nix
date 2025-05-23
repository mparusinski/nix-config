let
  # SSH public keys of the users who will be adding secrets through agenix
  mparus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSZMXih0bhOeWWZ/scrXJsaxwxVqPqBCvML1OCPhMw/";
  users = [ mparus ];

  # SSH public keys of the systems who will need to access the secrets
  frcz-vps1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKOCq0Z8wd7a8psBf9rL40pGW+/upq2+y+eSvq64/SlT";
  systems = [ frcz-vps1 ];
in
{
  # Specify for each secret who has access to it
  "statsDBPass.age".publicKeys = users ++ systems;
}
