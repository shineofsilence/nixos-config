
Из старого конфига
# environment.sessionVariables.NIXOS_OZONE_WL = "1";
# services.displayManager.defaultSession = "hyprland"
# services.displayManager.autoLogin.enable = false;  # убедись, что нет автологина в X11!
# services.xserver.enable = false;                   # Hyprland ≠ X11!
# hardware.graphics.enable = true;

Из hm.nix
# Hyprland: включить и задать конфиг
  wayland.windowManager.hyprland = {
    enable = true;
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