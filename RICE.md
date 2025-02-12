This file discusses the aspirational ideal of a desktop.
[wink](wink.md) discusses a potential implementation.

If I'm going to go through the effort to make a nice setup. I'd like to have an idea of where I'm headed.

# The Wink Desktop
The unifying idea of wink is to unify. Why use two eyes when one is good enough?

# problem - solution
Certain features or motifs are often shared between applications, but with subtle differences between their implementation.

This causes:
* burden of learning - the user must learn multiple keybinds for the same action, depending on context. The learning curve can be inhospitable. this harms discoverability
* burden of configuration - how many times do you want to configure a different application, in their own special configuration language, what you mean by <Alt-w>
* incorrect input - if you can never convince your fingers what the correct keystroke is, they'll get it wrong half the time.
* loss of speed - uncertainty means the user must consider what they do more, or use undo a lot
* poor composiblity - if you have the best shell history tool ever, why settle for the default browser history?

I propose identifying and unifying these motifs in order to create a fully composable desktop environment.

# motifs
## windows / splits / panes / tiles
a region of the screen occupied by a single thing. These may be 'windows' as recognized by a window manager, or they may be regions within a single application which display distinct things.
## tabs / groups / vim-buffers / workspaces
some grouping of items which occupy the same screen space, with only one item being visible (on top) at a time.
This is distinct from a history in that all items in the group are somehow open or active concurrently.
## history / bookmarks / undo-redo
a bookmark is a convenient way to revisit some past state. History generally exists in the service of returning-to or repeating what happened before. Items in the history aren't 'active' until selected.
## configuration / persistent state
configuration is usually a declarative state that an application returns to on load, but some programs persist their state between runs.
## data transfer / storage
the unix pipe, the clipboard, the filesystem, message buses.
Data storage is just data transfer to the future.
Let me know before you figure out how to transfer data to the past.
## status displays
Show information about something else.
usually status bars. vim has one, WMs usually have one. They could have other shapes.
## notifications
something happened
## decoration / styling
anything you can do with css
## search / suggest-select / exploration / autocomplete
trying to discover what options exists.
fuzzy, incremental, with advanced filtering of all kinds
* cd + ls is usually a kind of manual search of a filesystem
* autocomplete - a combo suggest and select mechanism
* editor suggestions - offer ideas/actions that you weren't looking for
* help text
## remote shells / desktops
it's a consistent problem, trying to get consistent interactions across the network.
Ideally it would be totally transparent where the compute happens


# declarative vs imperative / idempotence
histories in particular are split, can you declaratively return to a given state?
Or is it a history of actions which can only be repeated in the current context.

# GUI vs TUI vs CLI
GUIs are good for tools that you don't use very often and/or which have way to many configuration options.
They are the king of discoverability.

TUIs / CLIs are good for tools you use all the time, especially if they are relatively simple. They are **fast** when you know what you're doing, but can be difficult to learn.
GUIs can be made nearly as fast as a TUI through thoughtful design and good (or customizable) keybindings, but this is rare.
CLIs tend to be more or less composable for scripting.

The ideal I think is to design your applications as an API (even for local use), backend or library, with a GUI and cli frontend.
There should be better tools for doing this.

# ssh scry
* mount the remote file system (sshfs), sandbox local $env and dynamically alias a 'remote-do' command that *actually* runs a command on the remote, using the local env, connecting the tty, etc.
* the idea is that you can explore a remote and run commands there, but still using all your local shell config
* I haven't really thought this through

# aesthetics
what even is a good looking desktop?
* recreate spacedust2 color palette
* status bar should be retro-futuristic themed? can we do TRON?
* fonts

# parts of a desktop env (typically)
* bootsplash
* login greeter
* window management
    * launch / close
    * rearrange / resize / group
* system status indicators (bar)
* notifications viewer
* snip tools
    * copy-paste
    * screenshot (color picker)
    * audio recorder
* I/O control
    * wifi
    * bluetooth
    * audio
    * brightness
    * arandr multi-monitor setup
    * exit / power down
    * screen locker
    * screen idle locker
* applications
    * web browser
    * file browser
    * games
    * terminal

behind the scenes, not really part of the desktop
* tty
* services
    * sshd
    * docker

