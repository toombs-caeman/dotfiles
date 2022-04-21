# xargs for shell functions
map() {
  local i idx=(0) n nargs=() a argv=()
  for ((i=1; i <= $#; i++)); do
    case "${!i}" in
      {}) n+=1 ;;
      \;) idx+=($i); nargs+=($n); n=0 ;;
      --) argv=("${@:$((i + 1))}"); set -- "${@:1:$((i - 1))}"; break ;;
    esac
  done
  idx+=($i); nargs+=($n)
  local
  if (( ${#argv} )); then
    for a in "${argv[@]}"; do
      for ((i=0; i + 1 < ${#idx[@]}; i++)); do
      cmd=("${@:$((${idx[$i]} + 1)):$((${idx[$(($i + 1))]} - ${idx[$i]} - 1))}")
      echo "arg: ${cmd[@]//"{}"/"${a}"}"
      done
    done
  else
    while read a; do
      for ((i=0; i + 1 < ${#idx[@]}; i++)); do
      cmd=("${@:$((${idx[$i]} + 1)):$((${idx[$(($i + 1))]} - 1))}")
      echo "read: ${cmd[@]//"{}"/"${a}"}"
      done
    done
  fi
}

map echo {} {} -- a b c  #  'a b\nc\n'