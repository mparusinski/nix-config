{
  description = "Michal's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
      agenix,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
      machines = [
        "dell-precision-7530"
        "dbdebfrcz"
        "wsl1"
      ];
      configurationFile = m: ./hosts + ("/" + m) + /configuration.nix;
      homeFile = m: ./hosts + ("/" + m) + /home.nix;
      wslModules = m: if (lib.strings.hasPrefix "wsl" m) then [ nixos-wsl.nixosModules.wsl ] else [ ];
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        builtins.map (m: {
          name = m;
          value = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = (
              [
                (configurationFile m)
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.backupFileExtension = "hmback";
                  home-manager.users."mparus" = import (homeFile m);
                }
                agenix.nixosModules.default
              ]
              ++ (wslModules m)
            );
            specialArgs = { inherit inputs; };
          };
        }) machines
      );
    };
}
