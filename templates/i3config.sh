# i3 config file (v4)
# Please see http://i3wm.org/docs/userguide.html for a complete reference!
# also /etc/i3/config

# managed with ricer

# Set mod key (Mod1=<Alt>, Mod4=<Super>)
set $mod Mod4

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
# i3-sensible-terminal should *always* be available, so we shouldn't get locked out.
bindsym $mod+Return exec i3-sensible-terminal

# kill focused /selected window
bindsym $mod+Shift+q kill
bindsym $mod+Ctrl+q --release exec --no-startup-id xkill

# start program launcher
bindsym $mod+space exec "i3-sensible-terminal -T launcher -e launch"
for_window [title="launcher"] floating enable, border none, resize set width 25 ppt height 25 ppt, move absolute position center

# screenshots
bindsym Print exec --no-startup-id i3-scrot
bindsym $mod+Print --release exec --no-startup-id i3-scrot -w
bindsym $mod+Shift+Print --release exec --no-startup-id i3-scrot -s

# split orientation
bindsym $mod+q split toggle

# toggle fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# hide/unhide i3status bar
bindsym $mod+m bar mode toggle

focus_follows_mouse no
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

workspace_auto_back_and_forth yes
bindsym $mod+Tab workspace back_and_forth

bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
bindsym $mod+6 workspace 6
bindsym $mod+7 workspace 7
bindsym $mod+8 workspace 8
bindsym $mod+9 workspace 9

bindsym $mod+Shift+1 move container to workspace 1; workspace 1
bindsym $mod+Shift+2 move container to workspace 2; workspace 2
bindsym $mod+Shift+3 move container to workspace 3; workspace 3
bindsym $mod+Shift+4 move container to workspace 4; workspace 4
bindsym $mod+Shift+5 move container to workspace 5; workspace 5
bindsym $mod+Shift+6 move container to workspace 6; workspace 6
bindsym $mod+Shift+7 move container to workspace 7; workspace 7
bindsym $mod+Shift+8 move container to workspace 8; workspace 8
bindsym $mod+Shift+9 move container to workspace 9; workspace 9

# bind volume keys to change master volume
bindsym XF86AudioRaiseVolume exec --no-startup-id volume 3%+
bindsym XF86AudioLowerVolume exec --no-startup-id volume 3%-
bindsym XF86AudioMute exec --no-startup-id volume toggle
bindsym XF86MonBrightnessUp exec --no-startup-id brightness 10000
bindsym XF86MonBrightnessDown exec --no-startup-id brightness -10000

# mpd
bindsym $mod+p exec --no-startup-id mpc toggle
bindsym $mod+n exec --no-startup-id mpc next
bindsym $mod+Shift+n exec "i3-sensible-terminal -T launcher -e muse"
exec_always --no-startup-id muse init

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

exec --no-startup-id xautolock -time 10 -locker "i3lock -c {{background}}"
bindsym $mod+0 mode "$mode_system"
set $mode_system (l)ock, (e)xit, (r)eboot, (s)hutdown
mode "$mode_system" {
    bindsym $mod+0 mode "default", exec --no-startup-id xautolock -locknow
    bindsym l mode "default", exec --no-startup-id xautolock -locknow
    bindsym e mode "default", exec --no-startup-id i3-msg exit
    bindsym r mode "default", exec --no-startup-id reboot now
    bindsym r mode "default", exec --no-startup-id shutdown now

    # exit system mode: "Enter" or "Escape"
    bindsym Return mode "default"
    bindsym Escape mode "default"
}

# Resize window (you can also use the mouse for that)
bindsym $mod+r mode "resize"
mode "resize" {
        bindsym h resize shrink width 5 px or 5 ppt
        bindsym j resize grow height 5 px or 5 ppt
        bindsym k resize shrink height 5 px or 5 ppt
        bindsym l resize grow width 5 px or 5 ppt

        # exit resize mode: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
}



# Start i3bar to display a workspace bar (plus the system information i3status if available)
bar {
    i3bar_command i3bar
    status_command mpdbar
    position top

## please set your primary output first. Example: 'xrandr --output eDP1 --primary'
#   tray_output primary
#   tray_output eDP1

    bindsym button4 nop
    bindsym button5 nop
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

# class                 border          bground         text        indicator       child_border
client.focused          #{{cursor}}     #{{color8}}     #{{color7}} #{{color8}}     #{{color8}}
client.focused_inactive #{{background}} #{{cursor}}     #{{color7}} #{{cursor}}     #{{background}}
client.unfocused        #{{background}} #{{background}} #{{color8}} #{{background}} #{{background}}
client.urgent           #{{cursor}}     #{{color1}}     #{{color7}} #{{color1}}     #{{color1}}
client.placeholder      #{{background}} #{{background}} #{{color7}} #{{background}} #{{background}}

client.background       #{{color7}}


#  copy/paste
bindsym $mod+c --release exec --no-startup-id copypasta c
bindsym $mod+v --release exec --no-startup-id copypasta v

# Autostart applications
exec --no-startup-id /usr/bin/transmission-daemon
exec --no-startup-id /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec --no-startup-id picom -b
exec_always --no-startup-id feh --bg-fill '{{wallpaper}}' --no-fehbg --image-bg '#{{background}}'
exec --no-startup-id nm-applet
exec --no-startup-id i3-msg 'exec firefox'
exec --no-startup-id i3-msg 'exec steam -silent'

# this may throw an error if using i3 (not i3-gaps)
gaps inner 5
smart_gaps on
# XXX one per line
# on firefox, map alt- t w to ctrl keys, as part of wink
# laptop volume keys
# $mod+Tab to flip between workspaces

