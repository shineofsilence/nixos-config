{
  description = "Моя NixOS-система с Hyprland из GitHub";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    hyprland.url = "github:hyprwm/Hyprland";  # ← свежая версия (0.47.0+)
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, hyprland, home-manager, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.system = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs hyprland; };  # ← передаём hyprland в модули
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            # Включаем Cachix для Hyprland
            nix.settings = {
              substituters = [ "https://hyprland.cachix.org" ];
              trusted-public-keys = [
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
              ];
            };

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kayros = import ./home_manager/hm.nix;
          }
        ];
      };

      homeConfigurations.kayros = home-manager.lib.homeManagerConfiguration {
        inherit system;
        modules = [ ./home_manager/hm.nix ];
      };
    };
}