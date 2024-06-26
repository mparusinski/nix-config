{
  description = "Michal's NixOS configuration";

  # Setting up cache servers
  nixConfig = {
    substituters = [
      "https://cache.nixos.org/"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # This is the standard format for flake.nix.
  # `inputs` are the dependencies of the flake,
  # and `outputs` function will return all the build results of the flake.
  # Each item in `inputs` will be passed as a parameter to
  # the `outputs` function after being pulled and built.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    splitwise-exporter.url = "github:mparusinski/splitwise_exporter";
  };

  outputs = { self, nixpkgs, home-manager, splitwise-exporter, ... }@inputs :
  let
    lib = nixpkgs.lib // home-manager.lib;
	systems = [ "x86_64-linux" ];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    });
  in {
    homeConfigurations = {
      "michalparusinski@thor" = lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          ./home/home_graphical.nix 
        ];
      };
      "mparusinski@DESKTOP-5A9CEH7" = lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          ./home/home_wsl.nix 
        ];
      };
      "michalparusinski@heavens" = lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          ./home/home_console.nix 
        ];
      };
      "michalparusinski@nassie" = lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          ./home/home_console.nix 
        ];
      };
      "michalparusinski@database" = lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home/home_console.nix
        ];
      };
    };
    nixosConfigurations = {
      # NAS server
      nassie = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./system/nassie/configuration.nix
        ];
      };
      # Main personal laptop (thor)
      thor = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./system/thor/configuration.nix
        ];
      };
      # Gandi VPS server
      heavens = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs; 
        modules = [ 
          ./system/heavens/configuration.nix
          # ({ config, pkgs, ...}: { nixpkgs.overlays = [ splitwise-exporter.overlays.default]; })
        ];
      };
      database = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./system/database/configuration.nix
        ];
      };
    };
  };
}
