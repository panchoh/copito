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
      (pkgs.writeShellApplication {
        name = "toggle-bitdepth";
        runtimeInputs = [ pkgs.jq ];
        text = ''
          # Toggle monitor bit depth between 8-bit and 10-bit
          # Note: Google Meet does not support 10-bit depth

          MON=$(hyprctl monitors -j | jq -r '.[0].name')

          CUR=$(hyprctl monitors -j | jq -r --arg mon "$MON" '.[] | select(.name==$mon) | .currentFormat')

          if [[ "$CUR" == *"101010" ]]; then
            hyprctl keyword monitor 'desc:Dell Inc. DELL U4025QW B1MKH34, highrr, auto, auto, bitdepth, 8'
            hyprctl keyword monitor 'desc:Dell Inc. DELL U3818DW 5KC0386E05KL, preferred, auto, auto, bitdepth, 8'
            hyprctl keyword monitor 'desc:XXX Beyond TV 0x00010000, preferred, auto, 1.5, bitdepth, 8'
          else
            hyprctl keyword monitor 'desc:Dell Inc. DELL U4025QW B1MKH34, highrr, auto, auto, bitdepth, 10'
            hyprctl keyword monitor 'desc:Dell Inc. DELL U3818DW 5KC0386E05KL, preferred, auto, auto, bitdepth, 10'
            hyprctl keyword monitor 'desc:XXX Beyond TV 0x00010000, preferred, auto, 1.5, bitdepth, 10'
          fi
        '';
      })
      pkgs.wayland-utils # for wayland-info
      pkgs.vrrtest
    ];

    wayland.windowManager.hyprland.settings = {
      bind = [ "SUPER SHIFT, B, exec, toggle-bitdepth" ];

      # https://wiki.hypr.land/Configuring/Monitors/#monitor-v2
      monitorv2 = [
        {
          output = "desc:Chimei Innolux Corporation 0x14D4";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
        {
          output = "desc:Dell Inc. DELL U4025QW B1MKH34";
          mode = "highrr";
          position = "auto";
          scale = "auto";
          bitdepth = 10;
        }
        {
          output = "desc:Dell Inc. DELL U3818DW 5KC0386E05KL";
          mode = "preferred";
          position = "auto";
          scale = "auto";
          bitdepth = 10;
        }
        {
          output = "desc:XXX Beyond TV 0x00010000";
          mode = "preferred";
          position = "auto";
          scale = 1.5;
          bitdepth = 10;
        }
      ];
    };
  };
}
