{ pkgs, ... }:  # получаем доступ к пакетам

{
  # Обязательные метаданные пользователя
  home.username = "kayros";
  home.homeDirectory = "/home/kayros";
  home.stateVersion = "25.05";  # версия Home Manager (должна совпадать с релизом)

  # ───────────── Настройка программ ─────────────

  # Zsh: включить и настроить
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
  };
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [
      "git"
      "python"
      "man"
    ];
    theme = "agnoster";
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
      monitor=,preferred,auto,1

      input {
        kb_layout = us,ru
        kb_options = grp:alt_shift_toggle
      }

      bind = ALT, RETURN, exec, kitty
      bind = ALT, Q, killactive,
      bind = ALT, M, exit,
    '';
  };

  # ───────────── Дополнительно ─────────────
  # Можно добавить:
  # - programs.neovim
  # - services.gpg-agent
  # - xdg.mimeApps
  # - home.file."..." — для кастомных dotfiles
}