{ pkgs, ... }:

{
  home.username = "kayros";
  home.homeDirectory = "/home/kayros";

  imports = [
    ./zsh.nix
    ./git.nix
    ./hyprland.nix
  ];
}