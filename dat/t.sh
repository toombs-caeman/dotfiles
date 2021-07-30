
t() {
  local op="$1"; shift 2>/dev/null
  local ofmt=_t_fmt_sep row_count=0
  # pretty print to a terminal
  [ -t 1 ] || [ -z "$op" ] && ofmt=_t_fmt_fixed
  local head offset width ifmt
  # remove empty lines and comments
  sed '/^$/d; /^ *#/d' | {
    case "$op" in
      # todo grep by field
      grep) _head; _body | grep "$@" ;;
      sort) _head; _body | sort -t"$SEP" ${*:+-k} "$@" ;;
      head) _head; _body | head -n "$@" ;;
      tail) _head; _body | tail -n "$@" ;;
      v|val|values) # don't print head
        _head >/dev/null
        if [ -n "$*" ]; then _body | cut -f "$@" -d"$SEP"; else _body; fi
        ;;
      c|col|cols) { _head; _body; } | cut -f "$@" -d"$SEP" ;;
      r|row|rows) _head; while _read_row; do case " $* " in *" $row_count "*) _write_row;; esac; done ;;
      resize) ;; # TODO change width
      reorder)
        # todo reorder rows (cut doesn't)
        _head >/dev/null
        local new_row=() new_header=()
        for i in "$@"; do
          new_header+=("${head[$1]}")
        done
        $ofmt "${new_header[@]}"
        while _read_row; do
          for i in "$@"; do
            new_row+=("${row[$1]}")
          done
        done
        ;;
      *)
        # extra decoration if it's a terminal
        if [ -t 1 ]; then
          echo extra
          _head >/dev/null
          $ofmt "${head[@]}" | sed 's/[^ ]/=/g'
          _body
          $ofmt "[$row_count x ${#head[@]}]"
        else
          echo extra
          _head
          _body
        fi
        ;;
    esac
  }
}

# use any character not expected to be in input
SEP="$(printf '\001')"
# print an array using $SEP as the separator
_t_fmt_sep() { local IFS="$SEP"; printf '%s\n' "$*"; }
# print a fixed ${width[@]} array. let the last field run long
_t_fmt_fixed() {
  local f=-1 args=("$@")
#  echo "#${args[*]}#"
  if (( ${#args[@]} > 1)); then
    for f in $(seq 0 $(( ${#args[@]} - 1)) ); do
      printf "%-${width[$f]}.${width[$f]}s" "${args[$f]}"
    done
  fi
  printf "%s\n" "${args[$((f+1))]}"
}
_head() { _read_head; _write_head; }
_body() { while _read_row; do _write_row; done; }
_write_head() { $ofmt "${head[@]}"; $ofmt "${width[@]}"; }
_write_row() { $ofmt "${row[@]}"; }
_read_head() {
  head=() offset=() width=() ifmt=
  local f
  IFS= read -r head
  case "$head" in
    *"$SEP"*)
      ifmt=_t_fmt_sep
      IFS="$SEP" read -ra head < <(printf '%s\n' "$head")
      IFS="$SEP" read -ra width
      ;;
    *)
      ifmt=_t_fmt_fixed
      # head needs to be resplit because it's a fixed-width format, not sep
      # shellcheck disable=SC2001
      IFS="$SEP" read -ra head < <(sed "s/\([^ ]* *\)/$SEP\1/g" <<<"$head")
      # drop the extra element introduced by sed above
      head=("${head[@]:1}")
      # count width of head and trim it
      for f in "${head[@]}"; do
        head+=("${f%% *}")
        width+=("${#f}")
      done
      # trim head back, since we appended earlier
      head=("${head[@]:${#width[@]}}")
      ;;
  esac
  # pre-calculate offset
  local w o=0
  for w in "${width[@]}"; do
    offset+=("$o")
    o=$(( o + w ))
  done
#  echo "#${head[*]}#"
#  echo "#${width[*]}#"
#  echo "#${offset[*]}#"
}
_read_row() {
  # read a $row and increment $row_count, or return !0
  row=()
  local ret line f v
  case "$ifmt" in
    _t_fmt_sep) IFS="$SEP" read -ra row; ret=$? ;;
    _t_fmt_fixed)
      IFS= read -r line; ret=$?
      for f in $(seq 0 $(( ${#head[@]} - 2)) ); do
          v="${line:${offset[$f]}:${width[$f]}}"; row+=("${v%% }")
      done
      # read last field separately to let it be arbitrarily long
      v="${line:${offset[$((f+1))]}}"; row+=("${v%% }")
      ;;
  esac
  (( ret )) || row_count=$((row_count + 1))
  return $ret
}


log () {
  printf '\n%s\n' "$*"
}
log pretty print
t < test.tbl

log normal print
t grep '' < test.tbl | cat -

exit
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
