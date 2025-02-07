#!/usr/bin/env nu

# load yaml
# TODO default config location
let config = open 'stashe.yml'
cd $config.template-dir

# detect operating systems
let os = $config.detect |
    transpose os cmd |
    where {|row| (run-external ...($row.cmd | split row ' ') | complete | get exit_code) == 0} |
    first | get os

# resolve a value that is potentially split across operating systems
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

# TODO structure with main function
# TODO handle arguments --install(-i) --render(-r)
# TODO completions
