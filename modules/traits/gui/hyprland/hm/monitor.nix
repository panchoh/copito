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
          # NOTE: It only works the first cycle
          # TODO: report issue upstream

          declare -A CONFIGS=(
            ['Dell Inc. DELL U4025QW B1MKH34']='mode highrr, position auto, scale auto'
            ['Dell Inc. DELL U3818DW 5KC0386E05KL']='mode preferred, position auto, scale auto'
            ['XXX Beyond TV 0x00010000']='mode preferred, position auto, scale 1.5'
          )

          hyprctl monitors -j | jq -c '.[]' | while read -r monitor; do
            NAME=$(jq -r '.name' <<<"$monitor")
            DESC=$(jq -r '.description' <<<"$monitor")
            BITDEPTH=$(jq -r '.currentFormat' <<<"$monitor")

            CONFIG="''${CONFIGS[$DESC]-}"

            if [[ -z "$CONFIG" ]]; then
              echo "⚠️  Skipping unknown monitor: $DESC ($NAME)"
              continue
            fi

            if [[ "$BITDEPTH" == *"101010" ]]; then
              echo "🔧 Setting $DESC ($NAME) → 8-bit"
              hyprctl keyword monitorv2["$NAME"]:"$CONFIG", bitdepth 8
              hyprctl --batch keyword monitorv2["$NAME"]:bitdepth  8 \; keyword monitorv2["$NAME"]:"$CONFIG"
            else
              echo "🔧 Setting $DESC ($NAME) → 10-bit"
              hyprctl --batch keyword monitorv2["$NAME"]:bitdepth 10 \; keyword monitorv2["$NAME"]:"$CONFIG"
            fi
          done
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
