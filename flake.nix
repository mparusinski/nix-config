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
      home-manager,
      agenix,
      pre-commit-hooks,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
      machines = [
        "dell-precision-7530"
        "personal-vm1"
        "frcz-vps1"
      ];
      configurationFile = m: ./hosts + ("/" + m) + /configuration.nix;
      homeFile = m: ./hosts + ("/" + m) + /home.nix;
      # Setup for every system
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      checks = forAllSystems (system: {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
            convco.enable = true;
          };
        };
      });
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          agenix.packages.x86_64-linux.default
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
                agenix.nixosModules.default
                home-manager.nixosModules.home-manager
                {
                  home-manager.useUserPackages = true;
                  home-manager.backupFileExtension = "hmback";
                  home-manager.users."mparus" = import (homeFile m);
                }
              ]
            );
            specialArgs = { inherit inputs; };
          };
        }) machines
      );
    };
}
