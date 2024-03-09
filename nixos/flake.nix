{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
		rust-overlay.url = "github:oxalica/rust-overlay";
		nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, rust-overlay, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
			nixosConfigurations = {
				astolfo = nixpkgs.lib.nixosSystem {
					specialArgs = {inherit inputs;};
					modules = [ 
						./modules/nixos
						./hosts/astolfo/configuration.nix
						home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.users.sofamaniac = ./modules/common.nix;
              }
						({ pkgs, ... }: {
							nixpkgs.overlays = [ rust-overlay.overlays.default ];
							environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
						})
					];
      	};
			};
  	};
}
