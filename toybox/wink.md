bi-directional compatibility between nvim and i3

* have a single headless nvim server and connect with nvr
* Have a single nvr open in tiling mode in each i:workspace.
* :au TabEnter switch i:workspace
* name i:workspaces after v:tabs
* Open external programs in a :split :term and float i:windows
  spawned by that proceess id over v:window
* :au TermEnter if the process owns a i:window give it i:focus
* i:map <ESC><ESC> give nvim i:focus and send <C-\><C-n>
hook

use `i3-msg -t get_tree` as the source of truth, since this is ultimately what's visible.
use i3status bar as tab bar on top. for native tray icons.
use a terminal for commandline on bottom.
i3 - vim
* workspace - tab
* window    - window
* app?      - buffer
* scratch   - non-visible buffer
# installation
```i3config
exec nvim --headless --listen /tmp/wink-server +"WinkInit()"
include ~/.config/i3/wink
```

# i3 config
* server should write a config file to be included in i3config
    * [include directive](https://i3wm.org/docs/userguide.html#include)

# autocmd
autocmd all buffenter, winenter, etc to move 
use nvim terminal titles to communicate mode
use Wink() and autocmd to sync `i3-msg -t get_tree`
# Wink()
if i3 isn't running, just use normal :winc
otherwise, translate all :winc, tab and split commands to i3
there should only ever be one vim:window to each i3:window

# plugins
use a nvim launcher script which can 

# reference
* :help ui
* [i3config](https://i3wm.org/docs/userguide.html)
* [nvim.desktop](https://github.com/fmoralesc/neovim-gnome-terminal-wrapper)
* [nvr](https://github.com/mhinz/neovim-remote)
