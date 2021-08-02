args() {
  while (( $# )); do
    echo "arg=($1)"
    case "$1" in
      -join) # read from a new file, copy stdin too if not a terminal
        ;;
      -ifs) # set input IFS, to join tsv or csv files
        ;;
      -sql) # join from a database
        ;;
      -*=*) # column='regex' filter by column value
        ;;
      -head) # head
        ;;
      -tail) # tail
        ;;
      -sort) ;;
      -uniq)
        ;;
    esac
    shift
  done
}
idx() {
  # usage: idx val "${array[@]}"
  # echos the the index of a value in an array or returns 1
  local value="$1"; shift; local i=$#
  while (( $# )); do [ "$1" = "$value" ] && printf '%s\n' "$((i-$#))" && return 0 || shift; done
  return 1
}
fmt() {
  # extend printf to better handle arrays by having separate patterns for field, line and IFS
  # fmt -s S -l 'L%sL\n' -f 'F%sF' -- a b c
  # 'LFaFSFbFSFcFL\n'
  local arg args=() fargs=() f="%s" s=" " l="%s\n"
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
  # this can be used to do `fmt "$@" | echo default`
  [ ${#args[@]} = 0] && return 1
  if [ "$f" = '%s' ]; then
    fargs=("${args[@]}")
  else
    for arg in "${args[@]}"; do fargs+=("$(printf "$f" "$arg")"); done
  fi
  local IFS="$s"
  printf "$l" "${fargs[*]}"
}

t() {
  local op="$1"; shift 2>/dev/null
  if [ -t 1 ] || [ -z "$op" ]; then
    # if the output is a terminal or no command is specified
    # then display in column format
    _t "$op" "$@" | column -t -s "$SEP"
  else
    _t "$op" "$@"
  fi
}
SEP="$(printf '\001')" # use non-printing character not expected in input
# use any character not expected to be in input
# print an array using $SEP as the separator
_t_fmt_sep() { local IFS="$SEP"; printf '%s\n' "$*"; }
_t_fmt_sep() { fmt -s "$SEP" -- "$@"; }
_t_parse_ref() {
  while (( $# )); do
    idx "$1" "${head[@]}" || printf '%s\n' "$1"
    shift
  done
}
# TODO pre: from_sql from_tab from_csv from_tsv join insert
# TODO inline: match unique columns
# TODO final: pretty_print sort
_t() {
  local head width offset ifmt
  # remove empty lines and comments
  sed "/^$/d; /^ *#/d" | {
    case "$op" in
      # todo grep by field
      sql|from_sql)
        local db="$1"; shift
        sqlite3 "$db" -separator "$SEP" -header <<<"$@"
        ;;
      # `t filter 2 '.*\.sh'` -> return rows where column 2 match regex `.*\.sh`

      f|filter)
      # todo allow multiple column_name='regex' type parameters
      while (( $# )); do
        case "$1" in
          *=*) regex+=("$(sed 's,=\(.*\)$,\n ~ /\1/' <<<"$1")") ;;
          *) fields+=("$1") ;;
        esac
      done
      regex=($(_t_parse_ref "${regex[@]}"))
      fields=($(_t_parse_ref "${fields[@]}"))
      unique=()
      { _head; _body; } | awk -F "$SEP" "
        NR==1 || ( $(fmt -l '%s' -s ' && ' -- "$(_t_parse_ref "${regex[@]}")" || printf '1') && $(fmt -l '!_[%s]++' -f '$%s' -- "${uniq[@]}" || printf '1')) {print $(fmt -l '%s' -f '$%s' ${fields[@]})}
"
       ;;
#      grep) _head; _body | grep "$@" ;;
      s|sort) _head; _body | sort -t"$SEP" ${*:+-k} "$@" ;;
      v|val|values) # don't print head, otherwise do the same as `columns`
        {_head >/dev/null;   _body; } | awk -F "$SEP" "{print $(printf '$%s ' $(_t_parse_ref "$@"))}" ;;
      c|col|columns) {_head; _body; } | awk -F "$SEP" "{print $(printf '$%s ' $(_t_parse_ref "$@"))}" ;;
      r|row|rows) _head; _body | awk -F "$SEP" "$(printf 'NR==%s;' "$@")}" ;;
      head) _head; _body | head -n "$@" ;;
      tail) _head; _body | tail -n "$@" ;;
      # https://stackoverflow.com/questions/1915636/is-there-a-way-to-uniq-by-column
      uniq) _head; _body | awk -F"$SEP" '!_[$1]++' ;;
      *) cat - ;; # default just pass through
    esac
  }
}
awk "
$(fmt -l '%s' -s ' && ' -f '$%s ~ /%s/' -- "${regex[@]}" || printf '1') && $(fmt -l '!_[%s]++' -f '$%s' -- "${uniq[@]}" || printf '1') {print $(fmt -l '%s' -f '$%s' ${fields[@]})}
"

_head() {
  head=() width=() offset=() ifmt=
  local f
  IFS= read -r head
  case "$head" in
    *"$SEP"*)
      ifmt=_t_fmt_sep
      IFS="$SEP" read -ra head < <(printf '%s\n' "$head")
      ;;
    *)
      ifmt=_t_fmt_fixed
      # head needs to be re-split, but sed introduces an extra separator at the start, so drop that right after
      IFS="$SEP" read -ra head < <(sed "s/\([^ ]* *\)/$SEP\1/g" <<<"$head")
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
  esac
  _t_fmt_sep "${head[@]}";
}
_body() {
  case "$ifmt" in
    _t_fmt_sep) cat -;; # already formatted correctly
    _t_fmt_fixed) # parse using a fixed column width
      local line f v
      while IFS= read -r line; do
        row=()
        for f in $(seq 0 $(( ${#head[@]} - 2)) ); do
            v="${line:${offset[$f]}:${width[$f]}}"
            row+=("${v%% }")
        done
        # read last field separately to let it be arbitrarily long
        v="${line:${offset[$((f+1))]}}"
        row+=("${v%% }")
        _t_fmt_sep "${row[@]}"
      done
      ;;
  esac
}


log () {
  printf '\n%s\n' "$*"
}
log pretty print
t < test.tbl

log normal print
t grep '' < test.tbl | cat -

log first row
t head 1 < test.tbl

log only rows
t v < test.tbl

#log only rows using SEP
#t v < test.tbl | cat -

log default sort
t sort < test.tbl | t

log sort by name pretty print
t sort 4 < test.tbl | t c 1,4 | t
