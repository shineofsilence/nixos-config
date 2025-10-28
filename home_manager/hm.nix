{ pkgs, ... }:  # получаем доступ к пакетам

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
  programs.kitty = {
    enable = true;
    settings = {
      #shell = "zsh";
      # Шрифт — используем Nerd Font
      # font_family = "ComicShannsMono";
      font_size = 20;
      # Опционально: отступы, прозрачность и т.д.
      #window_padding_width = 8;
      #scrollback_lines = 10000;
    };
  };
  
  # Git: базовая настройка
  programs.git = {
    enable = true;
    userName = "KayRos";
    userEmail = "shineofsilence@github.com";
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
	  bind = ALT, RETURN, exec, kitty
	  bind = ALT, Q, killactive,
	  bind = ALT, M, exit,

	  # Переключение окон
	  bind = ALT, KEY_TAB, cyclenext,
	  bind = ALT, SHIFT, KEY_TAB, cycleprev,

	  # Перемещение окон
	  bind = ALT, H, movefocus, l
	  bind = ALT, L, movefocus, r
	  bind = ALT, K, movefocus, u
	  bind = ALT, J, movefocus, d

	  # Закрыть окно
	  bind = ALT, W, killactive,
    '';
  };
  
  # ───────────── Дополнительно ─────────────
  # Можно добавить:
  # - programs.neovim
  # - services.gpg-agent
  # - xdg.mimeApps
  # - home.file."..." — для кастомных dotfiles
}