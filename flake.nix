{
  description = "Michal's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib // inputs.home-manager.lib;
      systems = [ "x86_64-linux" ];
      forAllSystems = lib.genAttrs systems;
      pkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
      machines = [
        "dell-precision-7530"
        "frcz-vps1"
      ];
      configurationFile = m: ./hosts + ("/" + m) + /configuration.nix;
      homeFile = m: ./hosts + ("/" + m) + /home.nix;
      # Setup for every system
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
          };
        };
      });
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          inputs.agenix.packages.x86_64-linux.default
        ];
      };
      nixosConfigurations = builtins.listToAttrs (
        builtins.map (m: {
          name = m;
          value = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = (
              [
                (configurationFile m)
                inputs.home-manager.nixosModules.home-manager
                {
                  inputs.home-manager.useGlobalPkgs = true;
                  inputs.home-manager.useUserPackages = true;
                  inputs.home-manager.backupFileExtension = "hmback";
                  inputs.home-manager.users."mparus" = import (homeFile m);
                }
              ]
            );
            specialArgs = { inherit inputs; };
          };
        }) machines
      );
    };
}
