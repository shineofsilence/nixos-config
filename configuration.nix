{ config, pkgs, ... }:

{
  # ───────────────────────────────────────
  # 1. Импорты и версия
  # ───────────────────────────────────────
  imports = [
    ./hardware-configuration.nix
	pkgs.home-manager.nixosModules.home-manager       # ← официальный путь в новых версиях
  ];
  environment.systemPackages = with pkgs; [
    zsh
    git
	pkgs.home-manager
  ];
  environment.shells = with pkgs; [ zsh bash ];
  
  # ───────────────────────────────────────
  # 2. Системные настройки
  # ───────────────────────────────────────
  system.stateVersion = "25.05";
  time.timeZone = "Europe/Moscow";
  networking.hostName = "kayros-pc";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  
  # ───────────────────────────────────────
  # 3. Загрузка и ядро
  # ───────────────────────────────────────
  boot.kernelParams = [ "video=1280x800" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Драйверы для initrd (для VMware, NVMe и т.д.)
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "vmw_pvscsi" "vmwgfx" "drm" ];
  
  # ───────────────────────────────────────
  # 4. Консоль и локализация
  # ───────────────────────────────────────
  console.font = "LatGrkCyr-12x22";
  console.useXkbConfig = false;
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "ru_RU.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  i18n.extraLocaleSettings.LC_TIME = "ru_RU.UTF-8";
  fonts.packages = [ 
    pkgs.nerd-fonts.comic-shanns-mono
    pkgs.nerd-fonts.droid-sans-mono
  ];

  # ───────────────────────────────────────
  # 5. Пользователи и права
  # ───────────────────────────────────────
  users.users.kayros = {
    isNormalUser = true;
    home = "/home/kayros";
    shell = pkgs.zsh;
    initialPassword = "123";
    extraGroups = [ "wheel" "networkmanager" ];
  };
  security.sudo.wheelNeedsPassword = false;				# sudo без пароля
  services.sshd.enable = true;							# SSH (опционально)
  
  # ───────────────────────────────────────
  # 6. Home Manager
  # ───────────────────────────────────────
  programs.home-manager.enable = true;					# Включаем модуль Home Manager
  home-manager.users.kayros = import ./home/home.nix;   # Настраиваем Home Manager для пользователя kayros
}
