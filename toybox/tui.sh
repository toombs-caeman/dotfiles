# TUI?

# CURSOR
# read cursor position
puc=(0 0)
puc() { local _; echo -ne $'\E[6n'; read -s -d\[ _; IFS=';' read -sdR puc[0] puc[1]; puc[0]=$((puc[0]-1)); puc[1]=$((puc[1]-1)); }
# cursor stack
pushc() { puc; puc+=("${puc[@]:0:2}"); }
popc() { pop puc puc[1]; pop puc puc[0]; tput cup "${puc[@]:0:2}"; }

# BOX DRAWING
boxchar=( \
    ' ' '╵' '╹' ' ' '╶' '└' '┖' '╙' '╺' '┕' '┗' ' ' ' ' '╘' ' ' '╚' \
    '╷' '│' '╿' ' ' '┌' '├' '┞' ' ' '┍' '┝' '┡' ' ' '╒' '╞' ' ' ' ' \
    '╻' '╽' '┃' ' ' '┎' '┟' '┠' ' ' '┏' '┢' '┣' ' ' ' ' ' ' ' ' ' ' \
    ' ' ' ' ' ' '║' '╓' ' ' ' ' '╟' ' ' ' ' ' ' ' ' '╔' ' ' ' ' '╠' \
    '╴' '┘' '┚' '╜' '─' '┴' '┸' '╨' '╼' '┶' '┺' ' ' ' ' ' ' ' ' ' ' \
    '┐' '┤' '┦' ' ' '┬' '┼' '╀' ' ' '┮' '┾' '╄' ' ' ' ' ' ' ' ' ' ' \
    '┒' '┧' '┨' ' ' '┰' '╁' '╂' ' ' '┲' '╆' '╊' ' ' ' ' ' ' ' ' ' ' \
    '╖' ' ' ' ' '╢' '╥' ' ' ' ' '╫' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' \
    '╸' '┙' '┛' ' ' '╾' '┵' '┹' ' ' '━' '┷' '┻' ' ' ' ' ' ' ' ' ' ' \
    '┑' '┥' '┩' ' ' '┭' '┽' '╃' ' ' '┯' '┿' '╇' ' ' ' ' ' ' ' ' ' ' \
    '┓' '┪' '┫' ' ' '┱' '╅' '╉' ' ' '┳' '╈' '╋' ' ' ' ' ' ' ' ' ' ' \
    ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' \
    ' ' '╛' ' ' '╝' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' '═' '╧' ' ' '╩' \
    '╕' '╡' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' '╪' ' ' ' ' \
    ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' \
    '╗' ' ' ' ' '╣' ' ' ' ' ' ' ' ' ' ' ' ' ' ' '╦' ' ' ' ' ' ' '╬')
boxchar() {
    # <top> <right> <bottom> <left> <var>
    # empty=0 line=1 bold=2 double=3
    # [box characters](https://en.wikipedia.org/wiki/Box-drawing_character)
    printf ${5:+-v} $5 "${boxchar[$(($1+4*$2+16*$3+64*$4))]}"
}
box() { pushc; tput cup "$(($1+$3))" "$2"; _box "${@:3}"; popc; }
# box <sx> <sy> <style>
_box() {
    local vc hc
    boxchar "$3" 0 "$3" 0 vc
    boxchar 0 "$3" 0 "$3" hc
    pushc # save the position of the bottom left corner
    boxchar "$3" "$3" 0 0 # draw bottom left corner
    fmt "$(($1-1))%r%Tu1%Tl1%s%j%s%Tu1%Tl1" "$vc" # draw left line (moving up)
    boxchar 0 "$3" "$3" 0 # draw top left corner
    fmt "$(($2-1))%r" "$hc" # draw top line
    boxchar 0 0 "$3" "$3" # draw top right corner
    popc # back down to the bottom left
    fmt "$(($2-1))%r%j%Tr1%s" "$hc" # draw bottom line
    boxchar "$3" 0 0 "$3" # draw bottom right corner
    fmt "$(($1-1))%r%Tu1%Tl1%s" "$vc" # draw right line (moving up)
}

