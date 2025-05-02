{ lib', ... }:
let
  workspaces = builtins.concatLists (
    builtins.genList (
      x:
      let
        ws =
          let
            c = (x + 1) / 10;
          in
          builtins.toString (x + 1 - (c * 10));
      in
      [
        "$mod, ${ws}, workspace, ${toString (x + 1)}"
        "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    ) 10
  );
  runOnce = program: "pgrep ${program} || ${program}";
in
{
  wayland.windowManager.hyprland.settings = {
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];

    # binds
    bind = [
      "CTRL, Print, exec, ${runOnce "grimblast"} --notify --cursor copysave output"
      "$mod SHIFT, E, exec, pkill Hyprland"
      "$mod SHIFT, E, exec, pkill Hyprland"
      "$mod, Q, killactive,"
      "$mod, C, cyclenext,"
      "$mod, F, fullscreen,"
      "$mod, Space, fullscreen,"
      "$mod, G, togglegroup,"
      "$mod SHIFT, N, changegroupactive, f"
      "$mod SHIFT, P, changegroupactive, b"
      "$mod, R, togglesplit,"
      "$mod, T, togglefloating,"
      "$mod, P, pseudo,"
      "$mod ALT, ,resizeactive,"

      ("$mod, Return, exec, uwsm app -- " + lib'.terminal)

      "$mod, D, exec, fuzzel launch-prefix='uwsm app -- '"
      "SUPER, E, exec, uwsm app --  foot"
      "$mod, Escape, exec, wlogout -p layer-shell"
      "$mod, L, exec, loginctl lock-session"

      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      "$mod, bracketleft, workspace, m-1"
      "$mod, bracketright, workspace, m+1"

      "$mod SHIFT, bracketleft, focusmonitor, l"
      "$mod SHIFT, bracketright, focusmonitor, r"

      "$mod, M, exit"

      "SUPER SHIFT, 1, movetoworkspace, 1"
      "SUPER SHIFT, 2, movetoworkspace, 2"
      "SUPER SHIFT, 3, movetoworkspace, 3"
      "SUPER SHIFT, 4, movetoworkspace, 4"
      "SUPER SHIFT, 5, movetoworkspace, 5"

      "SUPER_SHIFT, left,  movewindow, l"
      "SUPER_SHIFT, right, movewindow, r"
      "SUPER_SHIFT, up,    movewindow, u"
      "SUPER_SHIFT, down,  movewindow, d"

      "SUPER, mouse:276, fullscreen, 0 "
      "SUPER, mouse:276, exec, $notifycmd 'Fullscreen Mode'"
    ] ++ workspaces;

    bindl = [
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"

      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ];

    bindle = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

      ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
    ];
  };
}
