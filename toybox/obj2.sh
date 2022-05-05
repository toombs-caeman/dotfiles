#!/bin/bash

# diff zsh bash
# removing index from
# bash: unset -v a[-1]
# zsh: a[-1]=()
# zsh printf returns an array iff -v array
# 

# a: append
# e: exec
# i: append file
# o: write to file
# P: pretty print to stdout
# f: filter
# F: 
# M: Match global match/sub
# m: match/sub
# j: join
# r: split
# p: peek
# P: pop
# S: sort

# pull common regex out for use around eval
# like bash_identifier

fmt() {
    # -v output var
    # -V use var as in and output
    # %T tput cache
    # %w/%W where/filter_out (where)
    # %F format, assumed final
    # %j/%J join/split
    # %M match (must be followed by %F
    # %S sort with flags
    if ! (($#)); then
        # update cache
        # Black Red Green Yellow blUe Magenta Cyan White
        declare -Ag fmt=()
        fmt[--]="$(tput sgr0)"; local f b c=(b r g y u m c w B R G Y U M C W) dat=()
        fmt -v dat "%T--%J" "$(printf '%s\nsgr0\n' seta{f,b}\ {0..15} smul dim bold | tput -S)"
        for f in {0..15}; do fmt[${c[$f]}-]="${dat[$f]}" fmt[-${c[$f]}]="${dat[$f+16]}"; done
        for f in "${c[@]}"; do for b in "${c[@]}"; do fmt[$f$b]="${fmt[${f}-]}${fmt[-$b]}"; done; done
        fmt[__]="${dat[32]}" fmt[..]="${dat[33]}" fmt[**]="${dat[34]}"
        return
    fi
    local __ # use as reply
    case "$1" in
        -V) eval "_fmt \"\$3\" \"\${$2[@]}\" \"\${@:4}\""; eval "$2=(\"\${__[@]}\")" ;;
        -v) _fmt "${@:3}"; eval "$2=(\"\${__[@]}\")" ;;
        *)  _fmt "$@"; printf %s "${__[@]}" ;;
    esac
    ((${#__[@]}))
    return
}
_fmt() {
    local x y spec="$1"; shift
    y='(^|[^%])%((%%)*)T(..)'
    while [[ "$spec" =~ $y ]]; do
        x="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${fmt[pp]}${fmt[${BASH_REMATCH[4]}]}${fmt[qq]}"
        spec="${spec/"${BASH_REMATCH[0]}"/"$x"}"
    done
    # match any character, but not an empty string. if there's an unescaped section flag, only match up to there.
    local section flag flags='wWjJMFS'
    local getsection="^(([^%]|%[^$flags])*)((^|[^%])%((%%)*)([$flags]))?"
    echo "$getsection"
    while [[ "$spec" =~ $getsection ]]; do
        section="${BASH_REMATCH[1]}${BASH_REMATCH[4]}${BASH_REMATCH[5]}" flag="${BASH_REMATCH[7]}"
        spec="${spec#"${BASH_REMATCH[0]}"}"
        echo "flag='$flag' section='$section' remainder='$spec'"
        case "$flag" in
            w|W) # filter
                [ "$flag" = w ]; local invert=$? x=()
                while (($#)); do [[ $1 =~ $section ]]; [ $invert = $? ] && x+=("$1"); shift; done
                set -- "${x[@]}" ;;
            j) # join
                unset -v x; printf -v x "%s${section//"%"/%%}" "$@"; set -- "${x%"$section"}" ;;
            J) # split
                x=()
                if [ -n "$section" ]; then
                    for y in "$@"; do
                        while ((${#y})); do x+=("${y%%"$section"*}") y="${y#"${x[-1]}"}" y="${y#"$section"}"; done
                    done
                else
                    # https://stackoverflow.com/a/34634535
                    for y in "$@"; do [[ "$y" =~ ${y//?/(.)} ]]; x+=("${BASH_REMATCH[@]:1}"); done
                fi
                set -- "${x[@]}" ;;
            S) # sort
                x=(); while IFS= read -r -d $'\0' y; do x+=("$y"); done < <(printf '%s\0' "$@"|sort -z$section)
                set -- "${x[@]}" ;;
            M) # match
                unset -v BASH_REMATCH
                [[ "$spec" =~ $getsection ]] || echo "match fail"
                local mformat="${BASH_REMATCH[1]}${BASH_REMATCH[4]}${BASH_REMATCH[5]}"
                #flag="${BASH_REMATCH[6]}"
                spec="${spec#"${BASH_REMATCH[0]}"}"
                x=()
                while [[ "$mformat" =~ %([0-9]*)m ]]; do
                    x+="${BASH_REMATCH[1]:-0}"
                    mformat="${mformat/"${BASH_REMATCH[0]}"/%}"
                done
                echo "mformat='$mformat' x='${x[@]}'"


                local args=("$@") a i
                for ((a=0; a<${#args[@]}; a++)); do
                    if [[ "${args[$a]}" =~ ${section} ]]; then
                        y=(); for i in ${x[@]}; do y+="${BASH_REMATCH[$i]}"; done
                        printf -v args[$a] "$mformat" "${y[@]}"
                    fi
                done
                set -- "${args[@]}" ;;
            *) # format, assumed if final flag isn't given
                [ -n "$section" ] || break
                unset -v y; x=(); for y in "$@"; do printf -v y "$section" "$y"; x+=("$y"); done; set -- "${x[@]}" ;;
        esac
    done
    __=("$@")
}

curse() {
    # like eval, but even less safe
    printf -v __ "$@" && eval "$__"
}
repl() {
    # scrape keycodes from `man 5 terminfo | grep '^ *key_'`
    local _repl_key _repl_line= _repl_code=()
    printf -v _repl_esc '\e'
    while IFS= read -rsN 1 _repl_key; do
        case "$_repl_key" in
            $'\e'|$'\n')
                while IFS= read -rsN 1 -t 0.0001 -i "$_repl_key" _repl_key; do :; done
                # transform _repl_key into the terminfo variable string and set _repl_code
                _repl_code='key_left' _repl_key= # set escape sequence and clear keys
                eval "$@" "$_repl_line"
                _repl_code= # clear escape sequence
                printf %s "$_repl_line"
                ;;
            *)
                printf %s "$_repl_key"
                _repl_line+="$_repl_key"
                ;;
        esac
    done
}

# also, sanitize eval input by matching $__a =~ '^[-_a-zA-Z]*$'
# add command_not_found_handle() to handle _up -> _ up?
__() {
    local __="$(declare -f "${FUNCNAME:-${funcstack}}")"
    __="${__#*return}"
    __="${__%"}"}"
    __="${__//Y/__[6]}"
    __="${__//X/__[5]}"
    __="${__//CMDS/__[1]}"
    #    VAR CMDS CASE   INNER ARG X  Y
    __=(x  "$1" "$__" ''    ''  '' '')
    shift
    while ((${#__[1]})); do
        # INNER=CASE//VAR/$VAR
        __[3]="${__[2]//VAR/${__[0]}}"
        [[ "$1" =~  ^[a-zA-Z_][a-zA-Z_0-9]\*$ ]] && __[4]="$1" || __[4]="" # sanitize ARG
        # eval INNER//ARG/$ARG
        eval "${__[3]//ARG/${__[4]}}"
    done
    eval "((\${#$__[@]}))" # return ok if VAR not empty in the end. (empty strings are still an array of length 1)
    return # marker to rewrite

    case "${CMDS:0:1}" in
        # I/O
        a) VAR+=("${ARG[@]}") ;;
        e) while IFS= read -r X; do VAR+=("${X}"); done < <(eval "$1") ;;
        i) while IFS= read -r X; do VAR+=("${X}"); done < <(cat "$1") ;;
        o) X=/dev/stdout; [ "${1:--}" != - ] && X="$1"; printf '%s\n' "${VAR[@]}" > "${X}" ;;
        u) [[ "$1" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]] && __a="$1" ;;
        # MISC
        .) unset -v VAR; set -- '' "$@" ;;
        +) VAR+=("$@"); set --;;
        P) printf '%s(%s):\n' "$VAR" "${#VAR[@]}"; ((${#VAR[@]})) && printf '    "%s"\n' "${VAR[@]}" ;;
        p) ((${#VAR[@]})) && printf '%sn' "${VAR[@]}";;

        # WRITE ARG
        T) printf -v "ARG" %s "${VAR[-1]}"; [ -n "$ZSH_VERSION" ] && VAR[-1]=() || unset -v VAR[-1] ;;
        t) printf -v "ARG" %s "${VAR[-1]}" ;;
        n) ARG=${#VAR[@]} ;;
        Z)
            printf -v X ""
            X=0; for Z in "$@"; do ((X < ${#Z[@]}))&& X=${#Z[@]}; done
            for ((Y=0; Y < X; Y++)); do for Z in "$@"; do VAR+=("${Z[${Y}]}"); done; done
            set --;;
        z) _log "$__a+=(zip($@)). consumes input"
            local __x='-1' __y __i
            for __i in "$@"; do eval "((__x > \${#$__i[@]}))||((__x<0))&&__x=\${#$__i[@]}"; done
            for ((__y=0; __y<__x; __y++)); do for __i in "$@"; do eval "$__a+=(\"\${$__i[$__y]}\")"; done; done
            set --;;
    esac
    CMDS="${CMDS#?}"
    (($#)) && shift
}

_log() { echo "> $@" >&2; }
_() {
    # usage: arr <array_name> <command string> [<command args> ...] [-- <literal values> ...]
    # input commands: {files,arg,var,array,command,stdio}
    # transform: mapreduce filter zip zort split
    # output commands: {files,arg,var,array,command,stdio}
    # all commands are monadic

    local __a=(__ "$1") # use a_default as the working var, __a[1] is the command string
    shift
    # local __a=("$1" "$2") # the name of the array to use, and the command string
    #shift; (($#)) && shift
    while ((${#__a[1]})); do case "${__a[1]:0:1}" in
        # io
        # use uppercase to prepend values ?
        a) _log "append indirectly $1"
            eval "$__a+=(\"\${$1[@]}\")";;
        e) _log "append output \`$1\`"
            local __x; eval "while IFS= read -r __x; do $__a+=(\"\$__x\"); done < <(eval \"\$1\")"
            ;;
        i) _log "append file $1"
            local __x; eval "while IFS= read -r __x; do $__a+=(\"\$__x\"); done < <(cat \"\$1\")" ;;
        o) _log "write array \$$__a to ${1:-stdout}"
            local __x="${1:--}"; [ "$__x" = "-" ] && __x=/dev/stdout
            eval "printf '%s\n' \"\${$__a[@]}\" > \"\$__x\"" ;;
        u) _log "use var $1"
            # TODO sanitize $1 as a valid identifier
            local __x='^[a-zA-Z_][a-zA-Z_0-9]*$'
            if [[ "$1" =~ $__x ]]; then
                __a="$1"
            else
                _log "tried to use invalid identifier '$1'"
                return 1
            fi ;;
        .) _log "clear var"
            unset -v "$__a"; set -- junk "$@";;
        P) _log "fancy print" # for convenience
            eval "printf '%s(%s):\n' \"$__a\" \"\${#$__a[@]}\""
            eval "((\${#$__a[@]})) && printf '    \"%s\"\n' \"\${$__a[@]}\"" ;;
        p) _log "print to stdout" # for convenience
            eval "((\${#$__a[@]})) && printf '%s\n' \"\${$__a[@]}\"" ;;

        # final commands (because variadic). these all clear input
        =) _log "$__a=($@), consumes input"
            eval "((\$#)) && $__a=(\"\$@\") || $__a=()"
            set --;;
        +) _log "$__a+=($@), consumes input"
            eval "$__a+=(\"\$@\")"
            set --;;
        Z) _log "$__a+=(zip_longest($@)). consumes input"
            local __x=0 __y __i
            for __i in "$@"; do eval "((__x < \${#$__i[@]}))&&__x=\${#$__i[@]}"; done
            for ((__y=0; __y<__x; __y++)); do for __i in "$@"; do eval "$__a+=(\"\${$__i[$__y]}\")"; done; done
            set --;;
        z) _log "$__a+=(zip($@)). consumes input"
            local __x='-1' __y __i
            for __i in "$@"; do eval "((__x > \${#$__i[@]}))||((__x<0))&&__x=\${#$__i[@]}"; done
            for ((__y=0; __y<__x; __y++)); do for __i in "$@"; do eval "$__a+=(\"\${$__i[$__y]}\")"; done; done
            set --;;

        # write vars
        T) _log "pop to $1"
            : "$__a[\${#$__a[@]}-1]"
            eval "printf -v '${1:-_}' %s \"\${$_}\"; [ -n \"\$ZSH_VERSION\" ] && $_=() || unset $_" ;;
        t) _log "peek to $1"
            eval "printf -v '${1:-_}' %s \"\${$__a[\${#$__a[@]}-1]}\";" ;;
        n) _log "size to $1" 
            eval "$1=\${#$__a[@]}" ;;
        c) _log "${2:-$__a}=$__a[$1] slice to array" 

            ;;

        # rewrite
        F) _log "inverted filter array on '$1'"
            local __x __y
            eval "__x=(\"\${$__a[@]}\"); $__a=();"
            eval "for __y in \"\${__x[@]}\"; do [[ \"\$__y\" =~ \$1 ]] || $__a+=(\"\$__y\"); done"
            ;;
            
        f) _log "filter array on '$1'"
            local __x __y
            eval "__x=(\"\${$__a[@]}\"); $__a=();"
            eval "for __y in \"\${__x[@]}\"; do [[ \"\$__y\" =~ \$1 ]] && $__a+=(\"\$__y\"); done"
            ;;
        r) _log "split by separator '$1'" 
            local __x __y
            eval "__x=(\"\${$__a[@]}\"); $__a=()"
            if [ -n "$1" ]; then
                for __y in "${__x[@]}"; do
                    while ((${#__y})); do
                        eval "$__a+=(\"\${__y%%\"\$1\"*}\")"
                        __y="${__y#"${__y%%"$1"*}"}"
                        __y="${__y#"$1"}"
                    done
                done
            else
                for __y in "${__x[@]}"; do
                    # https://stackoverflow.com/a/34634535
                    [[ "$__y" =~ ${__y//?/(.)} ]]
                    eval "$__a+=(\"\${BASH_REMATCH[@]:1}\")"
                done
            fi
        ;;
        S) _log "sort"
            local __x __y; eval "__x=(\"\${$__a[@]}\") $__a=()"
            eval "while IFS= read -r -d $'\0' __y; do $__a+=(\"\$__y\"); done" < <(printf '%s\0' "${__x[@]}"|sort -z$1)
            ;;
        s)  _ uS "$__a"; set -- junk "$@" ;;
        m) _log "map values on '$1'"
            # input: "(<match>%m<format>)|((<line>%L)?<format>(%I<sep>)?)"
            # escape match %%m %m
            # escape match %%T %T
            # escape sep % %%

            # $format is expanded with all values using the normal printf rules, but with the string literal $sep inserted 
            # between each repetition of $format.
            # once done, $line is expanded with the output of the previous expansion as a single value if given.

            # if $match is given it is used as a regex to match against each value. Format is then expanded using '[0-9]*m' 
            # as an extra flag for printf directives to indicate a backreference.
            # with %1m to specify backreferences.
            # Groups are counted starting from 1, with 0 refering to the whole match. 
            # If no backreference is given, pass the whole value once.
            local spec="$1"
            local __x __y # scratch
            __x='(^|[^%])%((%%)*)T(..)'
            while [[ "$spec" =~ $__x ]]; do 
                __y=("${BASH_REMATCH[@]}")
                spec="${spec//${__y[0]}/"${__y[1]}${__y[2]}${fmt[pp]}${fmt[${__y[4]}]}${fmt[qq]}"}"
            done
            # split $spec into parts
            _log "spec='$spec'"

            # match is before %m, then unescape ((%%)*)m
            # if we don't find %m, then spec is not for a match
            # TODO needs to grab the FIRST %m, since %m later refers to %0m
            __x='^(.*)(^|[^%])%((%%)*)m'
            if [[ "$spec" =~ $__x ]]; then
                _log "matching"
                local match format
                __y=("${BASH_REMATCH[@]}")
                match="${__y[1]}${__y[2]}${__y[3]//%%/%}"
                format="${spec#"${BASH_REMATCH[0]}"}"
                _log "match='$match' format='$format'"
                # figure out what parts of the match are asked for in $format
                # use that to construct an eval with indexes into BASH_REMATCH
                # find and replace %m in $format with %s and printf
                __x="$format" __y=()
                while [[ "$__x" =~ %([0-9]*)m ]]; do
                    __y+=("${BASH_REMATCH[1]:-0}")
                    __x="${__x/"${BASH_REMATCH[0]}"/%}"
                done
                ((${#__y[@]})) && printf -v __y ' "${BASH_REMATCH[%s]}"' "${__y[@]}" || __y=()
                __y[0]="'$__x'$__y"
                unset __x # make __x a string
                __x="for ((__x=0; __x< \${#$__a[@]}; __x++)); do "
                    __x+="[[ \"\${$__a[\$__x]}\" =~ \$match ]] &&"
                    __x+="printf -v $__a[\$__x] ${__y[@]};"
                __x+="done"
                eval "$__x"
            else
                #_log "formatting"
                local line format sep
                # line is before %L
                # sep is after %I, then escape % to %%
                # format is what's left (in between)
                __x='^((.*)(^|[^%])%((%%)*)L)?' # line: 5 groups
                __x+='((%%|[^%]|%[^I])*)' # format: 2 groups
                __x+='(%I(.*))?$' # sep: 2 groups
                [[ "$spec" =~ $__x ]] || _log "spec didnt match for final formatting"
                __y=("${BASH_REMATCH[@]}")
                line="${__y[2]}${__y[3]}${__y[4]}" format="${__y[6]}" sep="${__y[9]//"%"/%%}"
                _log "line='$line' format='$format' sep='$sep'"
                eval "printf -v format \"\$sep\$format\" \"\${$__a[@]}\""
                unset -v $__a # make sure the working 'array' (now a string) doesn't have dingleberries
                printf -v $__a "${line:-"%s"}" "${format#"$sep"}"
                eval "$__a=(\"\${$__a[@]}\")" # make __a an array again
            fi
            ;;
    esac; __a[1]="${__a[1]#?}"; (($#)) && shift; done
    eval "((\${#$__a[@]}))" # return ok if array not empty in the end. (empty strings are still an array of length 1)
}
