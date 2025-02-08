# dotnu

Portable dotfiles based on [nushell](https://www.nushell.sh/)

* $"(ansi title)set window title(ansi st)" in precmd

* [keep dotfiles in sync with git](https://github.com/dotphiles/dotsync)

* start over on the dotfiles using new tools and config from scratch
* actual config/templating tool to replace ricer - stache
* better install script
    * https://raw.githubusercontent.com/toombs-caeman/.nu/refs/heads/master/install.sh | sh
    * fully test requirements are available
    * assuming pacman is available
* git
    * git-delta?
    * vim-git
    * interactive add, commit?
* zoxide vs gg
    * zoxide.vim
* do I even need fmt?

# Terminals
kitty is not available for windows. exploring other options

requirements:
* [kitty keyboard protocol](https://sw.kovidgoyal.net/kitty/keyboard-protocol/)
* packages exists in (winget, pacman, brew)
* kitty or [iterm2](https://iterm2.com/documentation-images.html) image protocol or sixels
* correctly open links on click
* well behaved in sway, w/o a header
* consistent keybinds across platforms
* sane defaults
* good documentation
* tabs / pane keys align with wincmd
* sane scrollback
* gpu acceleration

# wezterm
* initial configuration

# TODO git
find satisfactory git plugins for:
* vim - interactive stage & commit
    * vim-gitgutter
    * vim-fugitive?
    * vimagit?

# TODO vim
* lua based config (merge kickstart and old config)
    * plug -> [lazy](http://www.lazyvim.org/)
* curate plugins
    * manager [lazy.nvim](https://github.com/folke/lazy.nvim)
    * [neovim-lspconfig](https://github.com/neovim/nvim-lspconfig)
    * [mason](https://github.com/williamboman/mason.nvim)
    * vim-surround
    * vim-targets
    * vim-gitgutter
    * fzf-lua
    * coc.nvim
    * something for git
    * automate hooking the language server download if a language server isn't downloaded
* actually finish vim-in-term-in-vim config / winc
* remote edit/nav through ssh, netrw? fzf as if cwd was remote
* how to re-indent last selection (when pasting lines)

# TODO nushell
* bind <A-e> to `fzf | nvim $in`
* shell history? atuin?
* [carapace completer](https://github.com/carapace-sh/carapace)
* prompt

# mustache + nushell = nustache
an implementation of [mustache](https://mustache.github.io/mustache.5.html) in [nushell](https://www.nushell.sh/)
* [testing nushell](https://www.nushell.sh/book/testing.html)

# stash
a sane, mustachioed, cross-platform dotfile configuration manager written in nushell.

each template (in this case "nvim:init.lua") runs if nvim is in path and init.lua is in the templates directory
can always specify a single name or different for each os

```.stash.lock
nvim:
    init.lua: <md5 hash>
    colo.vim: <md5 hash>
```

# TODO
* go through kickstart.lua
* go through rio.toml
* can we replace nu config Roaming with Local?
* match keybinds between firefox, rio, vim, nushell

* remake spacedust2 for 24 bit color and with a deeper understanding of dracula.vim
* recreate spacedust2 with [colorscheme template](https://github.com/datsfilipe/nvim-colorscheme-template)
    * [original spacedust](https://github.com/hallski/spacedust-theme)

# firefox

# ref
* [nu scripting](https://www.nushell.sh/book/scripts.html)

# publicity
* nustach
    * [awesome-nu](https://github.com/nushell/awesome-nu)
    * [{{moustache}}](https://mustache.github.io/)
    * add [tests badge](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/monitoring-workflows/adding-a-workflow-status-badge)
    * run tests against the spec with [nutest](https://github.com/vyadh/nutest)

* dotnu
    * [dotfiles](https://dotfiles.github.io/)
    * [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
    * [arch dotfiles](https://wiki.archlinux.org/title/Dotfiles)

* stash
    * [awesome-nu](https://github.com/nushell/awesome-nu)
    * [nupm](https://github.com/nushell/nupm)
