{ config, lib, pkgs, ... }:

# Импортируем сгенерированную конфигурацию железа
# Этот файл генерируется командой nixos-generate-config
# и должен быть в .gitignore
imports = [
  ./hardware-configuration.nix
  # Другие импорты...
];

{
  # ======================== MAIN ===============================
  system.stateVersion = "24.11";
  
  # Network configuration
  networking.hostName = "KayRos";
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
    keyMap = "us";
    earlySetup = ''
      loadkeys <<'EOF'
        alt_shift_toggle
        include "us"
        include "ru"
      EOF
    '';
  };

  # Nix settings
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
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
    hashedPassword = ""; # Generate with 'mkpasswd -m sha-512' and paste here
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
  
  # System packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    htop
    file
    pciutils
    usbutils
  ];
}





