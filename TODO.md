# TODO

* dolphin as file manager?
* remove vim snippets, they are almost never what I want.
    * alternatively, change the keybind to accept a change
    * alternatively, replace with ollama complete

* aula, remap capslock to escape
* nushell completers https://www.nushell.sh/cookbook/external_completers.html
   * carapace?
* script completions

* nvim slop
    * [avante](https://github.com/yetone/avante.nvim)
    * ollama
    * [avante config](https://github.com/yetone/avante.nvim/pull/1543)

* [master keymap](keymap.md)
    * kitty keys
        * scroll to prompt `c-{z,x}` -> `c-{j,k}`
        * page last output? map kitty_mod+g `show_last_command_output`

* use nushell history to query exist_status, duration, hostname etc?
    * rather than keeping this dynamically (and probably badly) for the prompt.

* figure out how to import a script properly (nushell)
    * the problem is importing subcommands, since they are like `imbue main wall` instead of `imbue wall`
    * use `export alias sub = main sub` and don't export 'main sub'
* [nushell wrappers](https://github.com/drbrain/nushell-config/tree/main)
    * provides completions and command output as a table
    * ssh, git, docker, atuin, rg, rsync

* gdb + nvim-dap

* integrate fuzzel with next song picker? `ffprobe -loglevel error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 | fuzzel -d | ...`
    * is it better to have a dedicated thing for this? there are mpd TUIs

* correct `c-v` behavior
    * how to get nushell to use the system clipboard for pasting?

* keybinds for neogit and gitsigns
    * gitsigns toggle_current_line_blame
    * gitsigns blame
    * gitsigns preview_hunk_inline
    * neogit `a-g`
    * diff view?
    * telescope git_branches
    * nushell completer
    * [neogit](https://github.com/NeogitOrg/neogit)


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
* neogit highlight groups
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
* catpuccin theme?
* [carapace](https://carapace-sh.github.io/carapace-bin/style.html)

* pokemon sprites `kitten icat --align=left (ls ruby-sapphire/ | where type == file | shuffle | first | get name)`
    * would be cool to have animated sprites (b/w 2) but limit it to the <= gen 3
    * [source](https://veekun.com/dex/downloads)
    * https://pokemondb.net/sprites
    * "https://img.pokemondb.net/sprites/black-white/anim/normal/swampert.gif"
    * "https://img.pokemondb.net/sprites/black-white/anim/back-shiny/swampert.gif"
    * [terminal themes](https://github.com/LazoCoder/Pokemon-Terminal)
    * keep compressed in git? should probably do the same for black_hud

# TODO: Maybe in the Future
* https://github.com/AgregoreWeb/agregore-browser
* https://cabal.chat/
* try not to need aur packages for the base system.
* homelab.md?
* [defer in c](https://thephd.dev/c2y-the-defer-technical-specification-its-time-go-go-go)
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
    * nushell stor
* template gtk themes?
* ls color generator [vivid](https://github.com/sharkdp/vivid)
* generate colorschemes from images
    * archived:[pywal](https://github.com/dylanaraps/pywal)
    * [pywal16](https://github.com/eylles/pywal16)
* hyprshade - screen shader frontend
* window titles
    * waybar - show active window title
    * nvim set title to buffer name
* gh-dash github cli

* steam wayland fixes https://github.com/ValveSoftware/gamescope
* [access clipboard from nushell/reedline](https://github.com/nushell/reedline/issues/745)
* imbue rollback - keep backups of the original and previous versions of things for a clean uninstall

* telescope
    * telescope preview images with kitty icat
    * ripgrep + telescope?
* subcommand for interacting with github/gitlab/etc [git forge](https://github.com/nhorman/gitforge)
* charm based TUI (golang) [charm](https://charm.sh/)

* an electronic version of touchstone
    * config
        * sleep hours - delay notifications until wake time
        * leadtime options - 10 minutes, 1 day, 1 week, 1 month
        * in progress limits - limit in process category
        * report frequency
        * sync server + idp
    * todo items have a description, tags, and optionally a duedate + leadtime
    * send push notifications at duedate - leadtime
        * options: done, snooze, delete
        * snooze for half the remaining time to due (becomes faster as time draws near)
        * don't default to the middle of the night when only date is given, send notifications at 7am local.
    * recurring tasks
    * from kanban:
        * todo, in process, done
        * limit in process work
    * automatically 'in progress' tasks when leadtime reached
        * recommend to push back tasks when calendar fills up with events?
        * allow higher than 'in progress' limit for this.
    * generate regular reports about done work, send an email
    * the idea is to replace both a calendar and todo list with this task manager (where tasks are usually not strictly time bound)
    * ical interop?
    * this should subsume jist, since the inbox should be regularly revisited
    * build as a website? favicon becomes icon on home screen

* blog about treerat's computation graphs

# larger project ideas
* general abstraction for accessing data from an app?
    * the abstraction shouldn't care if the data is local, NAS, s3, etc.
    * primitives for local cache, remote sync, backups, backup retention, encryption.
    * ideally it appears as 'just a filesystem' to the application.
    * s3-fuse
    * enables 'local first' software that also offers data hosting / sync as a service, or self-hosting.
    * an 'infinite drive' where the 'true' data is on the cloud, but the local hard drive is an offline cache? Critical and recently used files will always be available on local storage, but with backups in the cloud when connected. Files swap transparently when local space fills up.

* logic gate toy in godot
    * emulate ideal behaviors of gates and things with node editor interface
    * inspired by coding adventures
    * save and paste schematics as (zoomable) black boxes

* can 'juice' from game design be applied to boring software like excel?

* sync ebooks and audiobooks?
    * can we connect the cybrarians audiobooks with the project gutenberg text of the same?
    * need to do some research to see if this has already been done.
    * use [ebup3 media overlays](https://www.w3.org/TR/epub-overview-33/#sec-mediaoverlays)
    * maybe use ai/tts to sync the audio track? not sure how this is done
    * [project gutenberg](https://www.gutenberg.org/) vs [standard ebooks](https://standardebooks.org/)

* the flip side of discovery (implied discovery of supply for products, restaurants, music) is detecting demand. How can we aggregate people's desires to find demand and then create the supply?

# explorations
quick explorations into libraries/technologies that seem interesting
* [htmx](https://github.com/toombs-caeman/htmx-test) - done
* LAMP stack - done
* game dev
    * godot
    * https://odyc.dev/
    * bevy
* [duckdb](https://duckdb.org/)

* [home lab](homelab.md)
# research: what are these? Do these things exist
* https://nixos.org/
* podman vs docker
* https://terminaltrove.com/list/

* [programmars ring](https://loup-vaillant.fr/articles/programming-ring) + [tromp diagram](https://tromp.github.io/cl/diagrams.html)

* [comments on self-hosted paas](https://news.ycombinator.com/item?id=43555996)
    * [dbohdan list](https://dbohdan.com/self-hosted-paas)
* proofs
    * Daniel Velleman’s “Proof Designer” [suggested problems](https://djvelleman.github.io/pd/help/Problems.html)
    * [deduce](https://jsiek.github.io/deduce/index.html)
* [compiler explorer godbolt](https://godbolt.org/)
* [BQN](https://mlochbaum.github.io/BQN/)
* lstopo (from hwloc) to visualize hardware caching

# slop
* stable diffusion - image generation [source](https://github.com/AUTOMATIC1111/stable-diffusion-webui)
