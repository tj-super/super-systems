{
  "$mod" = "SUPER";
  "$terminal" = "kitty";
  "$explorer" = "dolphin";
  "$menu" = "wofi --show drun";

  monitor = [
    "HDMI-A-1, 1920x1080, 0x0, 1"
    "DP-1, 1920x1080, 1920x0, 1"
    "eDP-1, preferred, auto-right, 1.6"
  ];

  workspace = [
    "1,monitor:HDMI-A-1"
    "2,monitor:DP-1"
    "3,monitor:eDP-1"
  ];

  exec-once = [
    "waybar & hyprpaper"
  ];

  env = [
    "XCURSOR_SIZE,24"
    "HYPRCURSOR_SIZE,24"
  ];

  ecosystem = {
    no_update_news = true;
  };

  general = {
    gaps_in = 5;
    gaps_out = 20;
    border_size = 2;
    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";
    resize_on_border = false;
    allow_tearing = false;
    layout = "dwindle";
  };

  decoration = {
    rounding = 10;
    rounding_power = 2;
    active_opacity = 1.0;
    inactive_opacity = 1.0;
    shadow = {
      enabled = true;
      range = 4;
      render_power = 3;
      color = "rgba(1a1a1aee)";
    };
    blur = {
      enabled = true;
      size = 3;
      passes = 1;
      vibrancy = 0.1696;
    };
  };

  animations = {
    enabled = true;
    bezier = [
      "easeOutQuint,   0.23, 1,    0.32, 1"
      "easeInOutCubic, 0.65, 0.05, 0.36, 1"
      "linear,         0,    0,    1,    1"
      "almostLinear,   0.5,  0.5,  0.75, 1"
      "quick,          0.15, 0,    0.1,  1"
    ];
    animation = [
      "global,        1,     10,    default"
      "border,        1,     5.39,  easeOutQuint"
      "windows,       1,     4.79,  easeOutQuint"
      "windowsIn,     1,     4.1,   easeOutQuint, popin 87%"
      "windowsOut,    1,     1.49,  linear,       popin 87%"
      "fadeIn,        1,     1.73,  almostLinear"
      "fadeOut,       1,     1.46,  almostLinear"
      "fade,          1,     3.03,  quick"
      "layers,        1,     3.81,  easeOutQuint"
      "layersIn,      1,     4,     easeOutQuint, fade"
      "layersOut,     1,     1.5,   linear,       fade"
      "fadeLayersIn,  1,     1.79,  almostLinear"
      "fadeLayersOut, 1,     1.39,  almostLinear"
      "workspaces,    1,     1.94,  almostLinear, fade"
      "workspacesIn,  1,     1.21,  almostLinear, fade"
      "workspacesOut, 1,     1.94,  almostLinear, fade"
      "zoomFactor,    1,     7,     quick"
    ];
  };

  dwindle = {
    preserve_split = true;
  };

  master = {
    new_status = "master";
  };

  misc = {
    force_default_wallpaper = -1;
    disable_hyprland_logo = true;
  };

  input = {
    kb_layout = "us";
    kb_variant = "";
    kb_model = "";
    kb_options = "";
    kb_rules = "";
    follow_mouse = 1;
    sensitivity = 0;
    touchpad = {
      natural_scroll = false;
    };
  };

  gesture = [
    "3, horizontal, workspace"
  ];

  device = [
    {
      name = "epic-mouse-v1";
      sensitivity = -0.5;
    }
  ];

  bind = [
    "$mod, Q, exec, $terminal"
    "$mod, F, exec, firefox"
    "$mod, C, killactive"
    "$mod, M, exit"
    "$mod, E, exec, $explorer"
    "$mod, V, togglefloating"
    "$mod, R, exec, $menu"
    "$mod, P, pseudo"
    "$mod, left, movefocus, l"
    "$mod, right, movefocus, r"
    "$mod, up, movefocus, u"
    "$mod, down, movefocus, d"
    "$mod, 1, workspace, 1"
    "$mod, 2, workspace, 2"
    "$mod, 3, workspace, 3"
    "$mod, 4, workspace, 4"
    "$mod, 5, workspace, 5"
    "$mod, 6, workspace, 6"
    "$mod, 7, workspace, 7"
    "$mod, 8, workspace, 8"
    "$mod, 9, workspace, 9"
    "$mod, 0, workspace, 10"
    "$mod SHIFT, 1, movetoworkspace, 1"
    "$mod SHIFT, 2, movetoworkspace, 2"
    "$mod SHIFT, 3, movetoworkspace, 3"
    "$mod SHIFT, 4, movetoworkspace, 4"
    "$mod SHIFT, 5, movetoworkspace, 5"
    "$mod SHIFT, 6, movetoworkspace, 6"
    "$mod SHIFT, 7, movetoworkspace, 7"
    "$mod SHIFT, 8, movetoworkspace, 8"
    "$mod SHIFT, 9, movetoworkspace, 9"
    "$mod SHIFT, 0, movetoworkspace, 10"
    "$mod, S, togglespecialworkspace, magic"
    "$mod SHIFT, S, movetoworkspace, special:magic"
    "$mod, mouse_down, workspace, e+1"
    "$mod, mouse_up, workspace, e-1"
  ];

  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];

  bindel = [
    ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
    ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
    ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
  ];

  bindl = [
    ", XF86AudioNext, exec, playerctl next"
    ", XF86AudioPause, exec, playerctl play-pause"
    ", XF86AudioPlay, exec, playerctl play-pause"
    ", XF86AudioPrev, exec, playerctl previous"
  ];

  # Translation of the submap block into Home Manager settings format
  # submap = "passthrough\nbind = $mod, Escape, submap, passthrough\nsubmap = passthrough\nbind = $mod, Escape, submap, reset\nsubmap = reset";
}
