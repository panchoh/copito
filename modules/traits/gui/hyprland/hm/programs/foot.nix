{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.traits.hm.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [
      # For notify-send, used by programs.foot.settings.desktop-notifications.command’s default value
      pkgs.libnotify
    ];

    programs.foot = {
      enable = true;
      settings = {
        bell = {
          urgent = true;
          notify = true;
          visual = true;
        };
        main.pad = "0x0";
        mouse.hide-when-typing = true;
      };
    };

    wayland.windowManager.hyprland.settings.bind = [ "SUPER SHIFT, Return, exec, foot" ];
  };
}
