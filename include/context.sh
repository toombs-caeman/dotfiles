# list non-nested git repositories in ~
projects() { find ~/* -type d -name '.git' -prune 2>/dev/null -exec dirname '{}' \; ; }
gg() {
  # goto project (if arg given), git root or home
  local d="${1:-$(git rev-parse --show-toplevel 2>/dev/null || echo ~)}"
  [ -d "$d" ] || d="$(projects | grep "$d$" | head -n1 )"
  cd "$d"
}
_gg() { projects | grep -o '[^/]*$'; }
complete _gg gg

# virtual environments
venv() { if [ -n "$1" ]; then . ~/my/venv/$1/bin/activate; else [ -n "$VIRTUAL_ENV" ] && deactivate; fi; }
_venv() { ls ~/my/venv/; }
complete _venv venv

## HISTORY
# TODO history is one of the COLD contexts. fzf has --history=
# can history be by project or by everything?
HISTSIZE=100000000
HISTFILE=~/.sh_history

## MOVEMENT
define() {
    # generate aliases like '...'='cd ../..'
    local cmd='..' val='..'
    for _ in 1 2 3 4 5; do
      cmd="$cmd." val="$val/.."
      eval "$cmd() { cd $val; }"
    done
    # shortcut going back to the previous directory
    # sh: cannot parse this even if it doesn't actually run. eval gets around it
    config sh || eval -- '-() { cd -; }'
}; define && unset define
