{ config, pkgs, ... }:
{
  home.stateVersion = "25.05";
  home.username = "kayros";
  home.homeDirectory = "/home/kayros";
  
  # Импортируем конфигурации приложений
  imports = [
    ./console/git.nix
    ./console/neovim.nix
  ];
}