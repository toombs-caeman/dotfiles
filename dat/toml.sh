# define, NOS and TAB file formats
# NOS(nosql) is a non-tabular data format inspired by TOML and Incidental
# TAB(table) is a     tabular data format inspired by Tablatal

# COMMON
# empty lines and comments (starting with '#') are ignored


# TAB
# TAB is a fixed-width format.
# the first row is a header. Header names must follow the bash variable naming convention.
# The spacing of the header determines column width.
# only the last column is not-fixed width

# NOS

# IMPLEMENTATION
# the parsers here are intended to parse TAB and NOS format files into the current shell ENV
# or format the current ENV for TAB or NOS formats.
# This is for ease of programmatic access, but the formats are intended to be human read- and write-able.

# reference:
# TOML https://github.com/toml-lang/toml
# Indental https://wiki.xxiivv.com/site/indental.html
# Tablatal https://wiki.xxiivv.com/site/tablatal.html
# sed https://www.grymoire.com/Unix/Sed.html

# discard empty lines and comments
remove_comments() { sed '/^$/d; /^ *#/d'; }
# trim whitespace at the beginning and end of lines
trim() { sed 's/^ *//; s/ *$//'; }
quote_rhs() {
  # take shell definitions and make sure the right hand side is quoted correctly
  sed "
    # remove whitespace around equals
    s/^\([^= ]*\) *= */\1=/
    # dont alter arrays
    /=(/n
    # escape quotes in value
    s/\"/\\\"/g
    # re-quote
    s/=\(.*\)$/=\"\1\"/
  "
}

# read a toml file into shell variables
# TODO array support
# TODO escape double-quote and quote right side
toml() {
  # parse a micro-toml file into shell variables
  # inspired by
  #   and
  local table_name="${1:-toml_}"
  # input is a terminal
  if [ -t 0 ]; then
    echo '# generating toml'
    # TODO transform shell variables to reasonable toml
    set | rg "^$table_name" -r ''
  else
    # transform toml into shell variables suitable to eval
    # TODO make sure right hand side is quoted but not triple quoted
    echo '# generating env'
    remove_comments | sed -n "
      # match section header
      /^ *\[.*\] *$/ {
        # strip out whitespace and brackets
        s/^ *\[ *\([^ ]*\) *\] *$/\1/
        # replace . in section name with _
        s/\./_/g
        # add to hold space and goto top
        x; d
      }
      # remove spaces around equal sign.
      s/ *= */=/
      # append section name (in hold space) to pattern space.
      G
      # if a section hasn't been defined yet (top-level value), then table_name and print
      s/^ *\(.*\)\n$/$table_name\1/p
      # put table_name and section in front, then print.
      s/^ *\(.*\)\n\(..*\)$/$table_name\2_\1/p
    "
  fi
}

echo '
title = TOML Example

[owner]
name = Tom "Marvolo" Riddle
dob = 1979-05-27T07:32:00-08:00

[database]
# a list of 3 values
port : [ 8000, 8001, "port, 3" ]
# a string
port_string = [ 8000, 8001, "port, 3" ]
server = 192.168.1.1
connection_max= 5000
enabled =true

[servers]
  # Indentation (tabs and/or spaces) is allowed but not required
  [servers.alpha]
  ip = 10.0.0.1
  dc = eqdc10

  [servers.beta]
  ip 10.0.0.2
  dc eqdc10

' | toml '' >/dev/null
_table() {
  # load header data
  # returns table_max_id=0 table_fields=() widths=() and table_offsets=()
  table_max_id=0 table_fields=() table_offsets=() table_widths=()
  local header offset=0
  # split header into table_fields containing whitespace by inserting and splitting on ZWSP (U+200)
  # ZWSP is in IFS and after \1
  IFS='​' read -ra header < <(sed 's/\([^ ]* *\)/\1​/g')
  for field in "${header[@]}"; do
    table_widths+=("${#field}")
    table_offsets+=("$offset")
    offset=$(( offset + ${#field} ))
  done
  # use word splitting to strip space from headers
  table_fields=( ${header[*]} )
  # let the last field be large
  table_widths[$((${#table_fields[@]} - 1))]=9999
  # get number of rows from the max numbered row that has values defined
  table_max_id="$(set | sed -n "s/^${table_name}_\([0-9][0-9]*\).*$/\1/p" | sort | tail -n1)"
}
table() {
  # parse a table file into shell variables like "${table_name}_${row_id}_${col}"
  # values are fixed with
  # input is expected to start with a header row which defines

  table_name="${1:-table}"
  if [ -t 0 ]; then
    # input is a terminal, so parse env to tbl
    local raw_header value
    # double expand variable to get raw header
    eval "raw_header=\"\$${table_name}_header\""
    printf '%s\n' "$raw_header"
    _table < <(printf '%s\n' "$raw_header")
    for row in $( seq 0 "$table_max_id" ); do
      # enumerate all but the last field
      for i in $(seq 0 $(( ${#table_fields} - 2)) ); do
        eval "value=\"\$${table_name}_${row}_${table_fields[$i]}\""
#        printf "%s|" "${table_widths[$i]}" "$value"
        printf "%-${table_widths[$i]}.${table_widths[$i]}s" "$value"
      done
      # print the last field separately, since it can be arbitrarily long. also do newline
      i=$(( i + 1))
      eval "value=\"\$${table_name}_${row}_${table_fields[$i]}\""
      printf "%s\n" "$value"
    done
  else
    # a file is being piped into us, parse TAB to ENV
    # read the first line of input as the header. copy to output
    local raw_header; IFS= read -r raw_header
    printf "%s_header=%s" "$table_name" "$raw_header" | quote_rhs
    # parse table metadata from header
    _table < <(printf '%s\n' "$raw_header")
    # read and count each line
    local count=0
    while IFS= read -r line; do
      # enumerate the table_fields
      for i in $(seq 0 $(( ${#table_fields} - 1)) ); do
        value="$(echo "${line:${table_offsets[$i]}:${table_widths[$i]}}" | trim)"
        printf '%s_%s_%s=%s\n' "$table_name" "$count" "${table_fields[$i]}" "$value"
      done| quote_rhs
      # TODO also set "${table_name}_${count}=(...)"
      # increment line count
      count=$(( count + 1))
    done < <(remove_comments)
  fi
}
#eval "$(table table < test.tbl)"
eval "$(table table < test.tbl)"
# renaming headers will reorder, resize, or duplicate columns
# TODO can we also add a column by setting headers? doesn't seem to work
#table_header="died   died    born color category name"
table
