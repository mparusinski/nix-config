{
  description = "Michal's NixOS configuration";

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
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs :
  let
    lib = nixpkgs.lib // home-manager.lib;
	systems = [ "x86_64-linux" ];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    });
    machines = [ "dell-precision-7530" ];
  in {
    homeConfigurations =
      builtins.listToAttrs (builtins.map(m: {
        name = "mparus@" + m;
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
          specialArgs = inputs;
          modules = [
            (./system + ("/" + m) + /configuration.nix)
          ];
        };
      }) machines );
  };
}
