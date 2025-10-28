{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "25.05";
  networking.hostName = "kayros-pc";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.supportedFilesystems = [ "btrfs" ];

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [ zsh git hyprland ];
  programs.zsh.enable = true;
  
  users.users.kayros = {
    isNormalUser = true;
    home = "/home/kayros";
    shell = pkgs.zsh;
    initialPassword = "123";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };

  security.sudo.wheelNeedsPassword = false;
}

