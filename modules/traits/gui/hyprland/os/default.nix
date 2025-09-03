{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.hyprland;
in
{
  imports = [
    ./wayprompt.nix
  ];

  options.traits.os.hyprland = {
    enable = lib.mkEnableOption "Hyprland" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    programs.hyprland.enable = true;
  };
}
