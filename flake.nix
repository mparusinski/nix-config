{
  description = "Michal's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-wsl, ... }@inputs :
  let
    lib = nixpkgs.lib // home-manager.lib;
	systems = [ "x86_64-linux" ];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    });
    machines = [ "dell-precision-7530" "wsl1" ];
  in {
    nixosConfigurations = 
      builtins.listToAttrs (builtins.map(m: {
        name = m;
        value = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # TODO: Find a better way to handle this
          modules = if (lib.strings.hasPrefix "wsl" m) then
            [
              (./system + ("/" + m) + /configuration.nix)
              nixos-wsl.nixosModules.wsl
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "hmback";
                home-manager.users."mparus" = import (./home + ("/" + m));
              }
            ] 
          else
            [
              (./hosts + ("/" + m) + /configuration.nix)
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "hmback";
                home-manager.users."mparus" = import (./hosts + ("/" + m) + /home.nix);
              }
            ];
        };
      }) machines );
  };
}
