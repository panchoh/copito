{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.hm.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bindl = [
      # Lid management
      # https://wiki.hypr.land/Configuring/Binds/#switches
      '', switch:on:Lid Switch, exec, hyprctl keyword monitor "eDP-1, disable"''
      '', switch:off:Lid Switch, exec, hyprctl keyword monitor "eDP-1, preferred, auto, 1"''
    ];
  };
}
