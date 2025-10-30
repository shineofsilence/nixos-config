{ pkgs, ... }: {
  home.username = "kayros";
  home.homeDirectory = "/home/kayros";
  home.stateVersion = "25.05";

  # Пакеты только для пользователя
  home.packages = with pkgs; [
    foot
	zenity
    # Можно добавить kitty, neovim и т.д. позже
  ];

  # Zsh + Oh My Zsh + плагины
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;  # ← теперь работает!
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "af-magic";
    };
  };

  # Git — теперь через Home Manager (поддерживается!)
  programs.git = {
    enable = true;
    userName = "KayRos";
    userEmail = "shineofsilence@github.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  
  # Минимальный Hyprland
  wayland.windowManager.hyprland.settings = {
    monitor = [ ",preferred,auto,1" ];
    input = {
      kb_layout = "us,ru";
      kb_options = "grp:alt_shift_toggle";
    };
    "$mod" = "SUPER";
    bind = [
      "$mod, T, exec, foot"
      "$mod, Z, exec, zenity --info --text='Hyprland works!'"	  
      "$mod, Q, killactive,"
      "$mod, M, exit,"
	  "$mod SHIFT, M, exec, systemctl --user stop hyprland-session.target"
    ];
  };
  
  # Переменные сессии (если позже добавишь Wayland)
  # home.sessionVariables = {
  #   XDG_SESSION_TYPE = "wayland";
  #   XDG_CURRENT_DESKTOP = "Hyprland";
  # };
}