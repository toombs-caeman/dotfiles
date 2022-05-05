" https://vi.stackexchange.com/questions/22855/capturing-key-stroke
"
" create <buffer> local maps to overwrite all keys
" use b:var to store the keys pressed, and ttimeout
""" see also
" :help map-which-keys
augroup InterceptKeyPress
    autocmd!
    "autocmd InsertCharPre * :let v:char=v:char . v:char
    autocmd InsertCharPre * :let v:char="" . v:char
augroup END

function! ShowMap()
    " open a new buffer and insert the layout
    " create buffer local imap that mirrors all global nmaps (not escape)
    " imap inserts literal keys on the first line

endfunction
