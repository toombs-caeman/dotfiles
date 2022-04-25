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

# INSTALL (WIP)
add $RC/bin to $PATH in .profile lets it be available in i3config after restart
```sh
command -v apt && INSTALLER='sudo apt install'
command -v pacman && INSTALLER='sudo pacman -S'
$INSTALL git fzf neovim bash zsh
here="${BASH_SOURCE%/*}"
printf 'PATH="$PATH:/%s/bin"' "$here" >> ~/.profile
printf '. %s/rc.sh' "$here" >> ~/.bashrc
printf '. %s/rc.sh' "$here" >> ~/.zshrc
$here/ricer -t dracula
```



# TODO
* ricer
    * add {{font}}
* git workflow
    * [forgit](https://github.com/wfxr/forgit)?
    * [git-delta](https://github.com/dandavison/delta)
* editor - pick one
  * neovim
    * [lunarvim](https://www.lunarvim.org/) ide
  * kakoune
      * [themes](https://github.com/anhsirk0/kakoune-themes)
      * kakoune-surround
  * vim
    * [fzf-vim](https://github.com/junegunn/fzf/blob/master/README-VIM.md)
* font
  * [nerdfonts](https://www.nerdfonts.com/)
  * [FiraCode](https://github.com/tonsky/FiraCode)
  * [hack](https://github.com/source-foundry/Hack)
* keyboard
  * save layout
  * flash instructions
* WM / DE
  * arrange windows
  * notifications
    * dunst isn't configured, currently using inotify-osd
    * [notifications](http://blog.z3bra.org/2014/04/pop-it-up.html)
  * clipboard
  * status bar
  * network/wifi manager
  * audio
    * volume
    * eq
  * launcher
  * switcher
  * closer
  * keybindings
    * copy mac keybindings to bring over to linux
    * also check out [regolith](https://regolith-linux.org/)
* backup utility
  * [restic](https://restic.net/)
  * [rsync](https://rsync.samba.org/)
* media
  * mpd
  * mpv
  * bookmark cache

# Potential new stuff
* visualize vim keymaps by mode+leader+modifier
    * https://www.asciiart.eu/computers/keyboards
    * `vim -e +"redir>>/dev/stdout | map | redir END" -scq`
* new computer bootstrap script
* define the One True Way™ and make sure all tools are built on that
    * external tools
        * git bat(batcat) exa rg kak zsh fzf dasel sqlite3 find python zsh bash
    * ricer - configuration
        * nix graphics
    * navi - hack together a movement script based around fzf
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

