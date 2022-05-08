" Palette: {{{

let g:dracula#palette           = {}
let g:dracula#palette.fg        = ['#{{foreground}}', 253]

let g:dracula#palette.bglighter = ['#454545', 238]
let g:dracula#palette.bglight   = ['#353535', 237]
let g:dracula#palette.bg        = ['#{{background}}', 236]
let g:dracula#palette.bgdark    = ['#{{color0}}', 235]
let g:dracula#palette.bgdarker  = ['#101010', 234]

let g:dracula#palette.comment   = ['#{{color8}}',  61]
let g:dracula#palette.selection = ['#{{cursor}}', 239]
let g:dracula#palette.subtle    = ['#454545', 238]

let g:dracula#palette.cyan      = ['#{{color6}}', 117]
let g:dracula#palette.green     = ['#{{color2}}',  84]
let g:dracula#palette.orange    = ['#{{color9}}', 215]
let g:dracula#palette.pink      = ['#{{color5}}', 212]
let g:dracula#palette.purple    = ['#{{color4}}', 141]
let g:dracula#palette.red       = ['#{{color1}}', 203]
let g:dracula#palette.yellow    = ['#{{color3}}', 228]

"
" ANSI
"
let g:dracula#palette.color_0  = '#{{color0}}'
let g:dracula#palette.color_1  = '#{{color1}}'
let g:dracula#palette.color_2  = '#{{color2}}'
let g:dracula#palette.color_3  = '#{{color3}}'
let g:dracula#palette.color_4  = '#{{color4}}'
let g:dracula#palette.color_5  = '#{{color5}}'
let g:dracula#palette.color_6  = '#{{color6}}'
let g:dracula#palette.color_7  = '#{{color7}}'
let g:dracula#palette.color_8  = '#{{color8}}'
let g:dracula#palette.color_9  = '#{{color9}}'
let g:dracula#palette.color_10 = '#{{color10}}'
let g:dracula#palette.color_11 = '#{{color11}}'
let g:dracula#palette.color_12 = '#{{color12}}'
let g:dracula#palette.color_13 = '#{{color13}}'
let g:dracula#palette.color_14 = '#{{color14}}'
let g:dracula#palette.color_15 = '#{{color15}}'

" }}}

" Helper function that takes a variadic list of filetypes as args and returns
" whether or not the execution of the ftplugin should be aborted.
func! dracula#should_abort(...)
    if ! exists('g:colors_name') || g:colors_name !=# 'dracula'
        return 1
    elseif a:0 > 0 && (! exists('b:current_syntax') || index(a:000, b:current_syntax) == -1)
        return 1
    endif
    return 0
endfunction

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0:
