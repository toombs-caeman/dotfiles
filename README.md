a grab bag of stuff that personalizes my computers

# Overview

arch + swaywm + kitty + zsh + neovim

Semantically sway and vim have a bit of overlap in the 'arranging tiles' department so sway gets the Meta key and vim gets the alt key, but I try to give keys the same semantic meaning.

fzf is prefered for building interfaces

# Principles
* simplicity is a feature
    * simplicity is robustly encapsulated complexity, not a lack of features
    * know when to stop adding features (still figuring that one out)
* speed is a feature
* consistency is a feature
    * portability is consistency across platforms
    * stability (provided by maintainability) is consistency through time
    * robustness is consistency of behavior
        * behavior is everything from available commands to keybindings to terminal/OS integration
    * be explicit about the One True Way™ and try to stick to it.
* provide rich context
    * careful of visual clutter
    * don't always indicate expected or default state
    * don't be misleading
    * providing search semantics is a great way to make context available
    * cli context includes
        * what happened and what's about to happen (history and completion)
        * who, what, where, when, why (user, command output, directory, timestamp, comments)

# Installation
1. for the full OS, scripts in `iso/` can create a custom install drive.
2. for work computers:
    * `git -C ~/my/toombs-caeman/dotfiles clone https://github.com/toombs-caeman/dotfiles`
    * `echo "PATH=\"\$PATH:~/my/toombs-caeman/dotfiles/bin\"" >> ~/.zprofile`


# Potential new stuff
* [atuin](https://atuin.sh/) magic search history
* [k](https://github.com/supercrabtree/k) - better ls
* [mosh](https://mosh.org/) or [eternal terminal](https://eternalterminal.dev/)
    * rrc
    * [xxh](https://github.com/xxh/xxh)
* a 'media repository' for stuff that doesn't fit in git well?
    * treerat
        * ricer - configuration
* email/rss as a transport protocol
    * [social media on top of rss](https://news.ycombinator.com/item?id=33975082)
* bookmark / cache / rss / scraper tool
    * merge and manage bookmarks and cached content
    * keep a shallow cache of bookmarked websites in case they disappear
      * search for dead links
      * update cache from the wayback machine if necessary
    * allow annotations
    * cron to ping sites that regularly update and send a notification
    * generate a local rss feed from subscriptions and new content
    * pull new bookmarks from chrome / firefox
      * use folders/tags to trigger extra actions
    * ref [fraidycat](https://fraidyc.at/)
* Notifications
    * [swaync](https://github.com/ErikReider/SwayNotificationCente)
    * push notification server [apprise](https://github.com/caronc/apprise)
    * libnotify notify-send for desktop
    * what about mobile? onesignal?
* tabular data cli
    * [sc-im](https://github.com/andmarti1424/sc-im)
    * [visidata](https://www.visidata.org/)
* idea sources
    * [dotfiles.io](http://dotfiles.github.io/)
    * [awesome shell](https://github.com/alebcay/awesome-shell)

* file watcher
    * [entr](https://github.com/eradman/entr)
    * [list of file watchers](https://anarc.at/blog/2019-11-20-file-monitoring-tools/)
* philosophy
    * [bespoke software](https://routley.io/posts/bespoke-software-rss-aggregator/)
    * [an app can be a home cooked meal](https://www.robinsloan.com/notes/home-cooked-app/)
* fzf
    * [fzf completion menu]( https://reposhub.com/linux/shell-script-development/Aloxaf-fzf-tab.html)
    * [fzf history menu](https://medium.com/@ankurloriya/fzf-command-make-your-history-command-smarter-3294dfd1272f)
    * [fzf image preview](https://github.com/junegunn/fzf/issues/3228)
    * [fzf .blend preview](https://docs.blender.org/manual/en/latest/advanced/command_line/render.html)
* detect headphone plugin and button presses
    * [ref](https://unix.stackexchange.com/questions/25776/detecting-headphone-connection-disconnection-in-linux)
    * [mpd_sima](https://kaliko.me/mpd-sima/)

* git stuff
    * git-diagram: show ascii art explaining a proposed operation (merge, rebase, etc.)
    * [git appraise](https://github.com/google/git-appraise)
    * [git note](https://git-scm.com/docs/git-notes)
    * [forgit](https://github.com/wfxr/forgit)?
    * [git-delta](https://github.com/dandavison/delta)
    * wysiwyg web editor that uses a git/markdown backend for documentation
        * [footnotes](https://www.monde-diplomatique.fr/2021/01/PIGEAUD/62633)

* just like how kde and gnome have their 'system settings' which shows graphically the different capabilities of the computer, I'd like to piece together a TUI
    * iwctl
    * wpctl
    * bluetoothctl
    * brightnessctl
    * pavucontrol
    * camera / microphone tests
    * arandr
    * system-config-printer
    * screenshot with slurp / grim

* send reminders 10 seconds later `systemd-run --user --on-active=10 /usr/bin/notify-send message`
    * [systemd timers](https://wiki.archlinux.org/title/Systemd/Timers)
    * compare with cron?

* [find archived youtube videos](https://findyoutubevideo.thetechrobo.ca/)

# TODO
* whitefox keyboard
  * save layout
  * flash instructions
* notify-send is broken?
    * [notifications](http://blog.z3bra.org/2014/04/pop-it-up.html)
* backup utility
  * [restic](https://restic.net/)
  * [rsync](https://rsync.samba.org/)
  * needs bi-directional notifications in case something breaks
    * source and sink need to notify if no backup or ack for N days
    * sink needs to notify if drive has failed, or has many bad sectors (maybe smartmontools)
    * very occassionally, notify that everything is working
* media
  * bookmark cache
* note other programs (but don't include in base installation)
    * krita blender godot android-studio ardour8
    * steam proton-ge-custom-bin
* include non-youtube links in script
