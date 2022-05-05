#!/bin/bash
. "$(lib)"
spark() {
  # directly inspired by https://github.com/holman/spark/blob/master/spark
  # eval "$(opt wrap,scroll,overwrite? use_stdin,s sine)"
  local use_stdin n min='2^99' max='-2^99' ticks=('▁' '▂' '▃' '▄' '▅' '▆' '▇' '█')
  if [ '-' == "$1" ]; then
    use_stdin=1 min=${2:-$min} max=${3:-$max}
  fi
  {
    printf "z=$max\na=$min\n define l (n) {\n if (n<a) a=n; if (n>z) z=n; }\n" # adjust limits
    printf "define q (n) {\n x=l(n); if (a == z) return (3); return (7.999 * (n-a)/(z-a)); }\n" # quantize input
    if (( use_stdin )); then
      while read n; do printf 'q(%s)\n' "$n"; done
    else
      printf 'x=l(%f)\n' "${@//,}"
      printf 'q(%f)\n' "${@//,}"
    fi
    # check with `bc -s`
  } | bc | { while read n; do printf "%s" "${ticks[$n]}"; done; }
}
sine() { bc -l <<< "while(1){s(x++/3);}"; }
zsh__rate() { local n; while read -ku0 n; do printf '%s' "$n"; sleep "$1"; done; }
bash__rate() { local n; while read -sn 1 n; do printf '%s' "$n"; sleep "$1"; done; }
# try `sine | spark - -1 1 | rate 0.1`
scroll_line() {
  : # scroll a line instead of wrapping around when printing
}
heartbeat_line() {
   :  # overwrite the beginning of a line when wrapping
}
