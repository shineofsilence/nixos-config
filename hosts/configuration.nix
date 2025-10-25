{ config, lib, pkgs, ... }:

{
  # Импортируем сгенерированную конфигурацию железа
  # Этот файл генерируется командой nixos-generate-config
  # и должен быть в .gitignore
  imports = [
    ./hardware.nix
    # Другие импорты...
  ];
  # ======================== MAIN ===============================
  system.stateVersion = "25.05";
  
  # Network configuration
  networking.hostName = "kayros-pc";
  networking.networkmanager.enable = true;
  
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  
  # Time and locale
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8"];
  
  # Console settings
  console = {
    font = "ter-v24n";
    packages = with pkgs; [ terminus_font ];
    keyMap = "ruwin_alt_sh-UTF-8";  # ← это встроенный keymap с Alt+Shift
  };

  # Nix settings
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  
  # User configuration
  users.users.kayros = {
    isNormalUser = true;
    home = "/home/kayros";
    shell = pkgs.bash;
	  initialPassword = "123";
    # hashedPassword = ""; # Generate with 'mkpasswd -m sha-512' and paste here
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };

  # Security
  security.sudo.wheelNeedsPassword = false;
  
  # Services
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}





