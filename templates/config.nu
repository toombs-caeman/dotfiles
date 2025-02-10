use std

# prompt hooks https://www.nushell.sh/book/hooks.html
# completers https://www.nushell.sh/cookbook/external_completers.html

$env.config.show_banner = false

$env.config.edit_mode = 'vi'
$env.config.buffer_editor = 'nvim'
$env.PROMPT_INDICATOR = '!!!' # emacs mode
$env.PROMPT_INDICATOR_VI_NORMAL = ':'
$env.PROMPT_INDICATOR_VI_INSERT = '%'
alias vi = nvim


# TODO: prompt sections
# * topline
#   * virtual-env, conda - if active
#   * aws, k8s, terraform?
# * user - if root, not the login user, or SSH_CLIENT
# * host - if SSH_CLIENT
# * git status + location
#   * reponame(dirty branch-or-shortname up-down-local):path-relative-to-root
#   * path relative to home otherwise
# * show runtime - if > 5sec
# * exit code - if != 0
# * $"(ansi title)set window title(ansi st)" in precmd


# TODO: recurse
$env.PROMPT_COMMAND = {||
    try {
        let root = git rev-parse --show-toplevel e> (std null-device)
        let project = $root | path basename
        $'($project):(pwd | path relative-to $root)'
    } catch {
        try { ['~' (pwd |path relative-to ~)] | path join } catch { pwd }
    }
}
$env.PROMPT_COMMAND_RIGHT = {|| date now | format date '%m-%d %H:%M'}
# TODO: this time stamp doesn't appear to be correct
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| date now | format date 'run %m-%d %H:%M'}
# TODO: colors

# TODO: dotroot and gg

# TODO: lsp config?

def _gg [] { glob '~/my/*/*' | path basename }
def --env gg [project:string@_gg=''] {
    if ($project | is-empty) {
        # by default return to project root or home
        cd (try { git rev-parse --show-toplevel e> (std null-device) } catch { '~' })
    }
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
