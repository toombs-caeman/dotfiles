#!/usr/bin/env nu

## logical process
# 0. load config from default path for platform or --config if passed.
# 1. if --install is passed, download each tool which has a package defined on this platform or die
# 2. for each file with an installed tool (determined by which):
#       1. unless --force is passed, skip file if destination already exists and doesn't match a recorded hash
#       2. render file to destination
#       3. record the rendered file's hash
# 3. for each tool which defines a callback and had a file change, run the callback

# TODO default config location
# determine which config we should use, either --config or the standard path based on os-info
let config_path = 'stashe.yml'
match ($nu.os-info.name) {
    windows => '',
    linux => ~/.config/shache/config,
}

# load config
let config = open $config_path
cd $config.template-dir

# detect platforms
# we don't use $nu.os-info here because we allow custom definitions
# "platform" is related to, but not exactly equal to os
let os = $config.detect |
    transpose os cmd |
    where {|row|nu -c $row.cmd|into bool} |
    first | get os

# resolve a config value that is potentially split across platforms
def ovalue [] {
    match ($in | describe) {
        'string' => $in,
        'bool' => '',
        'null' => '',
        _ => ($in | get -i $os),
    }
}

$config.template |
    transpose cmd data|
    select cmd data.files? |
    filter {|r|which $r.cmd|is-not-empty} | # don't process commands which aren't installed
    compact data.files |                    # only those that have files defined
    each {|value |
        let cmd = $value.cmd
        let renders = $value."data.files"|transpose from to|update to {|r|$r.to|ovalue}
        $renders | each {|render|
            # don't process templates which don't exist. TODO maybe warn here?
            if not ($render.from | path exists) { return }
            
            # TODO check if the destination file exists and if it matches the stored hash
            # warn and bail if the hash doesn't match so we don't overwrite non-local changes
            print $"($render.from) => ($render.to)"

            # TODO "render" the file
            # TODO record the file hash
            # TODO save $render.to
        }
        # TODO cmd callback
}
exit

# TODO structure with main function. help doc?
# TODO handle arguments
#   $in is values to render into templates
# --install(-i) # install all tools for the current platform before attempting render
# --force(-f) # overwrite external changes
# --config(-c) # use alternate config file
# TODO completions
# TODO --watch? to watch the templates/ and config and do live updates of the system?
