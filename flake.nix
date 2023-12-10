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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
	hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs :
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
          hyprland.homeManagerModules.default
          { wayland.windowManager.hyprland.enable = true; }
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
    };
    nixosConfigurations = {
      # NAS server
      nassie = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./system/nassie/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.michalparusinski = import ./home/home_console.nix;
          }
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
      "heavens.novalocal" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./system/heavens/configuration.nix
        ];
      };
    };
  };
}
