#!/usr/bin/env bash
M() { unset -v M; [[ "$1" =~ $2 ]] && M=("${BASH_REMATCH[@]}"); }
declare -A fmt=() # fmt is a cache of tput values so we don't constantly make subshells when formatting
fmt() {
  # behaves like printf but with extra directivess I, L, and T.
  # example: `fmt '^%s$%L(%s)%I,' a b 'c d'` prints: '^(a),(b),(c d)$'
  # %T.. is a tput cache using two character indexes.
  if (( $# )); then
#    (( fmt )) || fmt # ensure cache is populated
    local f="$1"; shift
    # replace %T00 directives with cached tput codes (and prompt escapes if set)
    while M "$f" '%T(..)'; do f="${f//${M[0]}/"${fmt[pp]}${fmt[${M[1]}]}${fmt[qq]}"}"; done
    # match pattern for %L and %I directives
    M "$f" "((.*)%L)?(([^%]*(%[^I])?)*)(%I(.*))?" || return 1
    : "$(printf "${M[3]}${M[7]}" "$@"; printf 'x')" # sets $_. subshell truncates trailing \n
    printf "${M[2]:-"%s"}" "${_%"${M[7]}x"}"
  else
    # populate cache
#    fmt[0]=1;
    local f b cf c=(b r g y u m c w)
    for f in {0..7}; do fmt[${f}-]="$(tput setaf $f)" fmt[-$f]="$(tput setab $f)"; done
    for f in {0..7}; do
      cf=${c[$f]} fmt[${cf}-]="${fmt[${f}-]}" fmt[-$cf]="${fmt[-$f]}"
      for b in {0..7}; do fmt[$f$b]="${fmt[${f}-]}${fmt[-$b]}" fmt[$cf${c[$b]}]="${fmt[$f$b]}"; done
    done
    fmt[--]="$(tput sgr0)" fmt[__]="$(tput smul)" fmt[di]="$(tput dim)" fmt[bo]="$(tput bold)"
    # follow printf and return 1 if no pattern is given
    return 1
  fi
}
fmt
printf "$L" "%s$(printf "$I%%s%.0s" "${@:2}")"
fmt '^%s$%L(%s)%I, ' a b 'c d'