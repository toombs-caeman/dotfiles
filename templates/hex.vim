" syntax highlighting for viewinx xxd hex dumps
" inspired by https://simonomi.dev/blog/color-code-your-bytes/
syn clear
syn match hex00 '00'
syn match hex0 '0[1-9a-fA-F]'
syn match hex1 '1[0-9a-fA-F]'
syn match hex2 '2[0-9a-fA-F]'
syn match hex3 '3[0-9a-fA-F]'
syn match hex4 '4[0-9a-fA-F]'
syn match hex5 '5[0-9a-fA-F]'
syn match hex6 '6[0-9a-fA-F]'
syn match hex7 '7[0-9a-fA-F]'
syn match hex8 '8[0-9a-fA-F]'
syn match hex9 '9[0-9a-fA-F]'
syn match hexa '[aA][0-9a-fA-F]'
syn match hexb '[bB][0-9a-fA-F]'
syn match hexc '[cC][0-9a-fA-F]'
syn match hexd '[dD][0-9a-fA-F]'
syn match hexe '[eE][0-9a-fA-F]'
syn match hexf '[fF][0-9a-eA-e]'
syn match hexff '[fF][fF]'
syn region offset start='^' end=':' contains=hex00
syn region Comment start='  ' end='$'
syn match Comment '  [^$]*'
hi hex00 guifg=#484848
hi hex0 guifg=#ff76a9
hi hex1 guifg=#ff7877
hi hex2 guifg=#ff862e
hi hex3 guifg=#f99100
hi hex4 guifg=#ec9b00
hi hex5 guifg=#c4b100
hi hex6 guifg=#87c334
hi hex7 guifg=#62c958
hi hex8 guifg=#40cc6d
hi hex9 guifg=#00d08c
hi hexa guifg=#00d1bb
hi hexb guifg=#00caea
hi hexc guifg=#00beff
hi hexd guifg=#52b0ff
hi hexe guifg=#b693ff
hi hexf guifg=#e980e7
hi hexff guifg=#ffffff
