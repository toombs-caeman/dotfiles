# i3 config file (v4)
# Please see http://i3wm.org/docs/userguide.html for a complete reference!
# also /etc/i3/config

# managed with ricer

# Set mod key (Mod1=<Alt>, Mod4=<Super>)
set $mod Mod4

# set default desktop layout (default is tiling)
# workspace_layout tabbed <stacking|tabbed>

# Configure border style <normal|1pixel|pixel xx|none|pixel>
new_window pixel 2
new_float normal
hide_edge_borders none

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
#font xft:URWGothic-Book 11
font xft:FiraCode-Regular 11

# Use Mouse+$mod to drag floating windows
floating_modifier $mod

# start a terminal
bindsym $mod+Return exec alacritty
#bindsym $mod+Return exec xterm

# kill focused /selected window
bindsym $mod+Shift+q kill
bindsym $mod+Alt+q --release exec --no-startup-id xkill

# start program launcher
bindsym $mod+space exec alacritty -t launcher -e launch
#bindsym $mod+space exec "alacritty -t launcher -e bash -c 'echo $PATH; sleep 10'"
for_window [title="launcher"] floating enable, border none, resize set width 25 ppt height 25 ppt, move absolute position center


# Start Applications
bindsym $mod+t exec --no-startup-id pkill compton
bindsym $mod+Ctrl+t exec --no-startup-id compton -b
bindsym $mod+Shift+d --release exec "killall dunst; exec notify-send 'restart dunst'"

# copy/paste
bindsym $mod+c --release exec --no-startup-id copypasta copy
bindsym $mod+v --release exec --no-startup-id copypasta paste

# screenshots
bindsym Print exec --no-startup-id i3-scrot
bindsym $mod+Print --release exec --no-startup-id i3-scrot -w
bindsym $mod+Shift+Print --release exec --no-startup-id i3-scrot -s

focus_follows_mouse no

# movement
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right
# workspace back and forth (with/without active container)
workspace_auto_back_and_forth yes
#bindsym $mod+b workspace back_and_forth
#bindsym $mod+Shift+b move container to workspace back_and_forth; workspace back_and_forth

# split orientation
# bindsym $mod+h split h;exec notify-send 'tile horizontally'
# bindsym $mod+v split v;exec notify-send 'tile vertically'
bindsym $mod+q split toggle

# toggle fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
#bindsym $mod+s layout stacking
#bindsym $mod+w layout tabbed
#bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
#bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

bindsym $mod+1 workspace 1
bindsym $mod+Ctrl+1 move container to workspace 1
bindsym $mod+Shift+1 move container to workspace 1; workspace 1

bindsym $mod+2 workspace 2
bindsym $mod+Ctrl+2 move container to workspace 2
bindsym $mod+Shift+2 move container to workspace 2; workspace 2

bindsym $mod+3 workspace 3
bindsym $mod+Ctrl+3 move container to workspace 3
bindsym $mod+Shift+3 move container to workspace 3; workspace 3

bindsym $mod+4 workspace 4
bindsym $mod+Ctrl+4 move container to workspace 4
bindsym $mod+Shift+4 move container to workspace 4; workspace 4

bindsym $mod+5 workspace 5
bindsym $mod+Ctrl+5 move container to workspace 5
bindsym $mod+Shift+5 move container to workspace 5; workspace 5

bindsym $mod+6 workspace 6
bindsym $mod+Ctrl+6 move container to workspace 6
bindsym $mod+Shift+6 move container to workspace 6; workspace 6

bindsym $mod+7 workspace 7
bindsym $mod+Ctrl+7 move container to workspace 7
bindsym $mod+Shift+7 move container to workspace 7; workspace 7

bindsym $mod+8 workspace 8
bindsym $mod+Ctrl+8 move container to workspace 8
bindsym $mod+Shift+8 move container to workspace 8; workspace 8

