{ pkgs, config, ... }: {
  home.username = "kayros";
  home.homeDirectory = "/home/kayros";

  # Пакеты только для пользователя
  home.packages = with pkgs; [
    zsh-syntax-highlighting
    foot
  ];

  # Zsh + Oh My Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "af-magic";
    };
  };

  # Zsh Syntax Highlighting
  programs.zsh-syntax-highlighting = {
    enable = true;
  };

  # Git 
  programs.git = {
    enable = true;
    userName = "KayRos";
    userEmail = "shineofsilence@github.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  
  # Минимальный Hyprland
  wayland.windowManager.hyprland = {
    enable = true; # Важно: включить модуль Home Manager для Hyprland
    settings = {
      monitor = [ ",preferred,auto,1" ];
      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle";
      };
      "$mod" = "SUPER"; # 'SUPER' - это клавиша Win
      
      # Вот ваш бинд
      bind = [
        "$mod, T, exec, foot" # Win + T -> запуск foot
        "$mod, Z, exec, zenity --info --text='Hyprland works!'"
        "$mod, Q, killactive,"
        "$mod, M, exit,"
        # Выход через systemctl --user, как у вас было
        "$mod SHIFT, M, exec, systemctl --user stop hyprland-session.target" 
        # Переключение рабочих пространств
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
      ];
    };
  };
  
  # Переменные сессии (если позже добавишь Wayland)
  # home.sessionVariables = {
  #   XDG_SESSION_TYPE = "wayland";
  #   XDG_CURRENT_DESKTOP = "Hyprland";
  # };
}