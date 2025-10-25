{ config, pkgs, inputs, ... }:

{
  # This value determines the Home Manager release that your
  # configuration is compatible with.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "your-username";
  home.homeDirectory = "/home/your-username";

  # Basic Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    
    # Basic configuration
    settings = {
      # Autostart applications
      exec-once = [
        "waybar"
        "nm-applet --indicator"
        "swayidle -w"
        "swaybg -i ~/.config/hypr/wallpaper.jpg"
      ];

      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };

      # Window rules
      windowrulev2 = [
        "float, class:^(pavucontrol)$"
        "float, title:^(File Operation Progress)$"
      ];

      # Key bindings
      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, Return, exec, alacritty"
        "$mainMod, Q, killactive"
        "$mainMod, M, exit"
        "$mainMod, V, togglefloating"
        "$mainMod, D, exec, wofi --show drun"
        "$mainMod, P, exec, grim -g '$(slurp)' - | wl-copy"
        "$mainMod, F, fullscreen"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
      ];
    };
  };

  # Configure Alacritty
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.9;
        padding = { x = 5; y = 5; };
      };
      font = {
        normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
        size = 12;
      };
      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
      };
    };
  };

  # Configure Git
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # Configure Fish shell
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --icons";
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos";
    };
  };

  # GTK and icon theme configuration
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    theme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-theme;
    };
  };

  # Basic packages to install
  home.packages = with pkgs; [
    # Theme packages
    gnome.adwaita-icon-theme
    gnome.adwaita-theme
    
    # Terminal utilities
    eza
    bat
    fd
    ripgrep
    fzf
    
    # Development tools
    git
    gcc
    gnumake
    
    # Media
    imv
    mpv
    
    # Archives
    unzip
    unrar
    
    # System utilities
    man-pages
    man-pages-posix
  ];

  # Enable gpg-agent
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  # Enable gtk theming
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };

  # This will add your ~/.config/nixpkgs/config.nix to the list of Nixpkgs options
  xdg.configFile."nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';
}
