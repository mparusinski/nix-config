let
  # SSH public keys of the users who will be adding secrets through agenix
  mparus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJCizmOo5KevfHd6pqwxVjgvVYWv4Az5TbAclvuhF2AC";
  users = [ mparus ];

  # SSH public keys of the systems who will need to access the secrets
  dbdebfrcz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDA1+TbC/tXsVAKUjSzipoC0ibOgSWuNvzVdb8Xxwi0T";
  systems = [ dbdebfrcz ];
in
  {
    # Specify for each secret who has access to it
    "hassBearerToken.age".publicKeys = users ++ systems;
  }
