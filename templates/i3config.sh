# i3 config file (v4)
# Please see http://i3wm.org/docs/userguide.html for a complete reference!

# {{msg}}

# Set mod key (Mod1=<Alt>, Mod4=<Super>)
set $mod Mod4

# set default desktop layout (default is tiling)
# workspace_layout tabbed <stacking|tabbed>

# Configure border style <normal|1pixel|pixel xx|none|pixel>
new_window pixel 1
new_float normal

# Hide borders
hide_edge_borders none

# change borders
bindsym $mod+u border none
bindsym $mod+y border pixel 1
bindsym $mod+n border normal

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font xft:URWGothic-Book 11

# Use Mouse+$mod to drag floating windows
floating_modifier $mod

# start a terminal
bindsym $mod+Return exec alacritty

# kill focused window
bindsym $mod+Shift+q kill

# start program launcher
bindsym $mod+d exec --no-startup-id dmenu_recency

# launch categorized menu
bindsym $mod+z exec --no-startup-id morc_menu

################################################################################################
## sound-section - DO NOT EDIT if you wish to automatically upgrade Alsa -> Pulseaudio later! ##
################################################################################################

exec --no-startup-id volumeicon
bindsym $mod+Ctrl+m exec terminal -e 'alsamixer'
#exec --no-startup-id pulseaudio
#exec --no-startup-id pa-applet
#bindsym $mod+Ctrl+m exec pavucontrol

################################################################################################

# Screen brightness controls
# bindsym XF86MonBrightnessUp exec "xbacklight -inc 10; notify-send 'brightness up'"
# bindsym XF86MonBrightnessDown exec "xbacklight -dec 10; notify-send 'brightness down'"

# Start Applications
bindsym $mod+t exec --no-startup-id pkill compton
bindsym $mod+Ctrl+t exec --no-startup-id compton -b
bindsym $mod+Shift+d --release exec "killall dunst; exec notify-send 'restart dunst'"
bindsym Print exec --no-startup-id i3-scrot
bindsym $mod+Print --release exec --no-startup-id i3-scrot -w
bindsym $mod+Shift+Print --release exec --no-startup-id i3-scrot -s
bindsym $mod+Ctrl+x --release exec --no-startup-id xkill

focus_follows_mouse no

{% set mmaps = [('h','j','k','l'), ('Left','Down','Up','Right')]-%}
{% set mops = (('','focus'),('Shift+','move')) -%}
{% for op in mops %}{% for map in mmaps %}
{% for m in range(4) %}bindsym $mod+{{op[0]}}{{map[m]}} {{op[1]}} {{ mmaps[1][m].lower() }}
{% endfor %}{% endfor %}{% endfor %}

# workspace back and forth (with/without active container)
workspace_auto_back_and_forth yes
bindsym $mod+b workspace back_and_forth
bindsym $mod+Shift+b move container to workspace back_and_forth; workspace back_and_forth

# split orientation
# bindsym $mod+h split h;exec notify-send 'tile horizontally'
# bindsym $mod+v split v;exec notify-send 'tile vertically'
bindsym $mod+q split toggle

# toggle fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# toggle sticky
bindsym $mod+Shift+s sticky toggle

# focus the parent container
bindsym $mod+a focus parent

# move the currently focused window to the scratchpad
bindsym $mod+Shift+minus move scratchpad

# Show the next scratchpad window or hide the focused scratchpad window.
# If there are multiple scratchpad windows, this command cycles through them.
bindsym $mod+minus scratchpad show

#navigate workspaces next / previous
bindsym $mod+Ctrl+Right workspace next
bindsym $mod+Ctrl+Left workspace prev

