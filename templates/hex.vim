" syntax highlighting for viewinx xxd hex dumps
" inspired by https://simonomi.dev/blog/color-code-your-bytes/
syn clear
syn match lit00 '\x00'
syn match lit0 '[\x01-\x0f]'
syn match lit1 '[\x10-\x1f]'
syn match lit2 '[\x20-\x2f]'
syn match lit3 '[\x30-\x3f]'
syn match lit4 '[\x40-\x4f]'
syn match lit5 '[\x50-\x5f]'
syn match lit6 '[\x60-\x6f]'
syn match lit7 '[\x70-\x7f]'
syn match lit8 '[\x80-\x8f]'
syn match lit9 '[\x90-\x9f]'
syn match lita '[\xa0-\xaf]'
syn match litb '[\xb0-\xbf]'
syn match litc '[\xc0-\xcf]'
syn match litd '[\xd0-\xdf]'
syn match lite '[\xe0-\xef]'
syn match litf '[\xf0-\xff]'
syn match litff '\xff'
syn match litdot '\.'

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


"TODO hi def link"
hi lit00 guifg=#484848
hi lit0 guifg=#ff76a9
hi lit1 guifg=#ff7877
hi lit2 guifg=#ff862e
hi lit3 guifg=#f99100
hi lit4 guifg=#ec9b00
hi lit5 guifg=#c4b100
hi lit6 guifg=#87c334
hi lit7 guifg=#62c958
hi lit8 guifg=#40cc6d
hi lit9 guifg=#00d08c
hi lita guifg=#00d1bb
hi litb guifg=#00caea
hi litc guifg=#00beff
hi litd guifg=#52b0ff
hi lite guifg=#b693ff
hi litf guifg=#e980e7
hi litff guifg=#ffffff

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

syn region offset start='^' end=':' contains=hex00
syn region Comment start='  ' end='$' contains=lit00,lit0,lit1,lit2,lit3,lit4,lit5,lit6,lit7,lit8,lit9,lita,litb,litc,litd,lite,litf,litff,litdot
