" https://vi.stackexchange.com/questions/22855/capturing-key-stroke
"
" create <buffer> local maps to overwrite all keys
" use b:var to store the keys pressed, and ttimeout
""" see also
" :help map-which-keys
" :help getchar()

" https://vim.fandom.com/wiki/Capture_all_keys
imap <buffer> <silent> <expr> <F12> Double("\<F12>")
function! Double(mymap)
  try
    let char = getchar()
  catch /^Vim:Interrupt$/
    let char = "\<Esc>"
  endtry
  "exec BPBreakIf(char == 32, 1)
  if char == '^\d\+$' || type(char) == 0
    let char = nr2char(char)
  endif " It is the ascii code.
  if char == "\<Esc>"
    return ''
  endif
  redraw
  return char.char."\<C-R>=Redraw()\<CR>".a:mymap
endfunction

function! Redraw()
  redraw
  return ''
endfunction

fu! ModN(mod)
    return (and(a:mod,  2) ? "S-" : ''). (and(a:mod,  4) ? "C-" : ''). (and(a:mod,  8) ? "A-" : ''). (and(a:mod, 16) ? "M-" : ''). (and(a:mod,128) ? "D-" : '')
endfu
let keys = { "\<Nul>":'Nul', "\<BS>":'BS', "\<Tab>":'Tab', "\<NL>":'NL', "\<CR>":'CR',  "\<Esc>":'Esc', "\<Space>":'Space', "\<lt>":'lt', "\<Bslash>":'Bslash', "\<Bar>":'Bar', "\<Del>":'Del', "\<CSI>":'CSI', "\<EOL>":'EOL', "\<Ignore>":'Ignore', "\<NOP>":'NOP', "\<Up>":'Up', "\<Down>":'Down', "\<Left>":'Left', "\<Right>":'Right', "\<S-Up>":'S-Up', "\<S-Down>":'S-Down', "\<S-Left>":'S-Left', "\<S-Right>":'S-Right', "\<C-Left>":'C-Left', "\<C-Right>":'C-Right',  "\<F1>":'F1', "\<F2>":'F2', "\<F3>":'F3', "\<F4>":'F4', "\<F5>":'F5', "\<F6>":'F6', "\<F7>":'F7', "\<F8>":'F8', "\<F9>":'F9', "\<F10>":'F10', "\<F11>":'F11', "\<F12>":'F12', "\<Help>":'Help', "\<Undo>":'Undo', "\<Insert>":'Insert', "\<Home>":'Home', "\<End>":'End', "\<PageUp>":'PageUp', "\<PageDown>":'PageDown', "\<kUp>":'kUp', "\<kDown>":'kDown', "\<kLeft>":'kLeft', "\<kRight>":'kRight', "\<kHome>":'kHome', "\<kEnd>":'kEnd', "\<kOrigin>":'kOrigin', "\<kPageUp>":'kPageUp', "\<kPageDown>":'kPageDown', "\<kDel>":'kDel', "\<kPlus>":'kPlus', "\<kMinus>":'kMinus', "\<kMultiply>":'kMultiply', "\<kDivide>":'kDivide', "\<kPoint>":'kPoint', "\<kComma>":'kComma', "\<kEqual>":'kEqual', "\<kEnter>":'kEnter', "\<k0>":'k0', "\<k1>":'k1', "\<k2>":'k2', "\<k3>":'k3', "\<k4>":'k4', "\<k5>":'k5', "\<k6>":'k6', "\<k7>":'k7', "\<k8>":'k8', "\<k9>":'k9' }
for x in "\\\"';:abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`1234567890-=~!@#$%^&*()_+,.>"
    for m in range(1, float2nr(pow(2, 4)), 2)
        let M = ModN(m) . x
        let M = escape(M, '"\')
        let M = escape(M, '"\')
        let M = "exe \"let keys[\\\"\\<" .M.">\\\"] = \\\"".M."\\\"\""
        "echom M
        exe M
    endfor
endfor

fu! KeyN(key, mod)
    let extra = substitute(ModN(a:mod), 'A-', '', '')
    let m = has_key(g:keys, a:key)
    if extra != '' || m
        return '<'.extra . (m ? g:keys[a:key]: a:key).'>'
    endif
    return a:key
endfu
nn f :call Echochar()<CR>
fu! Echochar()
    let k = getcharstr()
    let m = getcharmod()
    echom KeyN(k, m)

endfu
