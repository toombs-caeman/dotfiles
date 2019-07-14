#!/bin/bash

# create a pretty prompt.
# make_prompt is a collapsing function that sets up prompt_command
make_prompt() {
    local branch term_line err_code

    case ${TERM} in
    	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
            # Change the window title of X terminals
    		term_line='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"' ;;
            *) echo "not configured for terminal '$TERM'" ;;
    esac
    
    # check if git is available
    which git >/dev/null 2>&1 && branch="$(color GREEN)\$(git branch 2>/dev/null | sed -n 's/^\* \(.*\)/(\1) /p')"

    eval "prompt_command() {
        # get the err code, this must be the first thing run in the prompt to be useful
        local err=\"$(color RED)\$(echo \$? | sed 's/^0$//')\"
        $term_line
        export PS1=\"$branch\${debian_chroot:+$(color BLUE)[\$debian_chroot]}$(color BCYAN)\w\$err $(color)$\"
    }"
    export -f prompt_command
    export PROMPT_COMMAND=prompt_command
}
