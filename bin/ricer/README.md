automatically generate color themes from background images.
also allows jinja2 templating for config files and callbacks

# requires
* python3

# examples

# configuration
``` yaml
templates:
  i3config.sh: 
    dest: ~/.config/i3config.sh
    link: ~/.i3/config
    callback: i3-msg restart
  alacritty.yml: 
    dest: ~/.config/alacritty.yml
    link: ~/.alacritty/alacritty.yml
  theme.vim: 
    dest: ~/.vim/colors/theme.vim
```

# TODO
* template warning to include the template path
* tolerate failure in a template


probably want to separate this into a few stages.
* determine background image and palette
    * http://charlesleifer.com/blog/suffering-for-fashion-a-glimpse-into-my-linux-theming-toolchain/
    * http://blog.z3bra.org/2015/06/vomiting-colors.html
* template config files with the palette
    - https://www.reddit.com/r/unixporn/comments/8giij5/guide_defining_program_colors_through_xresources/
* execute callbacks to update running programs
* default to solarized theme https://github.com/altercation/solarized

ideas:
* palette creation should fail if the input image isn't very color diverse
    - this should prevent any unreadable configs
* may want to steer around xresources considering wayland is a thing
* fonts