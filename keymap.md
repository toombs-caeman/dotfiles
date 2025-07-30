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

* [screen](https://kapeli.com/cheat_sheets/screen.docset/Contents/Resources/Documents/index)
* organize master list by ... (functional group, key, modifiers, application)?
* match firefox keybinds for tabs
* tabs with `HL`, buffers with `JK` while splits with `a-hjkl`
* telescope `a-`
    * f - find in file (current_buffer_fuzzy_find)
    * d - find in directory (live_grep)
    * e - find_files
    * E - oldfiles
    * `<leader>`- buffers
    * ' - marks
    * more?
* tabs, buffers, splits
    * `a-[1-9]` - goto tab # 
    * `JK` - tabp tabn (shadows `J` which is used sometimes)
    * `HL` - bufp and bufn
    * `a-[hjkl]` move to split
    * `a-t` - tabnew
    * `a-x` - close tab
    * `a-v` - vertical split
    * `a-V` - horizontal split
* lsp actions
    * complete `tab` `<CR>`
    * `a-s` - find symbols (lsp_document_symbols, lsp_workplace_symbols)
    * code actions
    * goto definition/implementation/usages
    * snippets


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
* kitty keys
    * scroll to prompt `c-{z,x}` -> `c-{j,k}`
    * page last output? map kitty_mod+g `show_last_command_output`
# firefox
* `/` - find text
* `''` - find link text
* `a-d` - goto search bar
* `W` - open tab in new window (replace with `a-v` and `a-s`?)
* `c-t` - open a new tab focused on search bar (replace wtih `a-t`, or add `c-t` to vim as tab+telescope)

# to unlearn
* `a-w` - close tab, (replace with vimium `x` or vim `:x`)
* `:wq` - close window (replace with `:x`)

# vim
* lsp
* keybinds for neogit and gitsigns
    * gitsigns toggle_current_line_blame
    * gitsigns blame
    * gitsigns preview_hunk_inline
    * neogit `a-g`
    * diff view?
    * telescope git_branches
    * nushell completer
    * [neogit](https://github.com/NeogitOrg/neogit)
    * avante? windsurf?

# reference
* [firefox](https://support.mozilla.org/en-US/kb/keyboard-shortcuts-perform-firefox-tasks-quickly)
* [hyprland](https://wiki.hyprland.org/Configuring/Binds/#bind-flags)
* [kitty](https://sw.kovidgoyal.net/kitty/conf/#keyboard-shortcuts)
* [nushell](https://www.nushell.sh/commands/docs/keybindings.html)
    * `help keybindings`
