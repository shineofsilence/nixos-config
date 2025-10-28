{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = ''
      # Минимальная рабочая конфигурация
      exec = systemctl --user import-environment
      exec = dbus-update-activation-environment --systemd

      monitor = ,preferred,auto,1

      input {
        kb_layout = us,ru
        kb_options = grp:alt_shift_toggle
      }

      bind = ALT, F1, exec, firefox
      bind = ALT, RETURN, exec, kitty
    '';
  };
}