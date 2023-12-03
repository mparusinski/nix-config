{ ...}:

let
  wallpaper = builtins.fetchurl {
    url = "https://i.redd.it/oo3e09iwkmua1.jpg";
    sha256 = "sha256:0jz5id588nlvlprnvhw12p919br3lqm27bfd7lqv3pm35qxw6d8j";
  };
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = waybar, kdeconnect-indicator, discord

    $mainMod = SUPER

    # Some default env vars.
    env = XCURSOR_SIZE,24

    # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
    input {
        kb_layout = us
        kb_variant =
        kb_model =
        kb_options =
        kb_rules =
    
        follow_mouse = 1
    
        touchpad {
            natural_scroll = no
        }
    
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
    }

    general {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
    
        gaps_in = 5
        gaps_out = 20
        border_size = 2
        col.active_border = rgba(7fbbb3ee)
        col.inactive_border = rgba(7a8478ee)
    
        layout = dwindle
    }

    gestures {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = on
    }

    # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
    bind = $mainMod, C, killactive, 
    bind = $mainMod, M, exit, 
    bind = $mainMod, Q, exec, kitty
    bind = $mainMod, E, exec, thunar
    bind = $mainMod, Y, exec, firefox
    bind = $mainMod, V, togglefloating, 
    bind = $mainMod, R, exec, wofi --show drun
    bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, J, togglesplit, # dwindle

    # Move focus with mainMod + arrow keys
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    # workspaces
    # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
    ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in ''
          bind = $mainMod, ${ws}, workspace, ${toString (x + 1)}
          bind = $mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
        ''
      )
      10)}

   # Scroll through existing workspaces with mainMod + scroll
   bind = $mainMod, mouse_down, workspace, e+1
   bind = $mainMod, mouse_up, workspace, e-1
   
   # Move/resize windows with mainMod + LMB/RMB and dragging
   bindm = $mainMod, mouse:272, movewindow
   bindm = $mainMod, mouse:273, resizewindow
  '';
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
}

