{ config, pkgs, ... }:

{
  # ───────────────────────────────────────
  # 1. Импорты и версия
  # ───────────────────────────────────────
  imports = [ ./hardware-configuration.nix ];
  # Версия NixOS
  system.stateVersion = "25.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # ───────────────────────────────────────
  # 2. Системные настройки
  # ───────────────────────────────────────
  networking.hostName = "kayros-pc";
  time.timeZone = "Europe/Moscow";
  
  # ───────────────────────────────────────
  # 5. Пакеты и оболочки
  # ───────────────────────────────────────
  environment.systemPackages = with pkgs; [
    zsh
	kbd
	kitty
  ];
  environment.shells = with pkgs; [ zsh bash ];
  programs.zsh.enable = true;
  programs.git.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;          # обязательно для корректного запуска сессии
    xwayland.enable = true;   # чтобы работали X11-приложения (включая некоторые GUI-утилиты)
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };
  # programs.neovim.enable = true;
  # Десктоп
  #systemd.user.services.hyprland.Environment = {
  #  XDG_SESSION_TYPE = "wayland";
  #  XDG_CURRENT_DESKTOP = "Hyprland";
  #};
  # hardware.graphics.enable = true;
  
  # ───────────────────────────────────────
  # Локализация и консоль
  # ───────────────────────────────────────
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "ru_RU.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  i18n.extraLocaleSettings = { LC_TIME = "ru_RU.UTF-8"; };
  console = {
    font = "LatGrkCyr-12x22";
	useXkbConfig = false;
  };
  fonts.packages = [ 
    pkgs.nerd-fonts.comic-shanns-mono
    pkgs.nerd-fonts.droid-sans-mono
  ];
  # ───────────────────────────────────────
  # 3. Сеть и брандмауэр
  # ───────────────────────────────────────
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  # Примеры:
  # networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  # networking.wireless.enable = false;  # если не нужен Wi-Fi
  # services.openssh.enable = true;      # альтернатива sshd

  # ───────────────────────────────────────
  # 4. Загрузка и ядро
  # ───────────────────────────────────────
  boot.kernelParams = [ "video=1280x800" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Драйверы для initrd (для VMware, NVMe и т.д.)
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "vmw_pvscsi" "vmwgfx" "drm" ];
  # Примеры:
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelParams = [ "quiet" "loglevel=4" ];
  # boot.supportedFilesystems = [ "ntfs" ];  # если нужно

  # ───────────────────────────────────────
  # 6. Пользователи и права
  # ───────────────────────────────────────
  users.users.kayros = {
    isNormalUser = true;
    home = "/home/kayros";
    shell = pkgs.zsh;
    initialPassword = "123";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };
  # Sudo без пароля для группы wheel
  security.sudo.wheelNeedsPassword = false;
  # systemd.user.linger = true;
  # services.getty.autologinUser = "kayros";
  services.sshd.enable = true;

}

