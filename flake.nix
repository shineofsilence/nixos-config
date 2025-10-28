{
  description = "Kayros NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.system = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kayros = {
				imports = [
							./home_manager/zsh.nix
							./home_manager/git.nix
							./home_manager/hyprland.nix
							];
				home.username = "kayros";
				home.homeDirectory = "/home/kayros";
				home.stateVersion = "25.05";
			};
          }
        ];
      };
    };
}