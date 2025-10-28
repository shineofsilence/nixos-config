{ pkgs, ... }:

{
  home.stateVersion = "25.05";
  home.username = "kayros";
  home.homeDirectory = "/home/kayros";

  imports = [
    ./zsh.nix
    ./git.nix
    ./hyprland.nix
  ];
}