#!/usr/bin/env python3
import argparse
import yaml
import chevron
"""
this turns out to be a shitty version of [pywal](https://github.com/dylanaraps/pywal)
In fact, lets steal their data format so we can get a bunch of themes for free.

color themes
* use [dracula](https://github.com/dracula/firefox) as a source for ricer templates and a reference for how to create a [spec](https://spec.draculatheme.com)
* [selenized everywhere](https://github.com/jan-warchol/selenized)

scripts:
* convert pywal scheme to ricer theme
    * use dracula's 'special' colors and ansi layout
* grab dracula files to convert and convert dracula file to moustache template
    * [dracula spec](https://spec.draculatheme.com/)

subcommands
* name current scheme
* select random scheme
* add {{ricer_colors}} marker to existing config files
* generate scheme from wallpaper

parts:
* moustache data for converting colors between hex, rgb etc
* pywal color backends for generating new schemes
* inplace() moustache function that renders content
* comment styles for config file types (to hide injected marker)


folders:
.config/ricer/
    fragments/ - app specific color templates
    palettes/  - named color palettes
    ricer.yml
    
ricer.yml:
fragments: rel/path/
palettes: rel/path/
apps:
    app_frag: inplace/file/path
    app2:
        callback: 'shell commands' &>/dev/null
        frag1: path/
        frag2: path/
        
future:
* wallpaper handling 
* copy pywal color selection
"""

def get_fragment_for_file():
    pass
def ricer_colors(_, render):
    ctemplate = get_fragment_for_file()
    return

# subcommands
def download_dracula_theme(args):
    print('downloading', args)

def render(args):
    with open(tmplfile, 'r') as stream:
        r = yaml.safe_load(stream)
    print('rendering', args)

def render_file(filename, color_frag, palette):
    with open(color_frag, 'r') as fd:
        fragment = fd.read()
        data = {
            **palette,
            'ricer_colors': lambda _,render:'{{#ricer_colors}}%s{{/ricer_colors}}' % render(fragment.read())
        }
        with open(filename, 'rw') as file:
            file.write(chevron.render(file.read(), data=data))



if __name__ == "__main__":
    app = argparse.ArgumentParser(description='generate themes from images and template config files with jinja2')
    subcommands = app.add_subparsers(title='subcommand', dest='subcommand')
    app.set_defaults(func=render)
    app.add_argument('-c', '--config', metavar='FILE', default="~/.config/ricer/ricer.yaml", help='configuration file')

    # subcommands
    get_template = subcommands.add_parser('get-template')
    get_template.set_defaults(func=download_dracula_theme)

    # run
    args = app.parse_args()
    args.func(args)

