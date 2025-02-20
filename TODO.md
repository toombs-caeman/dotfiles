# TODO
* push to dotfiles
* iso
    * rewrite makefile as nushell
    * test install env
    * post install instructions (firefox setup)
    * add impala to install env, run it iff not connected to wifi
    * iso as `imbue iso`, usb as `imbue wand (image='') (disk='')`
        * build
    * boot section
    * copy the host wifi (iwd) configuration to the install env
    * copy the host public key to install env to enable install over ssh

* install on work laptop
    * either pull out harddrive, or copy out credentials first
        * ssh keys, github key
    * make sure hardware key works with it.
    * ensure ssh works as expected
    * truenas
    * wifi
    * secureboot?
    * do I have a usbc boot device?

* keybinds section
* kitty enable advanced key handling
    * correct <C-c> vs <C-C>

* nushell section
* tabless
* more [wallpapers](https://wallhaven.cc/)
* ssh section
    * nushell ssh completions
* theming section
* launch.lua
    * pull options from config file
        * columns: display, cmd, last run timestamp
    * CRUD on config file?
    * package as neovim plugin?

* finalize readme
* consolidate theory.md, rice.md, wink.md
* handle laptop lid? need to set lock grace to 0 for it to work?

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

# boot sequence
ditch ly and just `while true; do hyprland done` on tty1
* kernel params (quiet splash)
* plymouth with the splash animation
* immediately open hyprland and lock it
* match plymouth visuals to hyprlock
    * start hyprlock as a white dot on a black screen
    * `magick -dispose previous -delay 2 ...(glob *.png | sort -n) ~/animated.gif`


# ssh
* remote edit/nav through ssh, netrw? fzf as if cwd was remote, oil.nvim
* don't nest nvim term

# theming
* nvim-web-dev-icons vs mini.icons
* nvim use [colorscheme template](https://github.com/datsfilipe/nvim-colorscheme-template)
    * [original spacedust](https://github.com/hallski/spacedust-theme)
* firefox styles.css? [firefox userchrome](https://trickypr.github.io/FirefoxCSS-Store.github.io/)
* template fonts
    * firefox,waybar,mako,kitty
    * "Fira",monospace,11

* any way to convert plymouth theme to hyplock themes automatically?
    * basically a visually seamless transition from plymouth to hyprlock
    * convert plymouth code into password prompt


# keybinds
* master keybind list?
* hyprland keybinds
    * exit, reboot menu ??[wlogout](https://github.com/ArtsyMacaw/wlogout)
    * hyprland match firefox keybinds for tabs
    * mute, mpd control
    * groups
    * rebind toggle split
    * move active window (mouse might be ok, but trackpad aint it)
* vim keybinds
    * from old init.vim
    * nvim-tree, oil.nvim
    * telescope
    * <A-q> show documentation

# TODO: Maybe in the Future
* increase hypridle times?
* control mpd with playerctl [mpDris2](https://github.com/eonpatapon/mpDris2)
* database vim tpope/dadbod-vim
* ripgrep + telescope?
* zoxide?
* update music downloader
    * yt-dlp with --embed-metadata to write mp3 tags? using picard?
    * broken: [ytmdl](https://aur.archlinux.org/packages/ytmdl)
* separate configs for server and desktop?
* nushell task runner? [nur](https://github.com/nur-taskrunner/nur)
* ctl - new tui script to join a bunch of others
    * wpctl - audio
    * mpc/playerctl - music
    * iwctl - wifi [impala](https://github.com/pythops/impala)
    * bluetoothctl - bluetooth  bluetui
    * brightnessctl - screen brightness
    * wdisplays - multiscreen ?? not a TUI
    * systemd - https://github.com/rgwood/systemctl-tui
* steam https://github.com/ValveSoftware/gamescope
* nushell [carapace completer](https://github.com/carapace-sh/carapace)
* nushell include path?
* match firefox keybinds for tabs
* telescope preview images with kitty icat
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
* hyprcursor

# research: what are these? Do these things exist
* https://nixos.org/
* podman vs docker
* https://terminaltrove.com/list/
