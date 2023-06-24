
# FUNCTION
fls() { declare -f + || declare -F | cut -d' ' -f 3 ; }
fcp() { test -n "$(declare -f "$1")" && eval "${_/$1/$2}" ; }
frm() { unset -f "$1"; }
fmv() { fcp "$1" "$2"; frm "$1"; }

perf=()
perf() { # <funcs> ...
    for func in "$@"; do
        perf+=("$func")
        # insert shims
        fmv "$func" "perf_$func"
        eval "$func() { _perf \"perf_$func\" \"\$@\"; }"
    done
}
_perf() {
    # save start and end times
    # TODO this adds a lot of overhead
    local start="$(date -u +%s.%N)" err
    "$1" "${@:2}"; err=$?
    eval "$1+=(\$start \"\$(date -u +%s.%N)\")"
    return $err
}

# print a performance report
report() {
    local t x ncalls avg total
    for func in "${perf[@]}"; do
        eval "t=(\"\${perf_$func[@]}\")"
        ncalls=$((${#t[@]} / 2))
        printf -v x -- '-%s+%s' "${t[@]}"
        printf -v total 'scale=4;%s' "${x}"
        total="$(bc <<< "$total")"
        printf -v avg 'scale=4;%s/%s' "$total" "$ncalls"
        avg="$(bc <<< "$avg")"
        printf '%10s: %5s * %6s = %s\n' "$func" "$ncalls" "$avg" "$total"
    done
}

# remove test shims
ferp() {
    for func in "${perf[@]}"; do
        # TODO print results
        fmv "perf_$func" "$func"
    done
}

