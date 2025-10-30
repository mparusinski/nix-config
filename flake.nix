{
  description = "Michal's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    stylix.url = "github:nix-community/stylix/release-25.05";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , agenix
    , pre-commit-hooks
    , nixos-wsl
    , stylix
    , ...
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
        "wsl1"
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
        shellHook =
          let
            originShellHook = self.checks.x86_64-linux.pre-commit-check.shellHook;
          in
          ''
            ${originShellHook}
            echo "Welcome to nix development shell"
          '';
        buildInputs = self.checks.x86_64-linux.pre-commit-check.enabledPackages;
      };
      nixosConfigurations = builtins.listToAttrs (
        builtins.map
          (m: {
            name = m;
            value = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = (
                [
                  (configurationFile m)
                  agenix.nixosModules.default
                  nixos-wsl.nixosModules.default
                  stylix.nixosModules.stylix
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.useUserPackages = true;
                    home-manager.backupFileExtension = "hmback";
                    home-manager.users."mparus".imports = [
                      (homeFile m)
                    ];
                  }
                ]
              );
              specialArgs = { inherit inputs; };
            };
          })
          machines
      );
    };
}
