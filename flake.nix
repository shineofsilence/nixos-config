{
	description = "KayRos NixOS configuration";
	
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
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
				./hosts/configuration.nix
				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.kayros = import ./home_manager/home_manager.nix;
				}
			];
		};
		# Добавь это:
		packages.${system}.system = nixosSystem.config.system.build.toplevel;
	};
}