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
      pkgs.grim
      pkgs.grimblast
      pkgs.hyprpicker
      pkgs.jq
      pkgs.libnotify # For notify-send
      pkgs.satty # TODO: also configure hyprland keybinding
      pkgs.slurp
      pkgs.wl-clipboard
      # REVIEW
      # pkgs.wl-clipboard-rs
    ];

    programs.hyprshot = {
      enable = true;
      saveLocation = "${config.home.homeDirectory}/screenshots/"; # FIXME Apparently broken in HM module
    };

    wayland.windowManager.hyprland.settings.bind = [
      # TODO: use hyprshot over grimblast
      # and drop explicit deps shown up
      # already provided by:
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/hy/hyprshot/package.nix#L53

      # Screenshots
      # "SUPER,       P, exec, grimblast save active"
      # "SUPER SHIFT, P, exec, grimblast save area"
      # "SUPER ALT,   P, exec, grimblast save output"
      # "SUPER CTRL,  P, exec, grimblast save screen"
      "     , Print, exec, grimblast save active"
      "SHIFT, Print, exec, grimblast save area"
      "ALT,   Print, exec, grimblast save output"
      "CTRL,  Print, exec, grimblast save screen"
    ];
  };
}
