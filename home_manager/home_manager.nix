{ config, pkgs, ... }:
{
  home.stateVersion = "25.05";
  home.username = "kayros";
  home.homeDirectory = "/home/kayros";
  
  # Импортируем конфигурации приложений
  imports = [
    ./console/git.nix
    ./console/zsh.nix
    # ./console/neovim.nix
    
    # Конфигурация Hyprland
    (import ../../wm/hyprland.nix)
  ];
  
  # Копируем конфигурацию Hyprland в домашнюю директорию
  home.file = {
    ".config/hypr/hyprland.conf".source = ./hypr/hyprland.conf;
  };
}