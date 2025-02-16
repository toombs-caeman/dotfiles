# TODO
* load theme from `themes/`
    * give actual names to colors
* rewrite launch for nushell
    * `hyprctl dispatch exec kitty nvim +"lua require(\"telescope.builtin\").asfd()"`
    * nushell:ctl[] - how to integrate with launch
    * separate name from command
* hyprland keybinds
    * exit, reboot menu
    * hyprland match firefox keybinds for tabs
* hypridle
    * screen off 5min
    * lock 10min
* handle laptop lid?
* hyprpaper
    * disable hyprland splash and anime girl
* hyprlock
* waybar
    * sections ok
    * needs visuals: mostly transparent, with pills and tooltips for info, move to bottom
    * match with vim status line?
* fonts - fira code nerd font mono + twemoji
    * in kitty, waybar, firefox, mako
* kitty enable advanced key handling

* iso
    * rewrite makefile as nushell
    * test install env
    * post install instructions (firefox setup)

* shell history? [atuin](https://atuin.sh/)
* nushell [carapace completer](https://github.com/carapace-sh/carapace)

* vim keybinds
    * from old init.vim
    * nvim-tree
    * telescope
    * lsp
* vim config mini
* remote edit/nav through ssh, netrw? fzf as if cwd was remote
* don't nest nvim term

* lush.nvim for colorscheme
    * remake spacedust2 for 24 bit color
    * maybe extract current vim colorscheme (using lush?) to generate renderable palettes?
    * maybe use [colorscheme template](https://github.com/datsfilipe/nvim-colorscheme-template)
    * [original spacedust](https://github.com/hallski/spacedust-theme)

* finalize readme
* consolidate theory.md, rice.md, wink.md

# TODO: Maybe in the Future
* ripgrep + telescope?
* zoxide?
* yt-dlp with --embed-metadata to write mp3 tags? using picard? [ytmdl](https://aur.archlinux.org/packages/ytmdl)
* separate configs for server and desktop?
* nushell task runner? [nur](https://github.com/nur-taskrunner/nur)
* ctl - new tui script
    * wpctl - audio
    * mpc - music
    * iwctl - wifi
    * bluetoothctl - bluetooth
    * brightnessctl - screen brightness
    * arandr - multiscreen
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
* generate colorschemes from images [pywal](https://github.com/dylanaraps/pywal)
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
* steam https://github.com/ValveSoftware/gamescope
* [access clipboard from nushell/reedline](https://github.com/nushell/reedline/issues/745)

# research: what are these? Do these things exist
* https://nixos.org/
* better launcher programs?
