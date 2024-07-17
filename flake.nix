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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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
    machines = ["nassie" "thor" "heavens" "work-nix-vm"];
  in {
    homeConfigurations =
      builtins.listToAttrs (builtins.map(m: {
        name = "michalparusinski@" + m;
        value = lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            (./home + ("/" + m + ".nix"))
          ];
        };
      }) machines );
    nixosConfigurations = 
      builtins.listToAttrs (builtins.map(m: {
        name = m;
        value = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (./system + ("/" + m) + /configuration.nix)
          ];
        };
      }) machines );
  };
}
