{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
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
}