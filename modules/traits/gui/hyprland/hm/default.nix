{
  config,
  lib,
  nixosConfig,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.hyprland;
in
{
  imports = [
    ./services/hypridle.nix
    ./services/hyprpaper.nix
    ./services/hyprpolkitagent.nix
    ./services/mako.nix
    ./programs/foot.nix
    ./programs/emacs.nix
    ./programs/fuzzel.nix
    ./programs/wayprompt.nix
    ./programs/hyprsysteminfo.nix
    ./monitor.nix
    ./mouse.nix
    ./keyboard.nix
    ./lid.nix
    ./radios.nix
    ./game.nix
    ./lifecycle.nix
    ./master.nix
    ./workspace.nix
    ./fullscreen.nix
    ./screenshot.nix
    ./multimedia.nix
    ./style.nix
    ./swallow.nix
    ./submaps/resize.nix
  ];

  options.traits.hm.hyprland = {
    enable = lib.mkEnableOption "Hyprland" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = nixosConfig.programs.hyprland.package;
      # FIXME:
      # Enabling these break firefox and chromium coloring, by mechanism unknown to me
      # package = null;
      # portalPackage = null;
    };
  };
}
