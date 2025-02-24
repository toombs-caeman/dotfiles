# Keyboard
My lightly modified whitefox keyboard.
```
,---,---,---,---,---,---,---,---,---,---,---,---,---,---,---,---,
|Esc| 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0 | - | = | ` | \ | * |
|---'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'---,---|
| ->| | Q | W | E | R | T | Y | U | I | O | P | [ | ] | <-  |Del|
|-----',--',--',--',--',--',--',--',--',--',--',--',--------,---|
| Func | A | S | D | F | G | H | J | K | L | ; | ' | Enter  |Pup|
|------'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'----,---,---|
| Shift  | Z | X | C | V | B | N | M | , | . | / | Shift| ^ |Pdn|
|------,--',--'--,'---'---'---'---'---'-,'--,'---,--,---,---,---|
| ctr  | # | alt |                      |alt|Func|  | < | v | > |
'------'---'-----'----------------------'---'----'  '---'---'---'
```
# TODO
* organize master list by ... (functional group, key, modifiers, application)?
* match firefox keybinds for tabs
* tabs with `HL`, buffers with `JK` while splits with `a-hjkl`

# Keymaps

I'm trying to work out a logical set of keymaps that spans a few apps I use all the time.
The goal is to have consistency keybindings for similar commands across apps.
This may require writing some scripts to bridge functionality.
* firefox+vimium - browsing
* neovim+plugins - as an IDE
* nushell - interactive shell
* hyprland - window management
* kitty - terminal
* mpd/mpc/playerctl - playing music library



* nushell keybind for mini.sessions `a-S`?
* hyprland keybinds
    * exit, reboot menu ??[wlogout](https://github.com/ArtsyMacaw/wlogout)
    * hyprland match firefox keybinds for tabs
    * mute, mpd control
    * groups
    * rebind toggle split
    * move active window (mouse might be ok, but trackpad aint it)
* vim keybinds
    * nvim-tree, oil.nvim
    * telescope
    * `a-q` show documentation
    * tmap p sendkeys from clipboard

`-` open directory
`a-w` go to definition

# kitty
* enable advanced key handling
* correct `c-c` vs `c-C` in kitty
# firefox
* `a-d` - goto search bar
* `W` - open tab in new window (replace with `a-v` and `a-s`?)
* `c-t` - open a new tab focused on search bar (replace wtih `a-t`, or add `c-t` to vim as tab+telescope)

# to unlearn
* `a-w` - close tab, (replace with vimium `x` or vim `:x`)
* `:wq` - close window (replace with `:x`)

# reference
* [firefox](https://support.mozilla.org/en-US/kb/keyboard-shortcuts-perform-firefox-tasks-quickly)
* [vimium](https://github.com/philc/vimium)
* [hyprland](https://wiki.hyprland.org/Configuring/Binds/#bind-flags)
* [kitty](https://sw.kovidgoyal.net/kitty/conf/#keyboard-shortcuts)
* [nushell](https://www.nushell.sh/commands/docs/keybindings.html)
    * `help keybindings`
