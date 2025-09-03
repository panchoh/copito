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
    wayland.windowManager.hyprland.settings = {
      animation = [ "specialWorkspace, 1, 8, default, slidefadevert 20%" ];

      # https://github.com/hyprwm/Hyprland/pull/352/files
      binds = {
        workspace_back_and_forth = false;
        hide_special_on_workspace_change = true;
        allow_workspace_cycles = true;
        workspace_center_on = 1;
      };

      bind = [
        # Switch workspaces with SUPER + [0-9]
        "SUPER, 1, workspace,  1"
        "SUPER, 2, workspace,  2"
        "SUPER, 3, workspace,  3"
        "SUPER, 4, workspace,  4"
        "SUPER, 5, workspace,  5"
        "SUPER, 6, workspace,  6"
        "SUPER, 7, workspace,  7"
        "SUPER, 8, workspace,  8"
        "SUPER, 9, workspace,  9"
        "SUPER, 0, workspace, 10"

        "SUPER, A, workspace, previous"

        # Cycle through active workspaces
        "SUPER, Right,      workspace, e+1"
        "SUPER, Left,       workspace, e-1"

        # Move active window to a workspace with SUPER + SHIFT + [0-9]
        "SUPER SHIFT, 1, movetoworkspacesilent,  1"
        "SUPER SHIFT, 2, movetoworkspacesilent,  2"
        "SUPER SHIFT, 3, movetoworkspacesilent,  3"
        "SUPER SHIFT, 4, movetoworkspacesilent,  4"
        "SUPER SHIFT, 5, movetoworkspacesilent,  5"
        "SUPER SHIFT, 6, movetoworkspacesilent,  6"
        "SUPER SHIFT, 7, movetoworkspacesilent,  7"
        "SUPER SHIFT, 8, movetoworkspacesilent,  8"
        "SUPER SHIFT, 9, movetoworkspacesilent,  9"
        "SUPER SHIFT, 0, movetoworkspacesilent, 10"

        # Select / Move to scratchpads
        "SUPER SHIFT, grave, movetoworkspacesilent,  special"
        "SUPER,       grave, togglespecialworkspace"
        "SUPER SHIFT, Minus, movetoworkspacesilent,  special:Telegram"
        "SUPER,       Minus, togglespecialworkspace,         Telegram"
        "SUPER SHIFT, Equal, movetoworkspacesilent,  special:Transmission"
        "SUPER,       Equal, togglespecialworkspace,         Transmission"

        # Simulate “iconify”
        "SUPER,       W,     togglespecialworkspace,         magic"
        "SUPER,       W,     movetoworkspace,                +0"
        "SUPER,       W,     togglespecialworkspace,         magic"
        "SUPER,       W,     movetoworkspace,        special:magic"
        "SUPER,       W,     togglespecialworkspace,         magic"

        # Browsers
        "SUPER,       slash,  exec, chromium"
        "SUPER SHIFT, slash,  exec, google-chrome-stable"
      ];

      # Smart gaps (old no_gaps_when_only)
      # https://wiki.hyprland.org/Configuring/Workspace-Rules/#smart-gaps
      workspace = [
        "w[tv1] s[false], gapsout:0,   gapsin:0"
        "f[1] s[false],   gapsout:0,   gapsin:0"
        "s[true],         gapsout:100, gapsin:50"

        "1,               defaultName:Doom,     on-created-empty: doom-emacs"
        "2,               defaultName:Chromium, on-created-empty: chromium"
        "3,               defaultName:Chrome,   on-created-empty: google-chrome-stable"
        "4,               defaultName:Firefox,  on-created-empty: firefox"
        "special:special,                       on-created-empty: foot"
        "special:Telegram,                      on-created-empty: Telegram"
        "special:Transmission,                  on-created-empty: transmission-gtk"
      ];

      windowrulev2 = [
        "bordersize 0, floating:0, onworkspace:w[tv1] s[false]"
        "rounding 0,   floating:0, onworkspace:w[tv1] s[false]"
        "bordersize 0, floating:0, onworkspace:f[1] s[false]"
        "rounding 0,   floating:0, onworkspace:f[1] s[false]"

        "float,                                 class:^(org.telegram.desktop)$, title:^(Media viewer)$"
        "workspace special:Telegram silent,     class:^(org.telegram.desktop)$"
        "workspace special:Transmission silent, class:^(transmission-gtk)$, title:^(Transmission)$"
        "center,                                class:^(transmission-gtk)$, title:^(Torrent Options)$"

        "noanim 1,                              class:^(gcr-prompter)$"
        "xray 1,                                class:^(gcr-prompter)$"
        "dimaround 1,                           class:^(gcr-prompter)$"
        "stayfocused,                           class:^(gcr-prompter)$"
      ];
    };
  };
}
