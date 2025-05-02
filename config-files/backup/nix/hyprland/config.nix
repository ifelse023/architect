{
  wayland.windowManager.hyprland = {

    settings = {
      exec-once = [
        "uwsm finalize"
        "uwsm app -- clipse -listen"
        # "uwsm app -- ghostty --gtk-single-instance=true --quit-after-last-window-closed=false"
      ];
      monitor = [
        "eDP-1,disable"
        "HDMI-A-1,1920x1080@60.00,2560x0,1"
        "DP-1,2560x1440@59.95,0x0,1"
      ];

      workspace = [
        "1, monitor:DP-1, default:true"
        "2, monitor:DP-1, default:true"
        "3, monitor:DP-1, default:true"
        "4, monitor:HDMI-A-1, default:true"
        "5, monitor:HDMI-A-1, default:true"
      ];
      "$mod" = "SUPER";

      general = {
        gaps_in = 3;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
        resize_on_border = true;
        layout = "dwindle";
        no_border_on_floating = false;

      };

      decoration = {
        rounding = 8;
        rounding_power = 3;
        blur = {
          enabled = true;
          passes = 3;
          size = 6;
          new_optimizations = true;

        };
        shadow = {
          enabled = true;
          range = 15;
          render_power = 3;
          ignore_window = true;
          offset = "2, 4";
          color = "rgba(2e2e2e2e)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
          "almostLinear, 0.5, 0.5, 0.75, 1.0"
          "md2, 0.4, 0, 0.2, 1"
        ];

        # Define animations
        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "windowsIn, 1, 3, md3_decel, popin 60%"
          "windowsOut, 1, 3, md3_accel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 3, md3_decel"
          "layersIn, 1, 3, menu_decel, slide"
          "layersOut, 1, 1.6, menu_accel"
          "fadeLayersIn, 1, 2, menu_decel"
          "fadeLayersOut, 1, 4.5, menu_accel"
          "workspaces, 1, 7, menu_decel, slide"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
          "specialWorkspace, 1, 3, md3_decel, slidevert"
        ];
      };

      input = {
        follow_mouse = 1;
        kb_layout = "de";
        kb_variant = "us";
        kb_options = "caps:escape";
        sensitivity = 0.5;

        touchpad.natural_scroll = "no";
      };

      dwindle = {
        # keep floating dimentions while tiling
        pseudotile = true;
        preserve_split = true;
      };

      render = {
      };

      misc = {
        # disable auto polling for config file changes
        disable_autoreload = true;
        disable_splash_rendering = true;
        enable_swallow = true; # hide windows that spawn other windows

        disable_hyprland_logo = true;
        force_default_wallpaper = 0;

        # disable dragging animation
        animate_mouse_windowdragging = false;

        mouse_move_enables_dpms = true; # enable dpms on mouse/touchpad action
        key_press_enables_dpms = true; # enable dpms on keyboard action

      };

      # touchpad gestures
      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
      };

      debug.disable_logs = false;
    };
  };
}
