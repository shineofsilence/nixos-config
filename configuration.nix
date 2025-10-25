{ config, pkgs, inputs, ... }:

{
  # Basic system settings
  system.stateVersion = "25.05";
  
  # Set your time zone
  time.timeZone = "Europe/Moscow";
  
  # Internationalization settings
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable networking
  networking.networkmanager.enable = true;
  
  # Enable sound with pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account
  users.users.your-username = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Terminal
    alacritty
    
    # File manager
    thunar
    
    # Network
    networkmanagerapplet
    
    # Audio control
    pavucontrol
    
    # Screenshot
    grim
    slurp
    wl-clipboard
    
    # App launcher
    wofi
    
    # System monitoring
    htop
    btop
    
    # Required for some applications
    xdg-utils
    
    # Fonts
    (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
    noto-fonts
    noto-fonts-emoji
    
    # Icons
    adwaita-icon-theme
  ];

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable XDG portal
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # Environment variables
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "hyprland";
  };

  # Font configuration
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "FiraCode Nerd Font" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  # Enable GVFS for Thunar
  services.gvfs.enable = true;
  
  # Enable polkit for authentication dialogs
  security.polkit.enable = true;
  
  # SWAP-file
  swapDevices = [
    {
      device = "/swapfile";
      size = 4096;
    }
  ];

  # Enable necessary systemd services
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/lib/polkit-gnome/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
