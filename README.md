a grab bag of stuff that personalizes my computers

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

# TODO
* kakoune
  * https://github.com/anhsirk0/kakoune-themes
  * kakoune-surround
* OS/keybinding level integration
    * notifications clipboard volume launcher closer
* install / check script for dependencies
    * pseudo- GNU stow? symlink out and store a copy of the original, then restore if necessary
* define the One True Way™ and make sure all tools are built on that
    * external tools
        * git bat(batcat) exa rg kak zsh fzf dasel sqlite3 find python
    * ricer - configuration
        * nix graphics
    * navi - hack together a movement script based around fzf
    * micro languages
      * parsing language (pyparsing?)
      * regex
      * templating language - consider moustache
      * data format - [TOML](https://github.com/toml-lang/toml), [YAML](https://yaml.org/), or pseudo-INI
        * tabular data, json-like [Tablatal / Indental](https://wiki.xxiivv.com/site/tablatal.html)
* create an interface for darwin/nix to achieve parity
* bookmark / cache / rss / scraper tool
    * merge and manage bookmarks and cached content
        * maybe just use [buku](https://github.com/jarun/buku)
    * keep a shallow cache of bookmarked websites in case they disappear
    * allow annotations
    * cron to ping sites that regularly update and send a notification
    * generate a local rss feed from subscriptions and new content
    * pull new bookmarks from chrome / firefox
* git workflow
    * [forgit](https://github.com/wfxr/forgit)?
    * [git-delta](https://github.com/dandavison/delta)
* mpd
* mpv
* copy mac keybindings to bring over to linux
  * also check out [regolith](https://regolith-linux.org/)
* fix dmenu launch replacement, needs some history
* include bash profile to initialize graphical interface
* nail down graphics pipline for x and wayland
    - make switch configurable through ricer
    - X
        * i3-gaps
        * feh
        * dunst
        * conky maia
    - wayland
        * sway
        * swaybg
        * mako
        * system monitor?
* notifications? http://blog.z3bra.org/2014/04/pop-it-up.html
* unified backup utility, use restic?
* ssh/mosh
  * 'forwarding' rc.sh over to the remote?

## potential additions / things to look at
* data formats
    * [moustache](https://mustache.github.io/mustache.5.html) templating

* idea sources
    * [dotfiles.io](http://dotfiles.github.io/)
    
* use as inspiration, but not directly
    * [sparklines](https://github.com/holman/spark/blob/master/spark)
    * [has](https://github.com/kdabir/has/blob/master/has)
    
* file watcher
    * [entr](https://github.com/eradman/entr) 
    * [list of file watchers](https://anarc.at/blog/2019-11-20-file-monitoring-tools/)
* https://routley.io/posts/bespoke-software-rss-aggregator/
* include whitefox layout
* [gron](https://github.com/tomnomnom/gron) for grepping json
* [awesome shell](https://github.com/alebcay/awesome-shell)
* [fzf completion menu]( https://reposhub.com/linux/shell-script-development/Aloxaf-fzf-tab.html)
* [fzf history menu](https://medium.com/@ankurloriya/fzf-command-make-your-history-command-smarter-3294dfd1272f)
* [moreutils vipe](https://joeyh.name/code/moreutils/) 
* [dasel](https://github.com/TomWright/dasel)

