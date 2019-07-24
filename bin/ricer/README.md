`ricer` templates your config files with a color palette generated from your background.

It uses [jinja2](http://jinja.pocoo.org/docs/2.10/) to render templates while injecting the variables specified [below](#variables). The color palettes are 16 colors generated using the method described in this [blog post](http://charlesleifer.com/blog/suffering-for-fashion-a-glimpse-into-my-linux-theming-toolchain/).

This project is very much a work in progress and is liable to change. Be careful and take backups.

# Usage
To really use this project you will need to write your own templates and configuration file. There is an example config file [below](#configuration) and there are example templates [here](https://github.com/toombs-caeman/dotfiles/tree/master/templates)
``` bash
# render the configured templates,
# pick a random image and create a palette from that image
ricer path/to/config.yml

# render the configured templates,
# but use the specified image
ricer path/to/config.yml -f path/to/background.png

# render the configured templates,
# and pick a random image, but use the default color palette (solarized dark)
ricer path/to/config.yml --default

# render the configured templates,
# use the specified image and the default palette
ricer path/to/config.yml -f path/to/background.png --default

```

# Installation
Haven't really worked up to making this a real python package yet. For now just put the `ricer` file on your path and make it executable.

requires:
* python3
* PIL
* heapq

``` bash
curl https://github.com/toombs-caeman/ricer/blob/master/ricer > /usr/bin/ricer
chmod +x /usr/bin/ricer
```

# Example
TODO

render an Xresources file with
``` bash
./ricer example_config.yml
```
This will create a file called `Xresources.render` in your home folder using a random image from `~/Pictures` and load those resources with the callback.

OR you can render and load the [solarized dark](https://ethanschoonover.com/solarized/) theme with 
``` bash
./ricer example_config.yml --default
```
# Configuration
``` yaml
# a folder containing pictures to cycle through
background_dir: ~/Pictures/Backgrounds 
# a folder containing templates
template_dir: ~/.ricer/templates

templates:
  # each field is the name of a template in template_dir
  alacritty.yml: 
    # dest marks the destination for the rendered template
    dest: ~/.config/alacritty.yml
    # link will create a symlink from dest to the given path.
    link: ~/.alacritty/alacritty.yml
  i3config.sh: 
    dest: ~/.config/i3config.sh
    link: ~/.i3/config
    # callback will be run after successfully rendering the template
    callback: i3-msg restart
  # you can also just specify the destination if you don't need anything else
  theme.vim: ~/.vim/colors/theme.vim
```

# Variables
each of these variables is made available within the templates
* color: a list of 16 colors in the format `RRGGBB`, they are ordered according to the 'canonical' ordering of terminal colors
* background: an absolute path to the image used
* msg: a message that warns not to edit the rendered file and links to the template.

# TODO
* ensure that normal and light colors are different
    - use ensure


probably want to separate this into a few stages.
* determine background image and palette
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
