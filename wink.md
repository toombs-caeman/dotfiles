[Rice](RICE.md) discusses what the ideal desktop is at a high level.
Here we discuss how it could be implemented.

# unify tabs panes buffers etc
* use neovim RPC to have a single server running

## disable tabs within applications
* nvim
    * change tab keymap to launch window within the same tab group and switch to it
    * change split keymaps to launch window outside group
    * use neovim RPC to make instances launched within the same workspace connect to the same remote
    * https://github.com/mhinz/neovim-remote
    * conditionally switch keymaps if not running under hyprland (on windows for instance)
* [tabless firefox](https://addons.mozilla.org/en-US/firefox/addon/tabless-fox/)
    * launch window instead of tab, hide tab bar
* vimium for firefox
* [tabless chrome](https://chromewebstore.google.com/detail/tab-less/mdndkociaebjkggmhnemegoegnbfbgoo?pli=1)
    * launch window instead of tab, hide tab bar

## use WM for managing tabs / panes / workplaces
this is what the WM is for, let it do the job.
* movement between panes / tabs
* resizing / regrouping
* save / restore layout by workplace, restarting tabs and neovim state

# visual display alignment
TUI to get screens mostly aligned (colors + glyph fullscreen in terminal)
control the displays relative position with the mouse or something.
point an arrow on each screen towards where it will meet up with the other (like -><-).
click to confirm, right-click to cancel
Do the same thing for screen size + fractional scaling? multiple arrows, scroll to resize.

# images
* view in terminal? icat/kitty
* view in firefox?
* set as wallpaper
* edit in krita

# undo /redo
this is sort of related to history in general, but is more specific
* nvim undo is pretty good
* git undo is less good
* browsers have several disjoint 
    * tab level go back a page
    * unified page history
    * reopen closed tab
    * reopen closed window

# bookmarks / history
you were in a place (probably doing a thing) and you want to go there again
* gg is sort of a way to manage project bookmarks
* firefox bookmarks
* workplace layout is kind of a bookmark
* launcher history is kind of a history
* shell history
* git commits and tags are history and bookmark

# clipboard
nvim should share the system clipboard.
the the clipboard can be enhanced to have a history

# notifications
lib-notify has got this pretty figured out

# workspaces
workspaces represent some shared context. That context should be saved in a history

workspaces can be assigned a context
* context name is probably an absolute path
* open terminals within the same directory?
* nvim cd to that directory
* save and restore layout per that context
* the context has a single shared nvim remote, even if multiple workspaces are accessing it

# colors
* firefox style.css
* nushell $env.colors
* LS_COLORS
* nvim colorscheme (lush.nvim)
* hyprland colors
* waybar css

# visual toys
* cbonsai
* cava
* not neofetch
* pipes.sh

# XDG_OPEN??