# bind volume keys to change master volume
bindsym XF86AudioRaiseVolume exec --no-startup-id amixer sset -c 2 'Master' 3%+
bindsym XF86AudioLowerVolume exec --no-startup-id amixer sset -c 2 'Master' 3%-
# Open specific applications in floating mode
for_window [class="alsamixer"] floating enable border normal
for_window [class="Clipgrab"] floating enable border normal
for_window [class="Simple-scan"] floating enable border normal
for_window [class="GParted"] floating enable border normal
for_window [class="Pavucontrol"] floating enable border normal

for_window [class="Nitrogen"] floating enable sticky enable border normal
for_window [class="Lxappearance"] floating enable sticky enable border normal

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
        bindsym h resize shrink width 5 px or 5 ppt
        bindsym j resize grow height 5 px or 5 ppt
        bindsym k resize shrink height 5 px or 5 ppt
        bindsym l resize grow width 5 px or 5 ppt

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
exec --no-startup-id compton -b
exec_always --no-startup-id feh --bg-fill {{wallpaper}} --no-fehbg --image-bg '#{{color0}}'
#exec --no-startup-id manjaro-hello
exec --no-startup-id nm-applet
exec --no-startup-id xfce4-power-manager
exec --no-startup-id pamac-tray
# exec --no-startup-id blueman-applet
exec --no-startup-id start_conky_maia
# exec --no-startup-id start_conky_green
exec --no-startup-id xautolock -time 10 -locker blurlock
exec_always --no-startup-id ff-theme-util
exec_always --no-startup-id fix_xcursor

exec --no-startup-id i3-msg 'exec /usr/bin/firefox'
exec --no-startup-id i3-msg 'exec /usr/games/steam -silent'

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
set_from_resource $term_color0     color0
set_from_resource $term_color1     color1
set_from_resource $term_color2     color2
set_from_resource $term_color3     color3
set_from_resource $term_color4     color4
set_from_resource $term_color5     color5
set_from_resource $term_color6     color6
set_from_resource $term_color7     color7
set_from_resource $term_color8     color8
set_from_resource $term_color9     color9
set_from_resource $term_color10     color10
set_from_resource $term_color11     color11
set_from_resource $term_color12     color12
set_from_resource $term_color13     color13
set_from_resource $term_color14     color14
set_from_resource $term_color15     color15

# Start i3bar to display a workspace bar (plus the system information i3status if available)
bar {
	i3bar_command i3bar
	status_command i3status
	position top

## please set your primary output first. Example: 'xrandr --output eDP1 --primary'
#	tray_output primary
#	tray_output eDP1

	bindsym button4 nop
	bindsym button5 nop
#   font xft:URWGothic-Book 11
	strip_workspace_numbers yes

  colors {
    background #{{background}}
    statusline #{{color7}}
    separator  #{{cursor}}

    focused_workspace  #{{cursor}} #{{cursor}} #{{color7}}
    active_workspace   #{{background}} #{{cursor}} #{{color7}}
    inactive_workspace #{{background}} #{{background}} #{{color8}}
    urgent_workspace   #{{color1}} #{{color1}} #{{color7}}
    binding_mode       #{{color1}} #{{color1}} #{{color7}}
  }
}

# hide/unhide i3status bar
bindsym $mod+m bar mode toggle

# class                 border          bground         text        indicator       child_border
client.focused          #{{cursor}}     #{{color8}}     #{{color7}} #{{color8}}     #{{color8}}
client.focused_inactive #{{background}} #{{cursor}}     #{{color7}} #{{cursor}}     #{{background}}
client.unfocused        #{{background}} #{{background}} #{{color8}} #{{background}} #{{background}}
client.urgent           #{{cursor}}     #{{color1}}     #{{color7}} #{{color1}}     #{{color1}}
client.placeholder      #{{background}} #{{background}} #{{color7}} #{{background}} #{{background}}

client.background       #{{color7}}
# exec --no-startup-id sh -c ricer ~/my/toombs-caeman/dotfiles/themes.yml
