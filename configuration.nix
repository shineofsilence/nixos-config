{ config, pkgs, lib, ... }:

{
  # ───────────────────────────────────────
  # 1. Импорты и версия
  # ───────────────────────────────────────
  imports = [
    ./hardware-configuration.nix
  ];
  
  environment.systemPackages = with pkgs; [
    zsh
    git
  ];
  environment.shells = with pkgs; [ zsh bash ];
  
  # ───────────────────────────────────────
  # 2. Системные настройки
  # ───────────────────────────────────────
  system.stateVersion = "23.11";
  time.timeZone = "Europe/Moscow";
  networking.hostName = "kayros-pc";
  networking.networkmanager.enable = true;
  
  # ───────────────────────────────────────
  # 3. Загрузка и ядро
  # ───────────────────────────────────────
  boot.kernelParams = [ "video=1024x768" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 10;
  # Драйверы для initrd (для VMware, NVMe и т.д.)
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "vmw_pvscsi" "vmwgfx" "drm" ];
  
  # ───────────────────────────────────────
  # 4. Консоль и локализация
  # ───────────────────────────────────────
  programs.zsh.enable = true;     
  console.font = "LatGrkCyr-12x22";
  # console.useXkbConfig = false;
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "ru_RU.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  i18n.extraLocaleSettings.LC_TIME = "ru_RU.UTF-8";
  fonts.packages = with pkgs; [ 
    nerd-fonts.comic-shanns-mono
    nerd-fonts.droid-sans-mono
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
  services.sshd.enable = true;	                        # SSH (опционально)
  
  # ───────────────────────────────────────
  # 6. Графическая сессия: greetd + Hyprland
  # ───────────────────────────────────────
  programs.hyprland = {
    enable = true;
    # withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
	# Важно: нужно настроить, чтобы Hyprland использовал свой портал, а не GTK/Gnome
    configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
		command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd '${config.home-manager.users.kayros.activationPackage}/activate-session.sh hyprland'";
		user = "kayros";
      };
    };
  };

  # Запретить автологин в TTY (чтобы greetd работал)
  services.getty.autologinUser = null;
}
