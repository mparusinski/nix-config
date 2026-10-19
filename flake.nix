{
  description = "Michal's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , pre-commit-hooks
    , nixos-wsl
    , ...
    }@inputs:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      machines = [
        "dell-precision-7530"
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
          hooks.nixpkgs-fmt.enable = true;
        };
      });
      devShells.x86_64-linux.default = pkgs.mkShell {
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
        map
          (m: {
            name = m;
            value = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [
                (configurationFile m)
                nixos-wsl.nixosModules.default
                home-manager.nixosModules.home-manager
                {
                  home-manager.useUserPackages = true;
                  home-manager.backupFileExtension = "hmback";
                  home-manager.users."mparus".imports = [
                    (homeFile m)
                  ];
                }
              ];
              specialArgs = { inherit inputs; };
            };
          })
          machines
      );
    };
}
