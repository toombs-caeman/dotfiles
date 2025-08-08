# nushell config
use std


# this is the path to imbue, which it templates in itself
$env.path ++= ['{{bin}}', ('~/.local/bin/' | path expand)]
$env.config.show_banner = false
$env.config.edit_mode = 'vi'
$env.config.buffer_editor = 'nvim'
$env.PROMPT_INDICATOR = '!!!' # emacs mode, this shouldn't happen
$env.PROMPT_INDICATOR_VI_NORMAL = ': '
$env.config.use_kitty_protocol = true
$env.PROMPT_INDICATOR_VI_INSERT = '% '
$env.SHELL = 'nu' # open nu in :term
def vi [file?] {
    if ($file == null) {
        nvim
    } else if ('NVIM' in $env) {
        nvim --server $env.NVIM --remote ($file | path expand )
    } else {
        nvim ($file | path expand )
    }
}
$env.config.history = {
    file_format: sqlite # enable rich history
    max_size: 1_000_000
    sync_on_enter: true
    isolation: true  # don't mix session history when using up key
}

$env.config.keybindings ++= [
    {
        name: edit_files,
        modifier: alt,
        keycode: char_e,
        mode: [emacs, vi_normal, vi_insert],
        event: {
            send: executehostcommand,
            cmd: "nvim +'lua require(\"telescope.builtin\").find_files()'",
        }
    },
    {
        name: start_nvim,
        modifier: alt,
        keycode: char_s,
        mode: [emacs, vi_normal, vi_insert],
        event: {send: executehostcommand, cmd: "nvim"},
    }
    {
        name: paste,
        modifier: control,
        keycode: char_v,
        mode: [emacs, vi_normal, vi_insert],
        event: {
            send: executehostcommand,
            cmd: "wl-paste",
        }
    }
]

# pipe through the clipboard
def clip [] {
    if ($in | is-not-empty) {
        $in | wl-copy
    }
    wl-paste
}

# get which package provides a given file
def provides [...$cmds] {
    pacman -Qo ...$cmds | parse '{file} is owned by {package} {version}'
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
            parse -r '(?m)(?:^(?:# branch.head (?<branch>.*)|(?<mod>[12u]).*|# (?<upstream>branch.upstream).*|# branch.ab \+(?<ahead>\d+) -(?<behind>\d+)|.*)$)*'
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

    if ('SSH_CLIENT' in $env) {
        $prompt ++= [(ansi light_blue) (hostnamectl --static) ':' (ansi reset)]
    }
    if ($data | is-empty) {
        $prompt ++= [(try {  ['~' (pwd |path relative-to ~)] | path join } catch { pwd })]
    } else {
        # print git-relative location
        $prompt ++= ($data | each {|repo|
            let dirty = (if $repo.mod {$"(ansi red)*"})
            let tracking = (if $repo.local { 'L'
                } else match [($repo.ahead != '0') ($repo.behind != '0')] {
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

# print exit code and execution duration if not normal
$env.PROMPT_COMMAND_RIGHT = {||
    let cmd = history | last
    let prompt = [
        (if $cmd.exit_status != 0 {$'(ansi red)($cmd.exit_status)'})
        (if $cmd.duration > 1sec  {$'(ansi yellow)($cmd.duration)'})
    ] | compact
    if ($prompt | is-not-empty) {
        $'(ansi reset)[($prompt | str join " ")(ansi reset)]'
    }
}

# go to project roots
# 
# if no argument is given, go to git root or ~
# if a git remote url is given, clone it and cd to it.
def --env gg [
    project:string@_gg=''
    --init:string=''
] {
    # by default return to project root or home
    if ($project | is-empty) {
        cd (try { git rev-parse --show-toplevel e> (std null-device) } catch { '~' })
    }

    try {
        # this fails if project is an ssh remote
        # or if the glob fails to match anything
        cd (glob ('~/my/*/' ++ $project) | first)
    } catch {
        let dest = $project |
            parse -r '(?<group>[^/:]*)/(?<name>[^/]*?)(?:.git)?$' |
            ['~' 'my' $in.0.group $in.0.name] |
            path join | path expand
        git clone $project $dest
        cd $dest
    }
}
def _gg [] { glob '~/my/*/*' | path basename | uniq }


# initialize python project
def --env 'gg init pyweb' [
    project:string
] {
    let p = '~/my/toombs-caeman/' ++ $project
    uv init $p
    cd $p
    uv add fastapi SQLModel pytest
}

# because I can never remember the damn names
# TODO: make this a nicer wrapper
let ctl = {
    audio: wpctl
    wifi: iwctl
    music: mpc
    bluetooth: bluetoothctl
    monitors: nwg-displays # this is the only gui. does that make sense?
    brightness: brightnessctl
    notify: makoctl
    windows: hyprctl
}
def _ctl [] { $ctl | columns }
def ctl [query:string@_ctl] {
    mut query = $query
    if ($query | is-empty) {
        $query = $ctl | transpose name cmd | input list -fd name | get cmd
    } else {
        $query = $ctl | get $query
    }
    ^$query
}

def colors [] {
    mut base = ['black' 'red' 'green' 'yellow' 'blue' 'magenta' 'cyan' 'white']
    $base ++= $base | each {|c|'light_' ++ $c} | skip | drop
    for c in $base {
        print -n $'(ansi $c)($c) '
    }
    print (ansi reset)
}

# list attached block devices with lsblk
def 'sys blocks' [] {
    lsblk --json | from json | get blockdevices
}

def --wrapped yay [...rest] {
    # install yay if it can't be found
    if (which yay | where type == 'external' | is-empty) {
            gg https://aur.archlinux.org/yay.git
            makepkg -si
    }
    ^yay ...$rest
}

source '{{bin}}/../nu_completions/ollama-completions.nu'
source '{{bin}}/../nu_completions/aws-completions.nu'
source '{{bin}}/../nu_completions/composer-completions.nu'
source '{{bin}}/../nu_completions/curl-completions.nu'
source '{{bin}}/../nu_completions/docker-completions.nu'
source '{{bin}}/../nu_completions/gh-completions.nu'
source '{{bin}}/../nu_completions/git-completions.nu'
source '{{bin}}/../nu_completions/gradlew-completions.nu'
source '{{bin}}/../nu_completions/less-completions.nu'
source '{{bin}}/../nu_completions/make-completions.nu'
source '{{bin}}/../nu_completions/man-completions.nu'
source '{{bin}}/../nu_completions/mvn-completions.nu'
source '{{bin}}/../nu_completions/mysql-completions.nu'
source '{{bin}}/../nu_completions/nano-completions.nu'
source '{{bin}}/../nu_completions/npm-completions.nu'
source '{{bin}}/../nu_completions/pre-commit-completions.nu'
source '{{bin}}/../nu_completions/pytest-completions.nu'
source '{{bin}}/../nu_completions/rg-completions.nu'
source '{{bin}}/../nu_completions/rustup-completions.nu'
source '{{bin}}/../nu_completions/ssh-completions.nu'
source '{{bin}}/../nu_completions/tar-completions.nu'
source '{{bin}}/../nu_completions/tcpdump-completions.nu'
source '{{bin}}/../nu_completions/uv-completions.nu'

