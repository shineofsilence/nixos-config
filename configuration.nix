{ config, pkgs, ... }:

{
  # ───────────────────────────────────────
  # 1. Импорты и версия
  # ───────────────────────────────────────
  imports = [
    ./hardware-configuration.nix
	(
      let
        hmSrc = builtins.fetchTarball {
          url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
        };
      in
      import "${hmSrc}/nixos"
    )
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.kayros = import ./home.nix;  # путь к вашему home.nix
  
  environment.systemPackages = with pkgs; [
    zsh
    git
	home-manager  # ← нужен для CLI и модуля
  ];
  environment.shells = with pkgs; [ zsh bash ];
  
  # ───────────────────────────────────────
  # 2. Системные настройки
  # ───────────────────────────────────────
  system.stateVersion = "25.05";
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
  # И отключи попытки писать в /boot/efi при обычном switch:
  environment.etc."loader/entries".enable = false;
  
  # Драйверы для initrd (для VMware, NVMe и т.д.)
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "vmw_pvscsi" "vmwgfx" "drm" ];
  
  # ───────────────────────────────────────
  # 4. Консоль и локализация
  # ───────────────────────────────────────
  programs.zsh.enable = true;                           # zsh — это наша оболочка
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
  services.sshd.enable = true;	                        # SSH (опционально)
  
  # ───────────────────────────────────────
  # 6. Графическая сессия: greetd + Hyprland
  # ───────────────────────────────────────
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "kayros";
      };
    };
  };

  # Запретить автологин в TTY (чтобы greetd работал)
  services.getty.autologinUser = null;
}
