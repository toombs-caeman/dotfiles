# TODO

* install on work laptop
    * setup ssh / scp
    * truenas
    * wifi

* ssh
    * ssh+oil.nvim?
    * nushell ssh completions

* multihead neovim
    * unmaintained [nwin](https://github.com/glacambre/nwin?tab=readme-ov-file)

    * not quite it [nvr](https://github.com/mhinz/neovim-remote)
    * ext multigrid??
    * ext windows??
    * https://github.com/topics/neovim-guis


* [master keymap](keymap.md)

* dockertest
    * docker init
    * from php5.6-apache
    * extensions pdo_mysql mysql mysqli
    * s,/www/*/html/,,g
    * s,https://www.*.com,,g  - no trailing slash
    * in docker compose
        * mount /src over /var/www/whatever
        * mount php-develop.ini

* set noexpandtab for tsv
* nushell section
* theming section

* launch.lua
    * pull options from config file
        * columns: display, cmd
        * sort by MRU
    * CRUD on config file?
    * package as neovim plugin?
    * can we hook `vim.ui.input` with nui like telescope does for `select`
* don't nest nvim term - use `neovim --server $env.NVIM --remote $file` to send to the parent instance if NVIM in $env

* finalize readme
* consolidate theory.md, rice.md, wink.md
* handle laptop lid? need to set lock grace to 0 for it to work?

* bootstrap iso
    * test install env
    * there seem to be a number of permissions problems related to setting up a user correctly. (adding user to groups)
    * a better testing setup with qemu-full

# nushell section
* shell history? [atuin](https://atuin.sh/)
* nushell [carapace completer](https://github.com/carapace-sh/carapace)
* hook command-not-found
* explore nushell stdlib and nu_scripts
    * contribute hypr completions [custom-completions](https://github.com/nushell/nu_scripts/tree/main/custom-completions)
    * contribute to documentation
    * poor mans fzf: input list -f

# windows config
* ideavimrc
* limited imbue.yaml

# theming
* more [wallpapers](https://wallhaven.cc/)
* standardize nvim-web-dev-icons vs mini.icons vs nerdfonts icons
* adjust spacedust2 magenta to be more magenta
* nvim use [colorscheme template](https://github.com/datsfilipe/nvim-colorscheme-template)
    * [original spacedust](https://github.com/hallski/spacedust-theme)
    * plugin
* firefox styles.css? [firefox userchrome](https://trickypr.github.io/FirefoxCSS-Store.github.io/)
* template fonts
    * firefox,waybar,mako,kitty
    * "Fira",monospace,11

* any way to convert plymouth theme to hyplock themes automatically?
    * basically a visually seamless transition from plymouth to hyprlock
    * convert plymouth code into password prompt

* add mpc current back to hyprlock

* pokemon sprites `kitten icat --align=left (ls ruby-sapphire/ | where type == file | shuffle | first | get name)`
    * would be cool to have animated sprites (b/w 2) but limit it to the <= gen 3
    * [source](https://veekun.com/dex/downloads)
    * https://pokemondb.net/sprites
    * "https://img.pokemondb.net/sprites/black-white/anim/normal/swampert.gif"
    * "https://img.pokemondb.net/sprites/black-white/anim/back-shiny/swampert.gif"
    * [terminal themes](https://github.com/LazoCoder/Pokemon-Terminal)

# TODO: Maybe in the Future
* try not to need aur packages for the base system.
* homelab.md?
* is tab-less working? re-evaluate wink
* integrate gg with nvim sessions?
* increase hypridle times?
* control mpd with playerctl [mpDris2](https://github.com/eonpatapon/mpDris2)
* database vim tpope/dadbod-vim
* zoxide?
* bootstrap script for server?
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
* git
    * git-delta?
    * vim-git
    * interactive add, commit?
    * vim-gitgutter
    * vim-fugitive?
    * vimagit?
    * nushell plugin?
    * aliases
    * git config --global merge.conflictstyle diff3
    * always set upstream on push
    * forgit
* steam wayland fixes https://github.com/ValveSoftware/gamescope
* [access clipboard from nushell/reedline](https://github.com/nushell/reedline/issues/745)
* nvim lush.nvim for colorscheme
* imbue rollback - keep backups of the original and previous versions of things for a clean uninstall
* mini has a bunch of [modules](https://github.com/echasnovski/mini.nvim?tab=readme-ov-file#modules)

* telescope
    * remember 'telescope colorscheme' in mini.sessions?
    * telescope preview images with kitty icat
    * ripgrep + telescope?

# research: what are these? Do these things exist
* https://nixos.org/
* podman vs docker
* https://terminaltrove.com/list/
