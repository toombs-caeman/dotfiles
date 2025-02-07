# dotnu

* [keep dotfiles in sync with git](https://github.com/dotphiles/dotsync)

* start over on the dotfiles using new tools and config from scratch
* actual config/templating tool to replace ricer
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

# TODO vim
* lua based config (merge lazyvim and old config)
* curate plugins
    * [neovim-lspconfig](https://github.com/neovim/nvim-lspconfig)
    * vim-surround
    * vim-targets
    * vim-gitgutter
    * fzf-lua
    * coc.nvim
* actually finish vim-in-term-in-vim config
* remote edit/nav through ssh, netrw? fzf as if cwd was remote
* how to re-indent last selection (when pasting lines)

# TODO nushell
* bind <A-e> to `fzf | nvim $in`
* autocd? ...
* shell history? atuin?
* [carapace completer](https://github.com/carapace-sh/carapace)

# new commands
* regen - combine a file watcher with reloading a process

# mustache + nushell = nustache
an implementation of [mustache](https://mustache.github.io/mustache.5.html) in [nushell](https://www.nushell.sh/)
* [testing nushell](https://www.nushell.sh/book/testing.html)

# stache
a sane, mustachioed, cross-platform dotfile configuration manager written in nushell.

each template (in this case "nvim:init.lua") runs if nvim is in path and init.lua is in the templates directory
can always specify a single name or different for each os

```.stash.lock
nvim:
    init.lua: <md5 hash>
    colo.vim: <md5 hash>
```

# ref
* [nu scripting](https://www.nushell.sh/book/scripts.html)
* contribute back to [dotfiles](https://dotfiles.github.io/)
