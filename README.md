This repository is intended as a one stop shop for maintaining a consistent configuration across several machines.

This allows a fully functional copy of the repo with only `git clone`, while still keeping project histories cleanly separate.

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
* OS/keybinding level integration
    * notifications clipboard volume launcher closer
* zsh: gg complete is broken
* mono-repo?
* install / check script for dependencies
    * pseudo- GNU stow? symlink out and store a copy of the original, then restore if necessary
* define the One True Way™ and make sure all tools are built on that
    * data format - [TOML](https://github.com/toml-lang/toml), [YAML](https://yaml.org/), or pseudo-INI
    * external tools
        * git bat(batcat) exa rg kak zsh fzf dasel sqlite3 find chevron python
    * bookie - merge and manage bookmarks and cached content
    * ricer - configuration
        * [solarized everywhere](https://ethanschoonover.com/solarized/)
        * nix graphics
* separate blog into baffle, barkdown, and blog
    * consider [lowdown](https://kristaps.bsd.lv/lowdown/)
    * consider moustache
* create an interface for darwin/nix to achieve parity
* bookmark / cache / rss / scraper tool
    * keep a shallow cache of bookmarked websites in case they disappear
    * allow annotations
    * cron to ping sites that regularly update and send a notification
    * generate a local rss feed from subscriptions and new content
    * pull new bookmarks from chrome / firefox
* git workflow
	* [forgit](https://github.com/wfxr/forgit)?
* Iterm2 config

# Installation
direct installation is not recommended. Instead, use this as a pattern for constructing your own dotfiles.
If you fork this repo for your own use, you will want to change:
* contexts/default/
* themes.yml
* the prompt in pretty.sh

# TODO: general

# TODO: linux graphics pipeline
* copy mac keybindings to bring over to linux
* fix dmenu launch replacement, needs some history
* include bash profile to initialize graphical interface
* nail down graphics pipline for x and wayland
    - make switch configurable through ricer
    - X
        * i3
        * feh
        * dunst
        * conky maia
    - wayland
        * sway
        * swaybg
        * mako
        * system monitor?
* notifications? http://blog.z3bra.org/2014/04/pop-it-up.html
* oomox for theming gtk icons?
* https://wiki.installgentoo.com/index.php/GNU/Linux_ricing
* https://old.reddit.com/r/wallpaperdump/

# TODO: Cygwin
* add brew to pm
* track xdg-settings, somehow unify xdg-open and mac's open -a

## potential additions / things to look at
* data formats
    * Tablatal / Indental
    * [moustache](https://mustache.github.io/mustache.5.html) templating

* idea sources
    * [r/dotfiles](https://old.reddit.com/r/dotfiles/)
    * [dotfiles.io](http://dotfiles.github.io/)
    * https://old.reddit.com/r/startpages/
    
* use as inspiration, but not directly
    * [sparklines](https://github.com/holman/spark/blob/master/spark)
    * [has](https://github.com/kdabir/has/blob/master/has)
    
* file watcher
    * [entr](https://github.com/eradman/entr) 
    * [list of file watchers](https://anarc.at/blog/2019-11-20-file-monitoring-tools/)
* https://routley.io/posts/bespoke-software-rss-aggregator/
* git-delta https://github.com/dandavison/delta
* include whitefox layout
* unified backup utility, use restic?
* firefox
    - userChrome.css
    - https://www.userchrome.org/how-create-userchrome-css.html
    - https://userstyles.org/styles/98305/solarized-dark-everywhere
    - https://old.reddit.com/r/FirefoxCSS/
* ssh/mosh
* path extractor https://github.com/edi9999/path-extractor
* [gron](https://github.com/tomnomnom/gron) for grepping json
* https://github.com/alebcay/awesome-shell
* fzf completion menu https://reposhub.com/linux/shell-script-development/Aloxaf-fzf-tab.html
* fzf history menu https://medium.com/@ankurloriya/fzf-command-make-your-history-command-smarter-3294dfd1272f
* [moreutils vipe](https://joeyh.name/code/moreutils/) 
* [dasel](https://github.com/TomWright/dasel)


# TODO Cobalt
This is an interaction language with [verbs that can act on many objects](http://gordonbrander.com/pattern/verbs-that-can-act-on-many-objects/).
It's purpose is to provide a uniform framework manipulation of things commonly manipulated on the commandline
Lol its a CRUD app

## language principles
Sentences have one verb and a Noun. They represent a single command and have a canonical representation that approximates an english sentence.

Adverbs control whether Verbs ask for confirmation, go right ahead, or just explain the plan.
Verbs may mean slightly different things when applied to different Nouns.

Nouns describe one or more objects of a single type.
Nouns may be patterns or concrete.

Verbs can sometimes be omitted.
* Delete must always be specified
* Noun patterns can't be used with Create, so default to Open
* concrete Nouns specify Create then Open

## parts of speech
adverbs:
* forcefully  - don't confirm before exec
* politely    - confirm before exec
* plan to     - plan an action but don't execute it

verbs:
* Create - make a new thing. idempotent. No patterns.
* Open   - basically xdg_open, but don't actually use xdg_open.
* List   - list real objects that match Noun
* Delete - delete

nouns:
* url  - http(s) remote
* proj - refers to any project in scope (for now, git repositories under ~/)
         * should git internals also fit here? (commit, branch, file)
* dir  - a local directory
* file - a local file
* hist - shell history
* ssh  - ssh remote
* here ? current diretory as either DIR or PROJ
* host ? the remote of current PROJ
* k8s  ? kubernetes resources


## examples
* Url  
    * Create - add bookmark
    * Open   - xdg_open in $BROWSER, never autocreate
    * List   - list bookmarks
    * Delete - remove bookmarks
    
* Proj 
    * Create - git init and push to remote. remote is known since canonically named by url
    * Open   - cd Proj
    * List   - find ~ -type d -name '.git'
    * Delete - rm Proj. Polite unless its clean and all branches are pushed.
       
* Dir  
    * Create - mkdir
    * Open   - cd
    * List   - ls
    * Delete - rmdir

* File 
    * Create - touch
    * Open   - $EDITOR 
    * List   - ls
    * Delete - rm
* Hist 
    * Create ? 
    * Open   - re-run command
    * List   - list command
    * Delete ?
* Ssh  
    * Create ?
    * Open   - connect to host
    * List   - list known hosts
    * Delete - remove from known hosts
* Here
    * Create - git fetch?
    * Open   - git pull
    * List   - ls .
    * Delete - git reset HEAD
* Host 
    * Open - connect to host
    * List - list hosts
    * Delete - remove from known hosts

## technical design
* use a keybinding to start interactively building a plan, when complete, append it to the existing input line. potentially wrapped in "$()"
* iteratively refine the Noun until confirmed somehow. Display the default verb too.
* Like git, seperate porcelain from plumbing

plumbing commands:
* parse - generate a type from a NOUN
* list - print a concrete list of items matching a NOUN. return 0 if at least one item
* exec - execute a plan (which may be just a describe)

porcelain
* query - interactively build a plan
* vim plugin - vim bindings?
