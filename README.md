a grab bag of stuff that personalizes my computers

# general bent
I use i3-gaps and neovim heavily on some arch derivative.

# keymaps
semantically i3 and vim have a bit of overlap in the 'arranging tiles' department so i3 gets the Meta key and vim gets the alt key,
but I try to give keys the same semantic meaning.

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
* create install media
    * [Download arch](https://archlinux.org/download/)
    * flash to media `dd if=/path/to/iso of=/dev/sdX bs=4M`
* base install
    * [archinstall?](https://wiki.archlinux.org/title/Archinstall)
    * `sudo pacman -S --needed git`
    * `mkdir -p ~/my/toombs-caeman/; cd "$_"`
    * `git clone git@github.com:toombs-caeman/dotfiles.git`
    * source and run `scripts/setup.sh`

# New structure
* /
    * install - script for new computers with dotfiles
    * bin/
        * rc - source in shell
        * updaterc - update system templates
        * lib - shell library
        * blog
    * static/ - static web resources, images etc.
    * raw/ - web content rendered with `blog`
        * index.html
        * bin/index.html
        * static/index.html
        * templates/index.html
        * themes/index.html
        * toybox/index.html
    * templates/ - system and web templates
    * themes/ - ricer themes
    * toybox/ - random half-baked stuff

# TODO
* launcher doesn't correctly set fzf options (keybindings)
* keyboard
  * save layout
  * flash instructions
* WM / DE
  * arrange windows
  * notifications
    * [notifications](http://blog.z3bra.org/2014/04/pop-it-up.html)
  * clipboard
  * status bar
  * network/wifi manager
  * audio eq
  * launcher
  * switcher
  * closer
* backup utility
  * [restic](https://restic.net/)
  * [rsync](https://rsync.samba.org/)
  * needs bi-directional notifications in case something breaks
    * source and sink need to notify if no backup or ack for N days
    * sink needs to notify if drive has failed, or has many bad sectors (maybe smartmontools)
    * very occassionally, notify that everything is working
* media
  * mpd - needs configuration template
  * mpc
  * bookmark cache


# Potential new stuff
* [mosh](https://mosh.org/) or [eternal terminal](https://eternalterminal.dev/)
    * rrc
* a 'media repository' for stuff that doesn't fit in git well?
    * images, video, audio
* visualize vim keymaps by mode+leader+modifier
    * https://www.asciiart.eu/computers/keyboards
    * `vim -e +"redir>>/dev/stdout | map | redir END" -scq`
* define the One True Way™ and make sure all tools are built on that
    * external tools
        * git bat(batcat) exa rg kak zsh fzf dasel sqlite3 find python zsh bash
    * ricer - configuration
        * nix graphics
    * micro languages
      * parsing language (pyparsing?)
      * regex
        * [Posix ERE](https://www.regular-expressions.info/posix.html)
      * templating language
        * [moustache](https://mustache.github.io/mustache.5.html) templating
        * [jinja](https://jinja.palletsprojects.com)
        * python's [f-string](https://peps.python.org/pep-0498/)
      * data format
        * [TOML](https://github.com/toml-lang/toml)
        * [YAML](https://yaml.org/), or pseudo-INI
        * [Tablatal / Indental](https://wiki.xxiivv.com/site/tablatal.html)
      * more than a consistent format, it's more important to have a consistent data query language
        * [dasel](https://github.com/TomWright/dasel) 
        * [gron](https://github.com/tomnomnom/gron) for grepping json
    * a modern (incompatible) ncurses [notcurses](https://github.com/dankamongmen/notcurses) [site](https://notcurses.com/)
* bookmark / cache / rss / scraper tool
    * merge and manage bookmarks and cached content
        * maybe just use [buku](https://github.com/jarun/buku)
    * keep a shallow cache of bookmarked websites in case they disappear
      * search for dead links
      * update cache from the wayback machine if necessary
    * allow annotations
    * cron to ping sites that regularly update and send a notification
    * generate a local rss feed from subscriptions and new content
    * pull new bookmarks from chrome / firefox
      * use folders/tags to trigger extra actions
    * ref [fraidycat](https://fraidyc.at/)
* push notifications?
* idea sources
    * [dotfiles.io](http://dotfiles.github.io/)
    
* file watcher
    * [entr](https://github.com/eradman/entr) 
    * [list of file watchers](https://anarc.at/blog/2019-11-20-file-monitoring-tools/)
* [bespoke software](https://routley.io/posts/bespoke-software-rss-aggregator/)
* [awesome shell](https://github.com/alebcay/awesome-shell)
* [fzf completion menu]( https://reposhub.com/linux/shell-script-development/Aloxaf-fzf-tab.html)
* [fzf history menu](https://medium.com/@ankurloriya/fzf-command-make-your-history-command-smarter-3294dfd1272f)
* [moreutils vipe](https://joeyh.name/code/moreutils/) 
* detect headphone plugin and button presses
    * [ref](https://unix.stackexchange.com/questions/25776/detecting-headphone-connection-disconnection-in-linux)
    * [mpd_sima](https://kaliko.me/mpd-sima/)
* email/rss as a transport protocol
    * [social media on top of rss](https://news.ycombinator.com/item?id=33975082)

* git stuff
    * [git appraise](https://github.com/google/git-appraise)
    * [git note](https://git-scm.com/docs/git-notes)
    * [forgit](https://github.com/wfxr/forgit)?
    * [git-delta](https://github.com/dandavison/delta)
    * wysiwyg web editor that uses a git/markdown backend for documentation
        * [footnotes](https://www.monde-diplomatique.fr/2021/01/PIGEAUD/62633)

* just like how kde and gnome have their 'system settings' which shows graphically the different capabilities of the computer, I'd like to piece together a TUI
    * nmtui
    * alsamixer
    * bluetuith?
    * brightness, (simple) volume
    * pactl - change sound sink, pavucontrol

* send reminders 10 seconds later `systemd-run --user --on-active=10 /usr/bin/notify-send message`
    * [systemd timers](https://wiki.archlinux.org/title/Systemd/Timers)
    * compare with cron?

* https://news.ycombinator.com/item?id=36461102
* [nerd-dictation](https://github.com/ideasman42/nerd-dictation) speech to text
* [find archived youtube videos](https://findyoutubevideo.thetechrobo.ca/)
* multiple monitors
    * xrandr - CLI
    * arandr - GUI
    * autodetect & connect [autorandr](https://github.com/phillipberndt/autorandr)
