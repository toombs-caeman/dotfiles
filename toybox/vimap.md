# visualize keymaps

draw an keyboard and highlight keys that are mapped to a function.
capture key presses

interactively visualize vim keymaps on an ascii
* visualize vim keymaps by mode+leader+modifier
    * use xdotool to send keys so we can capture the key modifiers

# names
each key needs 3 names: layout, xdotool, and vim.
# key codes
can probably use xdotool to configure what characters get generated by what keys
```
term_window="$(xdotool getwindowfocus)"
for k in ${x_keynames[@]}";do
    xdotool --window $term_window "$k"
    xdotool --window $term_window Return
done &
for k in ${x_keynames[@]}";do
    read line
    keymap[$k]="$line"
done
```
then we just need to map xdotool keynames to vim keynames

if a keyboard has ~100 keys, and each one needs to be pressed 2^4 times for modifiers (Ctrl, Alt, Shift, Meta)
whitefox has 68 keys, 10 numbers 26 letters, 3 repeated keys (shift, fn, alt), 8 mod keys
21 keys need to be tested with xdotool.
# keybindings
* `vim -e +"redir>>/dev/stdout | map | redir END" -scq`
* may need `map` and `map!` ?
* XXX -v: support different vim implementations (nvim vim vi)
* use `:help index` to get default keys


# draw keyboard
* [ascii art](https://www.asciiart.eu/computers/keyboards)
* XXX -k: support alternative key layouts like

3. draw keyboard

# capture key inputs
* the tricky part will be to detect modifier keys (Meta, Alt, Ctrl) w/o keypresses
    * `xdotool key x` (without --clearmodifiers) periodically to capture modifiers
* pipe through `vim -s` while combining with <C-V> to get vi-styled control sequence
    * `set noexpandtab`
    * https://vim.fandom.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_2)#Key_notation
    * for example right arrow shows as <Right>
    * Enter might show up as ^M or <CR> or something else

5. filter key bindings with the current sequence
    * highlight keys that have bindings if the sequence is continued
    * if the sequence is complete, show the help for the resulting command
        * `:help gi` for builtin commands
        * `:verbose :command GitFiles` for user- or plugin-defined commands

# XXX integrations
* directly open `:help` page?