# nushell config
use std

# TODO: completers https://www.nushell.sh/cookbook/external_completers.html

$env.config.show_banner = false

$env.config.edit_mode = 'vi'
$env.config.buffer_editor = 'nvim'
$env.PROMPT_INDICATOR = '!!!' # emacs mode, this shouldn't happen
$env.PROMPT_INDICATOR_VI_NORMAL = ':'
$env.PROMPT_INDICATOR_VI_INSERT = '%'
alias vi = nvim

$env.config.keybindings ++= [{
    name: edit_files
    modifier: alt
    keycode: char_e
    mode: [vi_normal vi_insert]
    event: {
        send: executehostcommand,
        cmd: "nvim +'lua require(\"telescope.builtin\").find_files()'"
    }
}]

# pipe through the clipboard
def clip [] {
    if ($in | is-not-empty) {
        $in | wl-copy
    }
    wl-paste
}

# take a screenshot
def screenshot [] { slurp | grim -g - - | wl-copy }

# pick a color on the screen (sRGB)
# returns {hex: ABCDEF r: 255 g: 255 b:255}
def pick [] {
    slurp -p  | grim -g - - |
        magick - -format '%[pixel:p{0,0}]' txt:- |
        parse -r '#(?<hex>[^\W][^\W]*) *srgb\((?<r>\d*),(?<g>\d*),(?<b>\d*)' | get 0
}


# parse git status for prompt
def roots [] {
    try {
        cd (git rev-parse --show-toplevel)
        let data = git status --porcelain=2 --branch --ahead-behind |
            parse -r '(?m)(?:^(?:# branch.head (?<branch>.*)|(?<mod>[12u]).*|# (?<upstream>branch.upstream).*|# branch.ab +(?<ahead>\d+) -(?<behind>\d+)|.*)$)*'
        (do {cd ..; roots}) ++ [{
            dir:    (pwd)
            name:   (pwd | path parse | get stem)
            branch: ($data.branch   | compact -e | first | str replace '(detached)' 'HEAD')
            mod:    ($data.mod      | compact -e | is-not-empty)
            local:  ($data.upstream | compact -e | is-empty)
            ahead:  ($data.ahead    | compact -e | append 0 | first)
            behind: ($data.behind   | compact -e | append 0 | first)
        }]
    } catch { [] }
}

# TODO: prompt sections
# * virtual-env, conda - if active
# * aws, k8s, terraform?
# * user - if root, not the login user, or SSH_CLIENT
# * host - if SSH_CLIENT
$env.PROMPT_COMMAND = {||
    let data = roots e> (std null-device)
    mut prompt = []

    if ($data | is-empty) {
        $prompt ++= [(try {  ['~' (pwd |path relative-to ~)] | path join } catch { pwd })]
    } else {
        # print git-relative location
        $prompt ++= ($data | each {|repo|
            let dirty = (if $repo.mod {$"(ansi red)*"})
            let tracking = (if $repo.local { 'L'
                } else match [($repo.ahead != 0) ($repo.behind != 0)] {
                    [true  true ] => $'($repo.ahead)⇅($repo.behind)'
                    [true  false] => $'($repo.ahead)↑'
                    [false true ] => $'↓($repo.behind)'
                    [false false] => ''
                })
            $"($repo.name)\(($dirty)(ansi green)($repo.branch)(ansi blue)($tracking)(ansi reset)\):"
        })
        $prompt ++= [(pwd | path relative-to ($data | last | get dir))]
    }
    $prompt | str join
}

# print exit code and execution duration if above normal
# TODO: $"(ansi title)set window title(ansi st)" in precmd
$env.config.hooks.pre_execution ++= [{|| $env.LAST_CMD_TIME = date now }]
$env.PROMPT_COMMAND_RIGHT = {||
    let err = $env.LAST_EXIT_CODE
    let now = date now
    # we have to recast as a datetime, because it can be converted into string when
    # starting a subshell
    let start = $env.LAST_CMD_TIME? | default $now | into datetime
    let cmd_duration = $now - $start
    mut prompt = []
    if ($err != 0) { $prompt ++= [$'(ansi red)($err)' ] }
    if ($cmd_duration > 1sec) { $prompt ++= [$'(ansi yellow)($cmd_duration | format duration sec)'] }
    if ($prompt | is-not-empty) {
        $'(ansi reset)[($prompt | str join " ")(ansi reset)]'
    }
}

def _gg [] { glob '~/my/*/*' | path basename }
def --env gg [project:string@_gg=''] {
    # by default return to project root or home
    if ($project | is-empty) {
        cd (try { git rev-parse --show-toplevel e> (std null-device) } catch { '~' })
    }
    # clone a url in the correct place
    let p = $project | path split
    match ($p | length) {
        1 => (cd (glob ('~/my/*/' ++ $project) | first))
        2 => (cd ('~/my/' ++ $project))
        3 => (
            let dest = ['~/my/', $p.1, $p.2] | path join;
            git clone $project $dest;
            cd $dest
        )
    }
}

# because I can never remember the damn names
# TODO: make this a nicer wrapper
let ctl = {
    audio: wpctl
    wifi: iwctl
    music: mpc
    blue: bluetoothctl
    monitors: nwg-displays
    brightness: brightnessctl
    notify: notify-send
}
