# separate TAB into 3
# TAB is human readable. It is the data at rest
# bTAB is 'binary' in that spaces are trimmed to SEP
# DATA is the shell format, which should be compatible between TAB and NOS

# TODO row api: edit/access from memory
# TODO 'in memory' vs 'streaming' api. edit vs query
# TODO distinguish (t tload), which can start and end a pipe from others
# TODO factor out indirection evals into generalized get/set for values
#   `V table 0 field value`

# API: t tload tcol trows

t() {
  # TODO make sure _func variables are local to here
  # select which table to use (if input is var)
  local prefix="${1:-T}"
  local ifmt ofmt; _t
  local header fields offsets widths; _header
  local row_count=0
  # copy input to output
  # make sure to run raw input through the preprocessor
  while _read_row; do _write_row; done < <(_preprocessor)
 }

tload() {
  # select which table to use (if input is var)
  local prefix="${1:-T}"
  local ifmt ofmt; _t
  local header fields offsets widths; _read_header
  # adjust output format to eval if we're writing into a terminal
  # or pretty print if we're writing to a file
  if [ -t 1 ] && ! [ -t 0 ]; then
    ofmt=var
    _write_header
    eval "$(
      _preprocessor |
      while _read_row; do _write_row; done |
      sed "
      # make sure shell definitions are valid
      # remove whitespace around equals
      s/^\([^= ]*\) *= */\1=/
      # dont alter arrays
      /=(/n
      # escape quotes in value
      s/\"/\\\"/g
      # re-quote
      s/=\(.*\)$/=\"\1\"/
    ")"
  else
    ofmt=tab
    while _read_row; do _write_row; done < <(_preprocessor)
  fi
  local row_count=0
 }

tcols() {
  # select a subset of columns
  # TODO allow column reference by name or number
  # https://stackoverflow.com/questions/15028567/get-the-index-of-a-value-in-a-bash-array
  local IFS=','
  cut -d"$SEP" -f "$*";
}
trows() {
  # select a number of rows by number. use posix ranges (like: {1..5})
  # TODO test
  local ifmt ofmt; _t
  case "$ifmt" in
    var) local prefix="$1"; shift ;;
  esac
  local header fields offsets widths; _header
  while _read_row; do
    case " $* " in *" $row_count "*) _write_row;; esac
  done < <(_preprocessor)
 }
tfilter() {
  # TODO tfilter col=val
  local prefix="${1:-T}"
  local ifmt ofmt; _t
  local header fields offsets widths; _header
  local row_count=0
  # copy input to output
  # make sure to run raw input through the preprocessor
  while _read_row; do _write_row; done < <(_preprocessor) | grep "$@"
}
# UTIL

# use non-printable character that won't be in input as separator
readonly SEP="$(printf '\001')"
# print an array in btab
bprint() { local IFS="$SEP"; printf '%s\n' "$*"; }

# PRE

_t() {
  # determine and output formats (ifmt and ofmt) based on where stdin and stdout are connected
  # these are set to one of tab, btab, or var
  ifmt= ofmt=
  if [ -t 0 ]; then ifmt=var; else ifmt=tab;  fi  # read from shell variables if there's no input on stdin
  if [ -t 1 ]; then ofmt=tab; else ofmt=btab; fi  # pretty print if going to a terminal
}
# determine input and output formats suitable between shell and disk
_tload() {
  ifmt= ofmt=
  # if reading from term, use var format, else pipe format
  # we can't actually determine yet if ifmt=tab or ifmt=btab, but _read_header will sort us if we assume tab
  if [ -t 0 ]; then ifmt=var; else ifmt=pipe; fi              # read from shell variables if there's no input on stdin
  # pipe -> term : var
  # otherwise : tab
  if [ -t 1 ] && ! [ -t 0 ]; then ofmt=var; else ofmt=tab; fi # if we're writing to a terminal
 }

