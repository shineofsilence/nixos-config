{ config, pkgs, ... }:
{
  home.stateVersion = "24.11";
  home.username = "kayros";
  home.homeDirectory = "/home/kayros";
  
  # Включаем home-manager
  programs.home-manager.enable = true;
  
  # Импортируем конфигурации приложений
  imports = [
    ./console/git.nix
    ./console/neovim.nix
  ];
}