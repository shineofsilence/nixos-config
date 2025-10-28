{
  description = "Моя NixOS-система";

  # Входы: откуда брать nixpkgs и home-manager
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";  # используем ту же версию nixpkgs
    };
  };

  # Выходы: что предоставляет этот флейк
  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";  # архитектура
    in {
      # Системная конфигурация NixOS
      nixosConfigurations.system = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix          # твой основной конфиг
          home-manager.nixosModules.home-manager  # модуль Home Manager
          {
            # Настройка Home Manager внутри NixOS
            home-manager.useGlobalPkgs = true;   # использовать пакеты из systemPackages
            home-manager.useUserPackages = true; # разрешить home.packages
            home-manager.users.kayros = import ./home_manager/hm.nix;
          }
        ];
      };

      # Отдельная конфигурация Home Manager (для команды home-manager switch --flake)
      homeConfigurations.kayros = home-manager.lib.homeManagerConfiguration {
        inherit system;
        modules = [ ./home_manager/hm.nix ];
      };
    };
}