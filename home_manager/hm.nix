{ pkgs, lib, ... }:  # получаем доступ к пакетам

{
  # Обязательные метаданные пользователя
  home.username = "kayros";
  home.homeDirectory = "/home/kayros";
  home.stateVersion = "25.05";  # версия Home Manager (должна совпадать с релизом)
  
  home.packages = with pkgs; [
    home-manager      # Home Manager
	oh-my-zsh         # настройки консоли
	# kitty             # терминал
	#  wofi           # лаунчер (аналог rofi для Wayland)
    #  swaybg         # установка фона
  ];
  
  # Включаем lingering для пользователя
  #home.activation.enableLinger = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #  if ! sudo loginctl enable-linger ${config.home.username} 2>/dev/null; then
  #    echo "Warning: could not enable linger for ${config.home.username}"
  #  fi
  #'';
  #home.sessionVariables = {
  #  XDG_SESSION_TYPE = "wayland";
  #  XDG_CURRENT_DESKTOP = "Hyprland";
  #};
  home.file.".config/systemd/user/hyprland.service".text = "";
  # ───────────── Настройка программ ─────────────

  # Zsh: включить и настроить
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
	# Вот так подключается Oh My Zsh:
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ];  # опционально
      theme = "af-magic";                       # опционально
    };
  };
  
  # ✅ Kitty — декларативно через Home Manager
  programs.kitty.enable = true;
  
  # Git: базовая настройка
  programs.git = {
    enable = true;
    userName = "KayRos";
    userEmail = "shineofsilence@github.com";
  };
  
  systemd.user.enable = true;  # ← это включает systemd --user поддержку
  systemd.user.services.hyprland = {
    Unit.Description = "Hyprland compositor";
    Unit.Documentation = "https://hyprland.org/";
    Unit.After = [ "graphical-session.target" ];
    Unit.BindsTo = [ "graphical-session.target" ];
    Service.ExecStart = "${pkgs.hyprland}/bin/Hyprland";
    Service.Environment = [
      "XDG_SESSION_TYPE=wayland"
      "XDG_CURRENT_DESKTOP=Hyprland"
    ];
    Service.Restart = "on-failure";
    Service.RestartSec = 1;
    Install.WantedBy = [ "default.target" ];
  };
  
  # Hyprland: включить и задать конфиг
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;  # для запуска X11-приложений
    # extraConfig — содержимое файла ~/.config/hypr/hyprland.conf
    extraConfig = ''
      # Монитор
	  monitor = ,preferred,auto,1

	  # Клавиатура
	  input {
		kb_layout = us,ru
		kb_options = grp:alt_shift_toggle
	  }

	  # Основные бинды
	  bind = ALT, T, exec, kitty
	  bind = ALT, Q, killactive,
	  bind = ALT, M, exit,

	  # Переключение окон
	  #bind = ALT, TAB, cyclenext,
	  #bind = ALT, SHIFT, TAB, cycleprev,

	  # Перемещение окон
	  bind = ALT, H, movefocus, l
	  bind = ALT, L, movefocus, r
	  bind = ALT, K, movefocus, u
	  bind = ALT, J, movefocus, d

    '';
  };
  
  # ───────────── Дополнительно ─────────────
  # Можно добавить:
  # - programs.neovim
  # - services.gpg-agent
  # - xdg.mimeApps
  # - home.file."..." — для кастомных dotfiles
}