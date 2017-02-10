# TODO modified from bira theme
# ZSH Theme - Preview: http://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
local return_code="%(?..$FG[160]%? ↵%{$reset_color%})"

#to get a list of all the color codes use spectrum_ls
local user_host='$FG[009]%n $FG[011]at $FG[002]%m%{$reset_color%}'
user_symbol() {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    #hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}

#local tasks="$FG[011]doing [$( | wc -l)]$reset_color"
local current_dir='%{$terminfo[bold]$FG[012]%}%~%{$reset_color%}'
local git_branch='$(git_prompt_info)$reset_color'

#PROMPT="╭─${user_host} ${current_dir} ${git_branch} ${tasks}
PROMPT="╭─${user_host} ${current_dir} ${git_branch}
╰─%B${user_symbol}%b "
RPS1="%B${return_code}%b"

ZSH_THEME_GIT_PROMPT_PREFIX="$FG[011]in $FG[012]‹$FG[005]"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[012]› %{$reset_color%}"

