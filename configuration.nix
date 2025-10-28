{ config, pkgs, ... }:

{
  # ───────────────────────────────────────
  # 1. Импорты и версия
  # ───────────────────────────────────────
  imports = [ ./hardware-configuration.nix ];
  # Версия NixOS (обязательно!)
  system.stateVersion = "25.05";

  # ───────────────────────────────────────
  # 2. Системные настройки
  # ───────────────────────────────────────
  networking.hostName = "kayros-pc";
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  # Примеры других настроек:
  i18n.extraLocaleSettings = { LC_TIME = "ru_RU.UTF-8"; };
  # powerManagement.enable = true;
  # environment.variables = { EDITOR = "nvim"; };

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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Драйверы для initrd (для VMware, NVMe и т.д.)
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "vmw_pvscsi" "vmwgfx" ];
  # Примеры:
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelParams = [ "quiet" "loglevel=4" ];
  # boot.supportedFilesystems = [ "ntfs" ];  # если нужно

  # ───────────────────────────────────────
  # 5. Пакеты и оболочки
  # ───────────────────────────────────────
  environment.systemPackages = with pkgs; [
    home-manager
    zsh
    git
    hyprland
    # kitty
    # neovim
    # firefox
  ];
  # Включение системных программ (генерируют конфиги)
  # programs.home-manager.enable = true;
  programs.zsh.enable = true;
  programs.git.enable = true;
  programs.hyprland.enable = true;
  # Примеры:
  # programs.fish.enable = true;
  # programs.neovim.enable = true;
  # environment.shells = with pkgs; [ zsh bash ];

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
  # Примеры:
  # users.users.root.initialPassword = "root123";
  # security.pam.services.sudo.u2fAuth = true;  # 2FA

  # ───────────────────────────────────────
  # 7. Службы (services)
  # ───────────────────────────────────────
  services.sshd.enable = true;
  # Примеры других служб:
  # services.dbus.enable = true;          # обычно включён по умолчанию
  # services.tailscale.enable = true;
  # services.xserver.enable = false;      # явно отключаем X11
  services.getty.autologinUser = "kayros";
}

