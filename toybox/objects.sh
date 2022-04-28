#!/bin/bash


## object types
# (s)tring
# (d) int
# (f)loat
# (F)unction
# (O)ption flag
# (a)rray
# (A)rgs
# (r)egex
# (I) file or stdin
# (S)eparator
# (T)put code
# (v)ariable scalar

## embedded languages
# f - a format as accepted by fmt (printf + extensions)
# r - a regex as taken by =~ (and therefore M())
# c - a command as taken by _()
# p - a pattern taken by `_ M`
# t - a template taken by mo()
# s - a script as taken by the shell

## reference
# https://docs.python.org/3/library/itertools.html
# https://docs.python.org/3/library/functools.html#functools.reduce

## non-purpose, but neat
# turing complete? forth-like
# write current state as parital function like $1() { code=... stack=...; _ "$@"; }

## constraints
# no subshells
# work in bash or zsh (`emulate ksh; setopt bashrematch`)
# single letter command names
## load/store commands
# array exec io var
## stack/args manipulation
# call dup literal next print sWap xdrop
## default/option functions
# j m r s

## unused letters
# b g k o t u y z

. "$(lib)"
_() {
    local _help='Usage: _ [<arg>...]

Rationale:
    a tool to handle arrays and indirection more consistently in pure bash
    handle common ways to load and save arrays (variable args file_lines)
    handle common array operations (slice map filter zip zip_longest sort unique concat group)
    handle common array <-> scalar operations (print count reduce split_string)

Terms:
    "args" refers to $@, the arguments passed to this command (as a stack, $1 is on top).
    "$code" is a string of Commands from the table below (initially empty).
    "$stack[]" is an array of values (initially empty, ${stack[-1]} is on top).

Operation:
    When $code is empty, $1 is popped into code. If $code and $@ are empty, execution stops.
    Each command in $code is executed until either 
    "h" is found (which prints this message and exits) or there is an invalid command.
    When finishing without an error. Return 0 if $stack[] is not empty

Command types:
    Generally, commands fall into three categories: load/store, stack/args, or default/option.
    In these categories the lowercase and uppercase letter will do complimentary things.
    For example "a" loads an array from a name, and "A" stores it to a name.
    "w" will swap the top two items in the stack and "W" will swap the first two arguments.
    "s" will sort the stack. "S" allows you to pass additional arguments to the underlying
    command (see `man sort`).

Commands:'
    _log() { :; }
    local __x __y code stack=()
    while (($#)); do code="$1"; (($#))&&shift; _log "code='$code'"; while ((${#code})); do case "${code:0:1}" in
        A) _log "store array as $1"
            (($#)) && eval "$1=(\"\${stack[@]}\")" && shift ;;
        a) _log "load array $1"
            (($#)) && eval "stack+=(\"\${$1[@]}\")" && shift ;;
        C) _log "call '$@'"
            while IFS= read -r __y; do stack+=("$__y"); done < <("$@") ;;
        c) _log "call '${stack[@]}'. stack is replaced."
            __x=("${stack[@]}"); stack=();
            while IFS= read -r __y; do stack+=("$__y"); done < <("${__x[@]}") ;;
        D) _log "dup arg"
            set -- "$1" "$@";;
        d) _log "dup stack"
            apeek stack __x; stack+=("$__x") ;;
        E) _log "save state as $1"
            # save fmt is (len(arg), code, arg..., stack...)
            eval "shift; $1=(\$# \"\${code#?}\" \"\$@\" \"\${stack[@]}\")"
            return ;;
        e)  _log "load state $1"
            eval "shift;__x=(\"\${$1[@]}\")"
            #_log "load state $1=(${__x[*]})"
            code="E${__x[1]}${code#?}"
            eval "set -- \"\${__x[@]:2:${__x[0]}}\" \"\$@\"; stack+=(\"\${__x[@]:$((${__x[0]} + 2))}\")"
            #_log "__x=(${__x[@]})"
            #_log "code='$code'"
            #_log "arg=($@)"
            #_log "stack=(${stack[@]})"
            ;;
        f) _log "filter by regex r'$1'"
            (($#)) || continue
            __x=("${stack[@]}"); stack=();
            for item in "${__x[@]}"; do [[ "$item" =~ $1 ]] && stack+=("$item"); done
            shift;;
        H) _log "turn on debugging"
            _log() { echo "_: $@" >&2; }
            _log "code='$code'" ;;
        h) _log "show help"
            # try parsing `declare -f _` to look for flag names and _log messages
            echo "$_help" >&2; 
            declare -f _ | sed -n '/)$/n;s/[;"]//g;s/^[ \t]*/    /;s/) *_log/) -/p' >&2
            # declare -f _ | sed -n 's/^[\t ]*/    /;s/ *$//;/(.)/{s/_log/-/p};/^ *.)/{N;s/\n *_log/ -/p};s/[;"]//g'
            # zsh: _ lllcfMp declare -f _ '\([-a-zA-Z]\)' '\((.)\)[^"]*"([^"]*)' '    %B1) - %B2'
            return ;;
        I) _log "store to file $1"
            (($#)) && printf '%s\n' "${stack[@]}" > "$1" && shift ;;
        i) _log "load file $1"
            (($#)) && while IFS= read -r __x; do stack+=("$__x"); done < <(cat "$1") && shift ;;
        J) _log "join stack on '$1'"
            unset __x; printf -v __x "${1//"%"/%%}%s" "${stack[@]}"; printf -v __x %s "${__x#"$1"}"; stack=("${__x}")
            shift ;;
        j) _log "join stack"
            unset __x; printf -v __x %s "${stack[@]}"; stack=("$__x")
            ;;
        L) _log "load arg"
            apop stack __x;
            set -- "$__x" "$@";;
        l) _log "load literal '$1'"
            (($#)) && stack+=("$1") && shift ;;
        M) _log "regex map r'$1' -> f'$2'"
            # figure out what parts of the match are asked for in $2
            # use that to construct an eval with indexes into M[]
            # find and replace \d in $2 with %s and printf
            __x="$2" __y=()
            while [[ "$__x" =~ %B([0-9]*) ]]; do
                __y+=("${BASH_REMATCH[1]}")
                __x="${__x/"${BASH_REMATCH[0]}"/%s}"
            done
            printf -v __y ' "${BASH_REMATCH[%s]}"' "${__y[@]}"
            __y[0]="'$__x'$__y"
            for ((__x=0; __x< ${#stack[@]}; __x++)); do
                [[ "${stack[$__x]}" =~ $1 ]]
                eval "printf -v stack[$__x] ${__y[@]}"
            done
            shift 2;;
        m) _log "simple map f'$1'"
            # behaves oddly if $1 doesn't contain a directive
            printf -v stack "$1" "${stack[@]}"; shift ;;
        N) _log "next arg"
            __x="$1"; shift; set -- "$@" "$__x" ;;
        n) _log "next stack"
            apop stack __x; stack=("$__x" "${#stack[@]}") ;;
        O) _log "omit $1"
            shift ;;
        o) _log "omit stack"
            apop stack __x ;;
        P) _log "print arg ($#)"
            (($#)) && printf '%s\n' "$@" ;;
        p) _log "print stack (${#stack[@]})"
            ((${#stack[@]})) && printf '%s\n' "${stack[@]}";;
        Q) _log "swap args with stack"
            __x=("${stack[@]}")
            stack=("$@")
            set -- "${__x[@]}";;
        q) _log "clear args"
            set --;;
        R) _log "split on '$1'"
            (($#)) || continue
            __x=("${stack[@]}"); stack=(); 
            for item in "${__x[@]}"; do asplit stack "$1" "$item"; done
            shift;;
        r) _log "fmt by '$1'"
            # clearly fmt causes some janky behavior here
            __x=("${stack[@]}"); stack=();
            fmt -v stack "$1" "${__x[@]}"
            shift;;
        S) _log "sort with options -$1"
            __x=("${stack[@]}"); stack=();
            while IFS= read -r -d $'\0' __y; do stack+=("$__y"); done < <(printf '%s\0' "${__x[@]}"|sort -z$1)
            shift;;
        s) _log "sort"
            __x=("${stack[@]}"); stack=();
            while IFS= read -r -d $'\0' __y; do stack+=("$__y"); done < <(printf '%s\0' "${__x[@]}"|sort -z) ;;
        V) _log "store var as $1"
            (($#)) && apop stack "$1" && shift ;;
        v) _log "load var $1"
            (($#)) && eval "stack+=(\"\${$1}\")" && shift ;;
        W) _log "swap args"
            __x="$1" __y="$2"; shift 2
            set -- "$__y" "$__x" "$@";;
        w) _log "swap stack"
            apop stack __x;
            apop stack __y
            stack+=("$__x" "$__y")
            ;;
        z) _log "load stack size"
            stack+=("${#stack[@]}") ;;
        -) _log "ignored" ;; # ignored
        #Z) _log "zipping $1 arrays" # TODO
        #    shift ;;
        #    #shift "$1"; shift;;
        *) echo "_: unrecognized code '${code:0:1}'" >&2; return 1 ;;
    esac; code="${code#?}"; done; done
    ((${#stack[@]})) # set return code
}
# _ AAa arr_A arrB combined # combined=("${arr_A[@]}" "${arr_B[@]}")
# _ AVa arr var combined    # combined=("${arr[@]}" "$var")
# _ Afa arr '.' arr         # filter items from arr that are empty and store back to arr
# _ Aaa arr copy1 copy2     # copy arr to copy1 and copy2
# _ ALa arr x arr           # arr+=('x')
# _ VRfa v '\n' '.' v       # split a string v into an array using '\n' as a delimiter, filter empty items and store

# arg=a,bc,d='e f'
# _ VRvRdva arg = default , name x
# name=d x=(a bc d) default='e f'
