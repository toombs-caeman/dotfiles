readarray() {
  if config zsh; then
    read -A "$@"
  else
    read -a "$@"
  fi
}
idx() {
  # usage: idx val "${array[@]}"
  # print the the index of a value in an array or returns 1
  local value="$1"; shift; local i=$#
  while (( $# )); do [ "$1" = "$value" ] && printf '%s\n' "$((i-$#))" && return 0 || shift; done
  return 1
}
fmt() {
  # printf with separate formats for for field, line and IFS
  local arg args=() line='' l='%s\n' s=' ' f='%s'
  while (( $# )); do
    case "$1" in
      -l) shift; l="$1" ;;
      -s) shift; s="$1" ;;
      -f) shift; f="$1" ;;
      --) shift; args+=("$@"); break ;;
      *) args+=("$1") ;;
    esac
    shift
  done
  # return 1 if there aren't any arguments instead of printing an empty line
  # this can be used to do `fmt "$@" || printf default`
  ((${#args[@]})) || return 1
  line="$(printf "$f" "${args[@]:0:1}")"
  for arg in "${args[@]:1}"; do line="$line$(printf "$s$f" "$arg")"; done
  printf "$l" "$line"
}

t() {
  # TODO parse args
  local files=() sort=() uniq=() limit=0 regex=() output_fields=()
  while (( $# )); do
    arg_rhs="$(sed "s/^[^=]*=//" <<<"$1")"
    case "$1" in
      -j=*|-join=*) files+=("$arg_rhs") ;;
      -s=*|-sort=*) sort+=("$arg_rhs") ;;
      -u=*|-uniq=*) uniq+=("$arg_rhs") ;;
      -l=*|-limit=*) limit="$arg_rhs" ;;
      *=*) regex+=("$(sed 's/=.*$//' <<<"$1") ~ /$arg_rhs/") ;;
      *) output_fields+=("$1") ;;
    esac
    shift
  done
  [ -t 0 ] || files=('/dev/stdin' "${files[@]}")
  {
    sep="$(printf '\001')" isep="$sep" first=1
    for file in "${files[@]}"; do
      exec 3<> "$file" # open descriptor for file
      IFS= read -r head <&3
      case "$head" in
        *"$sep"*) isep="$sep" ;;
        *$'\t'*) isep="$(printf '\t')" ;;
        *,*) isep=, ;;
        *) isep=fixed ;;
      esac
      case "$isep" in
        fixed)
          # head needs to be re-split, but sed introduces an extra separator at the start, so drop that right after
          IFS="$sep" readarray -r head < <(sed "s/\([^ ]* *\)/$sep\1/g" <<<"$head")
          head=("${head[@]:1}")
          # count width of each field and then trim the whitespace
          local o=0
          for f in "${head[@]}"; do
            head+=("${f%% *}")
            width+=("${#f}")
            offset+=("$o")
            o=$(( o + ${#f} ))
          done
          # drop the part of head that includes spaces, since we just appended earlier
          head=("${head[@]:${#width[@]}}")
          ;;
        *)
          IFS="$isep" readarray -r head <<<"$head"
          ;;
      esac
      if (( first )); then
        fmt -s "$sep" -- "${head[@]}"
        first=0
      fi
      case "$isep" in
        fixed)
          awk -v FIELDWIDTHS="${width[*]}" "BEGIN { OFS=\"$sep\" }; !/^ *(#.*)$/ { gsub(/ *$/,\"\"); print; }" <&3
#          while IFS= read -r line; do
#            [ -z "${line/*#*}" ] && continue
#            row=()
#            local f
#            for f in $(seq 0 $(( ${#head[@]} - 2)) ); do
#                v="${line:${offset[$f]}:${width[$f]}}"
#                row+=("${v%% }")
#            done
#            # get last field separately to let it be arbitrarily long
#            v="${line:${offset[$((f+1))]}}"
#            row+=("${v%% }")
#            IFS="$sep" fmt -- "${row[@]}"
#          done <&3
          ;;
        *) tr "$isep" "$sep" <&3 ;;
      esac
      exec 3>&- # close file
    done
  } | {
  # apply regex filters, unique constraints and output fields
  awk -F "$sep" "NR==1 || ($(fmt -s ' && ' -l '%s' -- "${regex[@]}" || printf '%s' '1') && $(
            fmt -l '!_[%s]++' -f '$%s' -- "${uniq[@]}" || printf '%s' '1'
            )) {print $(fmt -l '%s' -f '$%s' ${output_fields[@]})}"
  } | {
    if (( ${#sort[@]} )); then
      IFS= read -r head; printf '%s\n' "$head"
      sort -t"$sep" "$(fmt -l '-k %s' "${sort[@]}")"
    else cat -; fi
  } | {
    if ((limit)); then head -n $((limit + 1)); else cat -; fi
  } | {
    # if the output is a terminal or no command is specified
    # then display in column format
    if [ -t 1 ] || [ -z "$op" ]; then column -t -s "$sep"; else cat -; fi
  }
}

t_test() {
  # TODO parse args
  local files=() sort=() uniq=() limit=0 regex=() output_fields=()
  local sep="$(printf '\001')" isep="$sep"
  while (( $# )); do
    arg_rhs="$(sed "s/^[^=]*=//" <<<"$1")"
    case "$1" in
      -j=*|-join=*) files+=("$arg_rhs") ;;
      -s=*|-sort=*) sort+=("$arg_rhs") ;;
      -u=*|-uniq=*) uniq+=("$arg_rhs") ;;
      -l=*|-limit=*) limit="$arg_rhs" ;;
      *=*) regex+=("\$$(sed 's/=.*$//' <<<"$1") ~ /$arg_rhs/") ;;
      *) output_fields+=("$1") ;;
    esac
    shift
  done
  [ -t 0 ] || files=('/dev/stdin' "${files[@]}")
  printf '%s ' awk -F "$sep" "$(
    fmt -s ' && ' -l '%s' -- "${regex[@]}" || printf '%s' '1') && $(
            fmt -l '!_[%s]++' -f '$%s' -- "${uniq[@]}" || printf '%s' '1'
            ) {print $(fmt -l '%s' -f '$%s' ${output_fields[@]})}"
}