" DO NOT EDIT!! created with ricer template:/Users/caemantoombs/.remote_config/templates/theme.vim
hi clear
if exists("syntax_on")
   syntax reset
endif
let colors_name = "ricer"

" Normal

hi Normal gui=NONE guifg=#fdf6e3 guibg=NONE

" Search

hi IncSearch gui=UNDERLINE guifg=#fdf6e3 guibg=#dc322f
hi Search    gui=UNDERLINE guifg=#fdf6e3 guibg=#dc322f

" Messages

hi ErrorMsg   gui=NONE guifg=#d33682 guibg=NONE
hi WarningMsg gui=NONE guifg=#d33682 guibg=NONE
hi ModeMsg    gui=NONE guifg=#d33682 guibg=NONE
hi MoreMsg    gui=NONE guifg=#d33682 guibg=NONE
hi Question   gui=NONE guifg=#d33682 guibg=NONE

" Split area
hi WildMenu     gui=NONE guifg=#000000 guibg=#b58900
hi StatusLine   gui=NONE guifg=#000000 guibg=#eee8d5
hi StatusLineNC gui=NONE guifg=#002b36 guibg=#eee8d5
hi VertSplit    gui=NONE guifg=#002b36 guibg=#eee8d5

" Diff
hi DiffText     gui=NONE guifg=#ff78f0 guibg=#a02860
hi DiffChange   gui=NONE guifg=#e03870 guibg=#601830
hi DiffDelete   gui=NONE guifg=#a0d0ff guibg=#0020a0
hi DiffAdd      gui=NONE guifg=#a0d0ff guibg=#0020a0

" Cursor

hi Cursor   gui=NONE guifg=#073642 guibg=#eee8d5
hi lCursor  gui=NONE guifg=#073642 guibg=#eee8d5
hi CursorIM gui=NONE guifg=#073642 guibg=#eee8d5

" Fold

hi Folded       gui=NONE guifg=#93a1a1 guibg=#268bd2
hi FoldedColumn gui=NONE guifg=#93a1a1 guibg=#268bd2

" Other
hi Directory    gui=NONE guifg=#c8c8ff guibg=NONE
hi LineNr       gui=NONE guifg=#707070 guibg=NONE
hi NonText      gui=BOLD guifg=#ffffff guibg=NONE
hi SpecialKey   gui=BOLD guifg=#8888ff guibg=NONE
hi Title        gui=BOLD guifg=fg      guibg=NONE

hi Visual    gui=NONE guifg=#657b83 guibg=#b58900
hi VisualNOS gui=NONE guifg=#657b83 guibg=#b58900

" Syntax group
hi Comment      gui=NONE guifg=#eee8d5 guibg=NONE
hi Constant     gui=NONE guifg=#dc322f guibg=NONE
hi Error        gui=BOLD guifg=#cb4b16 guibg=#8000ff
hi Identifier   gui=NONE guifg=#2aa198 guibg=NONE
hi Ignore       gui=NONE guifg=bg      guibg=NONE
hi PreProc      gui=NONE guifg=#dc322f guibg=NONE
hi Special      gui=NONE guifg=#859900 guibg=NONE
hi Statement    gui=NONE guifg=#268bd2 guibg=NONE
hi Todo         gui=BOLD,UNDERLINE guifg=#d33682 guibg=NONE
hi Type         gui=NONE guifg=#859900 guibg=NONE
hi Underlined   gui=UNDERLINE guifg=fg guibg=NONE