{% for n in range(1, 9) %}
bindsym $mod+{{n}} workspace {{n}}{# switch to workspace #}
bindsym $mod+Ctrl+{{n}} move container to workspace {{n}}{# Move focused container to workspace #}
bindsym $mod+Shift+{{n}} move container to workspace {{n}}; workspace {{n}}{# Move to workspace with focused container #}
{% endfor %}

# Open applications on specific workspaces
# assign [class="Thunderbird"] $ws1
# assign [class="Pcmanfm"] $ws3

# Open specific applications in floating mode
{% set floaters = ('alsamixer', 'Clipgrab','Simple-scan', 'GParted','Pavucontrol') %}
{% set sticky = ('Nitrogen', 'Lxappearance') %}
{% for f in floaters %}for_window [class="{{f}}"] floating enable border normal
{% endfor %}
{% for s in sticky %}for_window [class="{{s}}"] floating enable sticky enable border normal
{% endfor %}

for_window [class="Oblogout"] fullscreen enable

# switch to workspace with urgent window automatically
for_window [urgent=latest] focus

# reload the configuration file
bindsym $mod+Shift+c reload

# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart

# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

# Set shut down, restart and locking features
bindsym $mod+0 mode "$mode_system"
set $mode_system (l)ock, (e)xit, switch_(u)ser, (s)uspend, (h)ibernate, (r)eboot, (Shift+s)hutdown
mode "$mode_system" {
    bindsym l exec --no-startup-id i3exit lock, mode "default"
    bindsym s exec --no-startup-id i3exit suspend, mode "default"
    bindsym u exec --no-startup-id i3exit switch_user, mode "default"
    bindsym e exec --no-startup-id i3exit logout, mode "default"
    bindsym h exec --no-startup-id i3exit hibernate, mode "default"
    bindsym r exec --no-startup-id i3exit reboot, mode "default"
    bindsym Shift+s exec --no-startup-id i3exit shutdown, mode "default"

    # exit system mode: "Enter" or "Escape"
    bindsym Return mode "default"
    bindsym Escape mode "default"
}

# Resize window (you can also use the mouse for that)
bindsym $mod+r mode "resize"
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode
        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym j resize shrink width 5 px or 5 ppt
        bindsym k resize grow height 5 px or 5 ppt
        bindsym l resize shrink height 5 px or 5 ppt
        bindsym semicolon resize grow width 5 px or 5 ppt

        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # exit resize mode: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
}

# Lock screen
bindsym $mod+9 exec --no-startup-id blurlock

# Autostart applications
exec --no-startup-id /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec --no-startup-id nitrogen --set-zoom-fill --random ~/Pictures/Backgrounds/; sleep 1; compton -b
exec_always feh --bg-scale {{background}}
#exec --no-startup-id manjaro-hello
exec --no-startup-id nm-applet
exec --no-startup-id xfce4-power-manager
exec --no-startup-id pamac-tray
exec --no-startup-id clipit
# exec --no-startup-id blueman-applet
# exec_always --no-startup-id sbxkb
exec --no-startup-id start_conky_maia
# exec --no-startup-id start_conky_green
exec --no-startup-id xautolock -time 10 -locker blurlock
exec_always --no-startup-id ff-theme-util
exec_always --no-startup-id fix_xcursor

# Color palette used for the terminal ( ~/.Xresources file )
# Colors are gathered based on the documentation:
# https://i3wm.org/docs/userguide.html#xresources
# Change the variable name at the place you want to match the color
# of your terminal like this:
# [example]
# If you want your bar to have the same background color as your 
# terminal background change the line 362 from:
# background #14191D
# to:
# background $term_background
# Same logic applied to everything else.
set_from_resource $term_background background
set_from_resource $term_foreground foreground
{% for n in range(16) -%}
set_from_resource $term_color{{n}}     color{{n}}
{% endfor %}

# Start i3bar to display a workspace bar (plus the system information i3status if available)
bar {
	i3bar_command i3bar
	status_command i3status
	position bottom

## please set your primary output first. Example: 'xrandr --output eDP1 --primary'
#	tray_output primary
#	tray_output eDP1

	bindsym button4 nop
	bindsym button5 nop
#   font xft:URWGothic-Book 11
	strip_workspace_numbers yes

    colors {
        background #{{color[0]}}
        statusline #{{color[7]}}
        separator  #{{color[4]}}
        # class            border         backgr.        text  indicator child_border
        focused_workspace  #{{color[10]}} #{{color[10]}} #{{color[15]}}
        active_workspace   #{{color[2]}}  #{{color[2]}}  #{{color[15]}}
        inactive_workspace #{{color[0]}}  #{{color[0]}}  #{{color[15]}}
        urgent_workspace   #{{color[9]}}  #{{color[9]}}  #{{color[15]}}
    }
}

# hide/unhide i3status bar
bindsym $mod+m bar mode toggle

# Theme colors
# class                   border  backgr. text    indic.   child_border
  client.focused          #556064 #556064 #80FFF9 #FDF6E3
  client.focused_inactive #2F3D44 #2F3D44 #1ABC9C #454948
  client.unfocused        #2F3D44 #2F3D44 #1ABC9C #454948
  client.urgent           #CB4B16 #FDF6E3 #1ABC9C #268BD2
  client.placeholder      #000000 #0c0c0c #ffffff #000000 

  client.background       #2B2C2B

#############################
### settings for i3-gaps: ###
#############################

# Set inner/outer gaps
gaps inner 14
gaps outer -2

# Additionally, you can issue commands with the following syntax. This is useful to bind keys to changing the gap size.
# gaps inner|outer current|all set|plus|minus <px>
# gaps inner all set 10
# gaps outer all plus 5

# Smart gaps (gaps used if only more than one container on the workspace)
smart_gaps on

# Smart borders (draw borders around container only if it is not the only container on this workspace) 
# on|no_gaps (on=always activate and no_gaps=only activate if the gap size to the edge of the screen is 0)
smart_borders on

# Press $mod+Shift+g to enter the gap mode. Choose o or i for modifying outer/inner gaps. Press one of + / - (in-/decrement for current workspace) or 0 (remove gaps for current workspace). If you also press Shift with these keys, the change will be global for all workspaces.
set $mode_gaps Gaps: (o) outer, (i) inner
set $mode_gaps_outer Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)
set $mode_gaps_inner Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)
bindsym $mod+Shift+g mode "$mode_gaps"

mode "$mode_gaps" {
        bindsym o      mode "$mode_gaps_outer"
        bindsym i      mode "$mode_gaps_inner"
        bindsym Return mode "default"
        bindsym Escape mode "default"
}

{% for side in ('inner', 'outer') %}
mode "$mode_gaps_{{side}}" {
        {% for shift in (('','current'), ('Shift+', 'all')) %}
        bindsym {{shift[0]}}plus  gaps {{side}} {{shift[1]}} plus 5
        bindsym {{shift[0]}}minus gaps {{side}} {{shift[1]}} minus 5
        bindsym {{shift[0]}}0     gaps {{side}} {{shift[1]}} set 0
        {% endfor %}
        bindsym Return mode "default"
        bindsym Escape mode "default"
}
{% endfor %}

exec ricer ~/.remote_config/themes.yml