
The idea is to have the equivalent operations for interacting with splits/tiles share keymaps between nvim and i3.
The keys Meta+[hjkl] move to different i3 windows unless nvim is focused, and there is another split available in that direction, in which case the cursor moves to that nvim split instead.

This is probably a terrible idea, but I think bi-directional compatibility between nvim and i3 is kinda neat.
It effectively inverts the (user perceived) relationship between editor and desktop environment, where non-nvim windows behave as splits within nvim by creating a dummy split in nvim, and then floating the external application over the dummy split.

i3 as nvim? can we use i3 to do splits and tabs (to a single nvim server in the background)
  which would let us have a 'split' for external programs? like a virtual i3:// handler
  wi³nk - winc[md] and i3
  use selenium / firefox --marionette for allowing vim-style motions and text input
  see: https://github.com/fu5ha/i3-vim-nav
  see: https://github.com/mhinz/neovim-remote
  see: `i3-msg -t get_tree` with :help json_encode()
  xdg-open urls etc.

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
