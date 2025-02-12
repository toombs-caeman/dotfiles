# TODO

* decide on fonts, font stack
    * jetbrains mono - default for wezterm?
    * twemoji - not covered by nerd fonts??
    * fira code nerd font mono - what about hack
    * serifs font - for firefox mostly
* start over on the dotfiles using new tools and config from scratch
    * copy configs from old dotfiles
* actual config/templating tool to replace ricer - stash
    * needs moustache tool
* fzf vs telescope
* rewrite launch for nushell+wezterm
* switch to swaybar
    * i3status was the old one
    * swaybar comes native
    * [waybar](https://github.com/Alexays/Waybar/)
    * match with vim status line?
* lush.nvim for colorscheme
    * remake spacedust2 for 24 bit color
    * maybe extract current vim colorscheme (using lush?) to generate renderable palettes?
    * maybe use [colorscheme template](https://github.com/datsfilipe/nvim-colorscheme-template)
    * [original spacedust](https://github.com/hallski/spacedust-theme)
* better install script
    * https://raw.githubusercontent.com/toombs-caeman/.nu/refs/heads/master/install.sh | sh
    * fully test requirements are available
    * assuming pacman is available
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
* ctl - new tui script
    * wpctl - audio
    * mpc - music
    * iwctl - wifi
    * bluetoothctl - bluetooth
    * brightnessctl - screen brightness
    * arandr - multiscreen
        * arandr-like TUI?

* steam https://github.com/ValveSoftware/gamescope
* firefox `pacman -S firefox-ublock-origin`
    * firefox jumpkey plugin??

* nvim merge kickstart.vim and old init.vim
* curate vim plugins
    * manager [lazy.nvim](https://github.com/folke/lazy.nvim)
    * [neovim-lspconfig](https://github.com/neovim/nvim-lspconfig)
    * [mason](https://github.com/williamboman/mason.nvim)
    * vim-surround
    * vim-targets
    * vim-gitgutter
    * [nvim-surround](https://github.com/kylechui/nvim-surround)
    * nerdtree? <A-d>
    * fzf-lua or telescope.vim
    * coc.nvim
    * something for git
    * nushell vi-mode use unamedplus buffer?
    * automate hooking the language server download if a language server isn't downloaded
* actually finish vim-in-term-in-vim config / winc
    * detect when vim is opening in vim-term and instead open a buffer
    * detect when in nvim, and nvim and don't open nested editors, split instead
    * detect nvim, disable vi-mode line editing, and goto terminal normal
* nvim correctly set title bars
* gg to nushell
    * zoxide vs gg
    * zoxide.vim
* do I even need fmt? probably not, use ansi
* curate nushell plugins
* remote edit/nav through ssh, netrw? fzf as if cwd was remote
* can we replace nu config Roaming with Local?
* match firefox keybinds for tabs
* nushell bind <A-e> to `fzf | nvim $in`
* shell history? atuin? need to configure it
    * [atuin](https://atuin.sh/) magic search history
* nushell [carapace completer](https://github.com/carapace-sh/carapace)
* yt-dlp with --embed-metadata to write mp3 tags? using picard? [ytmdl](https://aur.archlinux.org/packages/ytmdl)
* nushell
    * prompt
    * nushell [background tasks with pueue](https://www.nushell.sh/book/background_task.html)
    * how to set applications for `start`?
* DOTROOT
* separate windows from nix/arch config into separate file?
* ripgrep
* telescope with imgcat
* notify nushell wrapper
* update launcher, run in telescope? have metadata for whether or not to run in terminal, or launch through sway

* iso
    * detect manually installed packages and update archinstall.json

# TODO: Maybe in the Future
* separate configs for server and desktop?
* nushell task runner? [nur](https://github.com/nur-taskrunner/nur)
* [mosh](https://mosh.org/) or [eternal terminal](https://eternalterminal.dev/)
    * [xxh](https://github.com/xxh/xxh)
* [notcurses](https://github.com/dankamongmen/notcurses) [site](https://notcurses.com/)
* play with firefox bookmarks (places.sqlite)
    * [nushell start](https://www.nushell.sh/commands/docs/start.html)
* hyprland - very nice FX tiling window manager

# fonts
* twemoji
* fira code nerd font mono
* serifs font?

* start over on the dotfiles using new tools and config from scratch
    * copy configs from old dotfiles
* actual config/templating tool to replace ricer - stash
    * needs moustache tool
* fzf vs telescope
* rewrite launch for nushell+wezterm
* switch to swaybar
    * i3status was the old one
    * swaybar comes native
    * [waybar](https://github.com/Alexays/Waybar/)
    * match with vim status line?
* lush.nvim for colorscheme
    * remake spacedust2 for 24 bit color
    * maybe extract current vim colorscheme (using lush?) to generate renderable palettes?
    * maybe use [colorscheme template](https://github.com/datsfilipe/nvim-colorscheme-template)
    * [original spacedust](https://github.com/hallski/spacedust-theme)
* better install script
    * https://raw.githubusercontent.com/toombs-caeman/.nu/refs/heads/master/install.sh | sh
    * fully test requirements are available
    * assuming pacman is available
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
* ctl - new tui script
    * wpctl - audio
    * mpc - music
    * iwctl - wifi
    * bluetoothctl - bluetooth
    * brightnessctl - screen brightness
    * arandr - multiscreen

* steam https://github.com/ValveSoftware/gamescope
* firefox `pacman -S firefox-ublock-origin`
    * firefox jumpkey plugin??

* nvim merge kickstart.vim and old init.vim
* curate vim plugins
    * manager [lazy.nvim](https://github.com/folke/lazy.nvim)
    * [neovim-lspconfig](https://github.com/neovim/nvim-lspconfig)
    * [mason](https://github.com/williamboman/mason.nvim)
    * vim-surround
    * vim-targets
    * vim-gitgutter
    * [nvim-surround](https://github.com/kylechui/nvim-surround)
    * nerdtree? <A-d>
    * fzf-lua or telescope.vim
    * coc.nvim
    * something for git
    * nushell vi-mode use unamedplus buffer?
    * automate hooking the language server download if a language server isn't downloaded
* actually finish vim-in-term-in-vim config / winc
    * detect when vim is opening in vim-term and instead open a buffer
    * detect when in nvim, and nvim and don't open nested editors, split instead
    * detect nvim, disable vi-mode line editing, and goto terminal normal
* nvim correctly set title bars
* gg to nushell
    * zoxide vs gg
    * zoxide.vim
* do I even need fmt? probably not, use ansi
* curate nushell plugins
* remote edit/nav through ssh, netrw? fzf as if cwd was remote
* can we replace nu config Roaming with Local?
* match firefox keybinds for tabs
* nushell bind <A-e> to `fzf | nvim $in`
* shell history? atuin? need to configure it
    * [atuin](https://atuin.sh/) magic search history
* nushell [carapace completer](https://github.com/carapace-sh/carapace)
* yt-dlp with --embed-metadata to write mp3 tags? using picard? [ytmdl](https://aur.archlinux.org/packages/ytmdl)
* nushell
    * prompt
    * nushell [background tasks with pueue](https://www.nushell.sh/book/background_task.html)
    * how to set applications for `start`?
* DOTROOT
* separate windows from nix/arch config into separate file?
* ripgrep
* telescope with imgcat
* notify command
* locker


# TODO: Maybe in the Future
* separate configs for server and desktop?
* nushell task runner? [nur](https://github.com/nur-taskrunner/nur)
* [mosh](https://mosh.org/) or [eternal terminal](https://eternalterminal.dev/)
    * [xxh](https://github.com/xxh/xxh)
* [notcurses](https://github.com/dankamongmen/notcurses) [site](https://notcurses.com/)
* play with firefox bookmarks (places.sqlite)
    * [nushell start](https://www.nushell.sh/commands/docs/start.html)
* hyprland - very nice FX tiling window manager
* set gtk themes?


# research: what are these? Do these things exist
* https://nixos.org/
* better launcher programs?
