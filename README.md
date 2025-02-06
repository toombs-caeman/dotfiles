# dotnu

* [keep dotfiles in sync with git](https://github.com/dotphiles/dotsync)

# mustache + nushell = nustache
an implementation of [mustache](https://mustache.github.io/mustache.5.html) in [nushell](https://www.nushell.sh/)
* [testing nushell](https://www.nushell.sh/book/testing.html)

# stache
a sane, cross-platform dotfile configuration manager written in nushell.

each template (in this case "nvim:init.lua") runs if nvim is in path and init.lua is in the templates directory
can always specify a single name or different for each os

```.stash.lock
nvim:
    init.lua: <md5 hash>
    colo.vim: <md5 hash>
```

# ref
* https://www.nushell.sh/book/scripts.html
* contribute back to [dotfiles](https://dotfiles.github.io/)
