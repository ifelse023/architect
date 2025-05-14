{
  lib,
  lib',
  pkgs,
  multiMonitorSetup ? false,
  ...
}:
let
  mod = "Mod4";
in
{
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.sway_git;
    systemd.enable = false;
    checkConfig = false;
    wrapperFeatures.gtk = true;
    config = {
      output =
        {
          "*" = {
            scale = "1";
            adaptive_sync = "off";
            max_render_time = "5";
          };
        }
        // (
          if multiMonitorSetup then
            {
              "HDMI-A-1" = {
                mode = "1920x1080@60Hz";
                position = "2560,0";
                scale = "1";
              };
              "DP-1" = {
                mode = "2560x1440@59.95Hz";
                position = "0,0";
                scale = "1";
              };
            }
          else
            { }
        );

      assigns = {
        "number 4" = [ { app_id = "firefox-nightly"; } ];
        "number 6" = [ { app_id = "discord"; } ];
        "number 1" = [ { app_id = "neovide"; } ];
      };

      floating.criteria = [
        {
          app_id = "firefox-nightly";
          title = "^moz-extension:";
        }
        {
          app_id = "firefox-nightly";
          title = "^Password Required";
        }
        { app_id = "pwvucontrol"; }
        { app_id = "flameshot"; }
        { app_id = "menu"; }
        { app_id = "dialog"; }
        { app_id = "Preferences"; }
        { app_id = "task_dialog"; }
        { app_id = "bubble"; }
        { app_id = "pop-up"; }
        { app_id = "webconsole"; }
        {
          title = "^Library$";
          app_id = "firefox-nightly";
        }
        { title = "Picture in picture"; }
        { title = "File Operation Progress"; }
      ];

      input = {
        "type:keyboard" = {
          xkb_layout = "de";
          xkb_variant = "us";
          xkb_options = "caps:escape";
        };
        # "type:touchpad" = {
        #   tap = "enabled";
        # };
      };
      bars = [ ];
      defaultWorkspace = "workspace number 1";
      window = {
        hideEdgeBorders = "smart";
        titlebar = false;
      };
      gaps = {
        inner = 2;
        smartGaps = true;
        smartBorders = "on";
      };
      startup = [
        { command = "uwsm finalize"; }
        {
          command = "uwsm app -- ${pkgs.swayr}/bin/swayrd";
          always = true;
        }
        {

          command =
            let
              wallpaper = pkgs.fetchurl {
                url = "https://w.wallhaven.cc/full/1p/wallhaven-1p5z71.jpg";
                sha256 = "sha256-y+SjxTg9VfhfcZoIm7qdgJyDkOFJ1Gau6A4luXIifxY=";
              };
              setWallpaper = pkgs.writeShellScript "set-wallpaper" ''
                ${lib.getExe pkgs.killall} swaybg
                 uwsm app -- ${lib.getExe pkgs.swaybg} -m fill -i ${wallpaper}
              '';
            in
            "${setWallpaper}";
          always = true;
        }
      ];
      keybindings =
        {
          XF86MonBrightnessUp = "exec uwsm app -- ${lib.getExe pkgs.brightnessctl} set 10%-";
          XF86MonBrightnessDown = "exec uwsm app -- ${lib.getExe pkgs.brightnessctl} set +10%";
        }
        // {
          "${mod}+Return" = "exec uwsm app -- " + lib'.terminal;
          "${mod}+d" = "exec fuzzel";
          Print = "exec flameshot gui";

        }

        // {

          "${mod}+Shift+m" = "exec uwsm stop";
          "${mod}+Shift+r" = "reload";
          "${mod}+q" = "kill";
          "${mod}+z" = "layout toggle splith tabbed";
          "${mod}+space" = "exec  ${pkgs.swayr}/bin/swayr switch-window";
          "${mod}+Tab" = "exec  ${pkgs.swayr}/bin/swayr switch-to-urgent-or-lru-window";
          "${mod}+c" = "exec cliphist list | fuzzel --dmenu | cliphist decode | wl-copy";
          "${mod}+b" = "workspace back_and_forth";
          "${mod}+Shift+p" = "move workspace to output right";

          "${mod}+e" = "layout toggle split";
          "${mod}+a" = "focus parent";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+s" = "layout stacking";
          "${mod}+Shift+space" = "floating toggle";
          "${mod}+v" = "layout toggle splitv splith";
          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
        };

      modes = {
        resize = {
          h = "resize shrink width 20 px";
          j = "resize grow height 20 px";
          k = "resize shrink height 20 px";
          l = "resize grow width 20 px";
          Escape = "mode default";
          Return = "mode default";
        };
      };
    };
    extraConfig = ''
      focus_on_window_activation focus
      workspace 1 output DP-1
      workspace 2 output DP-1
      workspace 3 output DP-1
      workspace 4 output HDMI-A-1
      workspace 5 output HDMI-A-1
      workspace 6 output HDMI-A-1
      default_border pixel 1
      default_floating_border pixel 1
      for_window [app_id=com.mitchellh.ghostty] focus
      for_window [app_id=neovide] focus
      floating_modifier ${mod} normal
      set $left h
      set $down j
      set $up k
      set $right l

      bindsym ${mod}+$left focus left
      bindsym ${mod}+$down focus down
      bindsym ${mod}+$up focus up
      bindsym ${mod}+$right focus right
      bindsym ${mod}+Left focus left
      bindsym ${mod}+Down focus down
      bindsym ${mod}+Up focus up
      bindsym ${mod}+Right focus right
      bindsym ${mod}+Shift+$left move left
      bindsym ${mod}+Shift+$down move down
      bindsym ${mod}+Shift+$up move up
      bindsym ${mod}+Shift+$right move right
      bindsym ${mod}+Shift+Left move left
      bindsym ${mod}+Shift+Down move down
      bindsym ${mod}+Shift+Up move up
      bindsym ${mod}+Shift+Right move right
      for_window [app_id="flameshot"] border pixel 0, floating enable, fullscreen disable, move absolute position 0 0

      client.focused           #cba6f7    #1e1e2e #cdd6f4  #b4befe #cba6f7
      client.focused_inactive  #181825    #1e1e2e #cdd6f4  #181825 #181825
      client.unfocused         #181825    #1e1e2e #cdd6f4  #181825 #181825
      client.urgent            #fab387    #1e1e2e #fab387  #6c7086 #fab387
      client.placeholder       #1e1e2e    #1e1e2e #cdd6f4  #6c7086 #6c7086
      client.background        #1e1e2e
    '';
  };
}
