#!/bin/bash

# this script is designed to be piped to lemonbar
# https://github.com/LemonBoy/bar

## Define Colors

black="#000000"
red="#FF0000"
green="#00FF00"
blue="#0000FF"
yellow="#FFFF00"
cyan="#00FFFF"
magenta="#FF00FF"
white="#FFFFFF"

reset="%{F-}%{B-}"
## Define alignment
left="%{l}"
center="%{c}"
right="%{r}"

#get the current time
#from https://wiki.archlinux.org/index.php/Lemonbar
Clock() {
    DATETIME=$(date "+%a %b %d, %T")
    # return with colors
    echo -n "$center%{F$white}$DATETIME$reset"
}

# get what cmus is currently playing
CmusStatus() {
        STATUS=$(cmus-remote -Q | sed -n 's,status ,,p')
        #get the current playing file
        PLAYING=$(basename $(cmus-remote -Q | sed -n -e 's,file \(.*\)\..*,\1,p'))
        # get the continue/repeat/shuffle status
        CRS=$(cmus-remote -Q | sed -n -e 's,set continue true,C,p' -e 's,set repeat true,R,p' -e 's,set shuffle true,S,p')
        #get system volume
        echo -n "$right%{F$cyan}$PLAYING $STATUS $CRS$reset"
}


# get the system volume
# http://unix.stackexchange.com/questions/89571/how-to-get-volume-level-from-the-command-line
Volume () {
        VOL=$(awk -F"[][]" '/dB/ { print $2 }' <(amixer sget Master))
        echo -n "$right%{F$white}$VOL$reset"
}


# display the current network connection
Networking() {
        # get the name of the active connection using NetworkManager-cli
        NETNAME=$(nmcli -t --fields NAME c show --active)
        echo -n "$left%{F$green}$NETNAME$reset"
}

# print update loop
Loop() {
while true; do
        # this must all be on one line
        echo  $(Networking) $(Clock) $(CmusStatus) $(Volume)
    # update the bar every second
    sleep 1
done
}

Loop 2> /dev/null | lemonbar -d
