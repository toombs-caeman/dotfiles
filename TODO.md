# TODO

* [nushell wrappers](https://github.com/drbrain/nushell-config/tree/main)
    * provides completions and command output as a table
    * ssh, git, docker, atuin, rg, rsync

* correct `c-v` behavior
    * how to get nushell to use the system clipboard for pasting?

# git section
* nvim + git
    * need to be able to stage, checkout, and commit from within vim
* git-delta?
* vim-git
* mini.git
* mini.diff
* gitsigns
* interactive add, commit?
* vim-fugitive?
* vimagit?
* nushell completer
* aliases
* git config --global merge.conflictstyle diff3
* always set upstream on push
* forgit


# general

* [master keymap](keymap.md)

* kitty keys
    * scroll to prompt `c-{z,x}` -> `c-{j,k}`
    * page last output? map kitty_mod+g `show_last_command_output`

* push blog to github

* ssh
    * sshfs
    * rsync -rR
    * nushell ssh completions

* nvim set noexpandtab for tsv
* nushell section
* theming sectioo setting up a user correctly. (adding user to groups)
* get better about vim marks
* vim custom snippets

* [image.nvim](https://github.com/3rd/image.nvim)
    * unbearably slow. need an alternative
* multihead neovim
    * unmaintained [nwin](https://github.com/glacambre/nwin?tab=readme-ov-file)
    * not quite it [nvr](https://github.com/mhinz/neovim-remote)
    * ext multigrid??
    * ext windows??
    * https://github.com/topics/neovim-guis

# nvim debug
* mini.misc.put()
* mini.test
* plenary.test_harness


# nushell section
* shell history? [atuin](https://atuin.sh/)
* nushell [carapace completer](https://github.com/carapace-sh/carapace)
    * make sure the bindings have parity with nvim-cmphePrimeagen
* hook command-not-found
* explore nushell stdlib and nu_scripts
    * contribute hypr completions [custom-completions](https://github.com/nushell/nu_scripts/tree/main/custom-completions)
    * contribute to documentation
    * poor mans fzf: input list -f

# theming
* standardize nvim-web-dev-icons vs mini.icons vs nerdfonts icons
* more [wallpapers](https://wallhaven.cc/)
* adjust spacedust2 magenta to be more magenta
* nvim colorscheme
    * lush.nvim interactive colorscheme
    * mini.colors 
    * mini.hues (:colorscheme randomhue)
    * mini.base16
    * nvim use [colorscheme template](https://github.com/datsfilipe/nvim-colorscheme-template)
    * [original spacedust](https://github.com/hallski/spacedust-theme)
    * remember colorscheme in mini.sessions?
* template fonts
    * firefox,waybar,mako,kitty
    * fira -> noto+emoji

* any way to convert plymouth theme to hyplock themes automatically?
    * basically a visually seamless transition from plymouth to hyprlock
    * convert plymouth code into password prompt

* add mpc current back to hyprlock, now that commands work when locked
* catpuccin?

* pokemon sprites `kitten icat --align=left (ls ruby-sapphire/ | where type == file | shuffle | first | get name)`
    * would be cool to have animated sprites (b/w 2) but limit it to the <= gen 3
    * [source](https://veekun.com/dex/downloads)
    * https://pokemondb.net/sprites
    * "https://img.pokemondb.net/sprites/black-white/anim/normal/swampert.gif"
    * "https://img.pokemondb.net/sprites/black-white/anim/back-shiny/swampert.gif"
    * [terminal themes](https://github.com/LazoCoder/Pokemon-Terminal)
    * keep compressed in git? should probably do the same for black_hud

# TODO: Maybe in the Future
* try not to need aur packages for the base system.
* homelab.md?
* is tab-less working? re-evaluate wink
* integrate gg with nvim sessions?
* increase hypridle times?
* control mpd with playerctl [mpDris2](https://github.com/eonpatapon/mpDris2)
* database vim tpope/dadbod-vim
* zoxide?
* separate bootstrap script for server?
* nushell task runner? [nur](https://github.com/nur-taskrunner/nur)
* ctl - new tui script to join a bunch of others
    * a chance to learn rust? tui, ratatui or iocraft crate
    * manage all system config
    * top/htop - task management
    * wpctl - audio
    * mpc/playerctl - music
    * iwctl - wifi [impala](https://github.com/pythops/impala)
    * bluetoothctl - bluetooth  bluetui
    * brightnessctl - screen brightness
    * wdisplays - multiscreen ?? not a TUI
    * systemd - https://github.com/rgwood/systemctl-tui
    * bootctl - 
* steam https://github.com/ValveSoftware/gamescope
* nushell [carapace completer](https://github.com/carapace-sh/carapace)
* nushell include path?
* background tasts
    * [pueue](https://www.nushell.sh/book/background_task.html)
    * systemctl units
    * hyprctl dispatch exec
* set XDG_OPEN applications
    * [nushell start](https://www.nushell.sh/commands/docs/start.html)
* separate iso configs for server and desktop?
* separate dotfiles for windows?
* nushell task runner? [nur](https://github.com/nur-taskrunner/nur)
* [mosh](https://mosh.org/) or [eternal terminal](https://eternalterminal.dev/)
    * [xxh](https://github.com/xxh/xxh)
* [notcurses](https://github.com/dankamongmen/notcurses) [site](https://notcurses.com/)
* play with firefox bookmarks (places.sqlite)
    * [nushell start](https://www.nushell.sh/commands/docs/start.html)
* template gtk themes?
* ls color generator [vivid](https://github.com/sharkdp/vivid)
* generate colorschemes from images
    * archived:[pywal](https://github.com/dylanaraps/pywal)
    * [pywal16](https://github.com/eylles/pywal16)
* hyprshade - screen shader frontend
* window titles
    * waybar - show active window title
    * nvim set title to buffer name

* steam wayland fixes https://github.com/ValveSoftware/gamescope
* [access clipboard from nushell/reedline](https://github.com/nushell/reedline/issues/745)
* imbue rollback - keep backups of the original and previous versions of things for a clean uninstall

* telescope
    * telescope preview images with kitty icat
    * ripgrep + telescope?

# research: what are these? Do these things exist
* https://nixos.org/
* podman vs docker
* https://terminaltrove.com/list/