# read header from input, loading variables and copy to output.
_header() { _read_header; _write_header; }
# read header from input
_read_header() {
  header=() fields=() offsets=() widths=()
  case "$ifmt" in
    # eval is portable (but unsafe) indirection
    var)  IFS= read -r header < <(eval "echo \"\$${prefix}_header\"") ;;
    *) IFS= read -r header ;;
  esac
  case "${header}" in
    *"$SEP"*)
      ifmt=btab
      IFS="$SEP" read -ra header < <(echo "${header}")
      ;;
    *)
      # header needs to be resplit because it's a TAB format, not bTAB
      IFS="$SEP" read -ra header < <(echo "${header}" | sed "s/\([^ ]* *\)/\1$SEP/g")
      # drop the last item (which is now empty)
      header=( "${header[@]:0:${#header[@]}}" )
      ;;
  esac
  local offset=0
  for field in "${header[@]}"; do
    widths+=("${#field}")
    offsets+=("$offset")
    offset=$(( offset + ${#field} ))
  done
  # use word splitting to strip space from headers
  fields=( ${header[*]} )
  # let the last field be large
  widths[$((${#header[@]} - 1))]=9999
}

# clean input from disk
# remove empty lines and comments
# TODO allow escaped (#) as a value
_preprocessor() { sed '/^$/d; /^ *#/d'; }

_read_row() {
  # read a $row, or return !0
  row=() row_count
  local ret
  case "$ifmt" in
    btab) IFS="$SEP" read -ra row; ret=$? ;;
    tab)
      # read one row in TAB format
      local line
      IFS= read -r line; ret=$?
      for f in $(seq 0 $(( ${#header[@]} - 1)) ); do
          # sed removes whitespace at end of field
          row+=("$(echo "${line:${offsets[$f]}:${widths[$f]}}" | sed 's/ *$//';)")
      done
      ;;
    var)
      local value
      ret=1
      for f in $(seq 0 $(( ${#header} - 1)) ); do
        # portable (but unsafe) indirection
        eval "value=\"\$${prefix}_${row_count}_${fields[$f]}\""
        row+=("$value")
        # if we find a value for even a single column then the row is considered ok
        [ -n "$value" ] && ret=0
      done
      ;;
  esac
  (( ret )) || row_count=$((row_count + 1))
  return $ret
}

# POST
_write_header() {
  case "$ofmt" in
    tab) printf '%s\n' "${header[*]}"; ;;
    # include extra SEP at the end to mark it as btab
    btab) bprint "${header[@]}" '';;
    var) IFS='' printf '%s_header=%s\n' "$prefix" "${header[*]}";;
  esac
}
_write_row() {
  case "$ofmt" in
    btab) bprint "${row[@]}" ;;
    tab)
      local f
      for f in $(seq 0 $(( ${#header[@]} - 2)) ); do
        printf "%-${widths[$f]}.${widths[$f]}s" "${row[$f]}"
      done
      # print the last field separately, since it can be arbitrarily long. also do newline
      printf "%s\n" "${row[$((f+1))]}"
      ;;
    var)
      for f in $(seq 0 $(( ${#header[@]} - 1)) ); do
        printf '%s_%s_%s=%s\n' "$prefix" "$row_count" "${fields[$f]}" "${row[$f]}"
      done
      ;;
  esac
}
T_test() {
  echo '# ****** test *******'
#  echo "# bTAB=$bTAB"
#  echo "# row_count=$row_count"
  log "${header[@]}"
#  echo "# header=${fields[*]}"
#  echo "# widths=${widths[*]}"
  echo "# i=$ifmt o=$ofmt"
  echo '# **** end test *****'
}
echo "** var **"
T_rw '' < test.tbl
echo "** TAB **"
T_rw '' < test.tbl | cat -
echo "** bTAB | cut **"
T '' < test.tbl | cut -d"$SEP" -f 2,4 #| tr "$SEP" "|"

echo "** bTAB | cut | TAB **"
T '' < test.tbl | cut -d"$SEP" -f 2,4 | T

echo "** bTAB | cut | sh **"
T '' < test.tbl | cut -d"$SEP" -f 2,4 | T_rw

#T_test
