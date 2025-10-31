{
  description = "Kayros' Declarative NixOS System";

  # Входные данные (источники) для Flake
  inputs = {
    # Главный репозиторий Nixpkgs (стабильная версия)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11"; # Используем более стабильную версию для надежности
    
    # Репозиторий Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11"; # Версия, соответствующая nixpkgs
      # Подключаем nixpkgs, чтобы Home Manager использовал тот же набор пакетов
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Репозиторий Hyprland (часто нужен для самых свежих версий, но мы можем использовать nixpkgs)
    # Если нужно, можно добавить:
    # hyprland.url = "github:hyprland-community/flake";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # 1. Определение системы NixOS (для nixos-rebuild switch)
    nixosConfigurations.kayros-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # Укажите свою архитектуру, если она отличается
      
      modules = [
        # Импортируем наш основной конфиг системы
        ./configuration.nix
        
        # Подключаем модуль Home Manager на уровне системы,
        # чтобы он автоматически применял настройки пользователей
        home-manager.nixosModules.home-manager
        
        # Переопределяем параметры для Home Manager
        {
          # Указываем, что Home Manager будет управлять пользователем 'kayros'
          home-manager.users.kayros = {
            # Импортируем наш конфиг пользователя
            imports = [ ./home.nix ];
            
            # ВАЖНО: Указываем версию Home Manager. Лучше соответствует nixpkgs.
            home.stateVersion = "23.11"; 
          };
          
          # Отключаем глобальное использование (так как мы используем nixosModules)
          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = false;
        }
      ];
    };
  };
}