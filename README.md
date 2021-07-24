This repository is intended as a one stop shop for maintaining a consistent configuration across several machines.

This allows a fully functional copy of the repo with only `git clone`, while still keeping project histories cleanly separate.

# Principles
* less is more
* robust is simple
* bound the problem
    * define a 'core' set of tooling which must exist (with consistent implementations)
        - warn/bail if things don't look good
        - eg: bash version, vim version, python version
    * define a 'check' set which may have different options available in different implementations
        - gracefully degrade
        - gnu options aren't always available
* context includes
	* history - separate global and shell searching
    * core commands
	* prompt
	* shortcuts/keybindings
        * copy/paste is the big one
    * color/fonts

# TODO
* separate blog into baffle, barkdown, and blog
* get ricer off of python, reuse baffle
    * save the interesting color charting, but rely on solarized https://ethanschoonover.com/solarized/
* create an interface for darwin/nix.sh to achieve parity
    * notifications/bells
    * xdg_open
* use name of 'most advanced' option for alias when degradation is expected
    * bat -> cat
    * rg -> grep



# Installation

direct installation is not recommended. Instead, use this as a pattern for constructing your own dotfiles.
If you fork this repo for your own use, you will want to change:
* contexts/default/
* themes.yml
* the prompt in pretty.sh

# Dependencies

core components are expected:
* alacritty or iterm2
* bash or zsh
* coreutils

tools will be configured if they are available:
* kubectl
* python virtualenv
* golang
* git
* bat
* ripgrep
* fzf

# TODO: general
* set fzf to use rg as the search command
* bring shell up to zsh
* git subrepo push
* git workflow
	* forgit interactive git https://github.com/wfxr/forgit
	* update git aliases
* consider moving fully to exa/kak/fzf/delta. making use of moreutils.
* git-fzf search is broken?, try combining with 'git grep' or ripgrep
* https://routley.io/posts/bespoke-software-rss-aggregator/
* git-delta https://github.com/dandavison/delta

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
* https://old.reddit.com/r/dotfiles/
* http://dotfiles.github.io/
* https://old.reddit.com/r/startpages/
* include whitefox layout
* unified backup utility, use restic?
* firefox
    - userChrome.css
    - https://www.userchrome.org/how-create-userchrome-css.html
    - https://userstyles.org/styles/98305/solarized-dark-everywhere
    - https://old.reddit.com/r/FirefoxCSS/
* mosh
* https://github.com/andreyorst/fzf.kak
* path extractor https://github.com/edi9999/path-extractor
* entr for inotifywatch like file change watching
* gron for grepping json


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

## data
HISTFILE - shell history
bookmarks - load and restore to firefox/chrome?
projects/ - containing projects

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