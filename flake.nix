{
	description = "KayRos NixOS configuration";
	
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
		home-manager = {
			url = "github:nix-community/home-manager/release-24.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	
	outputs = { self, nixpkgs, home-manager, ... } @ inputs:
	
	let
		system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};
	in {
		nixpkgs.config.allowUnfree = true;
		nixosConfigurations.system = nixpkgs.lib.nixosSystem {
			inherit system;
			modules = [
				./system/configuration.nix
				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.kayros = import ./home-manager/home-manager.nix;
				}
			];
		};
	};
}