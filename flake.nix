{
  description = "NixOS config for Kayros";

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
      nixosConfigurations.kayros-pc = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit hyprland; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kayros = import ./home.nix;
          
		    # Cachix для Hyprland — чтобы не компилировать часами
            nix.settings.substituters = [ "https://hyprland.cachix.org" ];
            nix.settings.trusted-public-keys = [
              "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            ];
		  }
        ];
      };
    };
}