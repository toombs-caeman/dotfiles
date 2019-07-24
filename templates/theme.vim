" {{msg}}
hi clear
if exists("syntax_on")
   syntax reset
endif
let colors_name = "ricer"

{% macro hi(names=[], fg='NONE', bg='NONE', style='NONE') -%}
{% set j= names | map('length') | max %}
{% if fg != 'NONE' -%}
        {% set fg='#'~fg -%}
{% endif -%}
{% if bg != 'NONE' -%}
        {% set bg='#'~bg -%}
{% endif -%}
{% for name in names -%}
hi {{name.ljust(j)}} gui={{style}} guifg={{fg}} guibg={{bg}}
{% endfor -%}
{% endmacro -%}

" Normal
{{ hi(['Normal'], white) }}
" Search
{{ hi(['IncSearch','Search'], white, red, 'UNDERLINE' ) }}
" Messages
{{ hi([ 'ErrorMsg', 'WarningMsg', 'ModeMsg', 'MoreMsg', 'Question' ], magenta) }}
" Split area
hi WildMenu     gui=NONE guifg=#{{trueblack}} guibg=#{{yellow}}
hi StatusLine   gui=NONE guifg=#{{trueblack}} guibg=#{{lgray}}
hi StatusLineNC gui=NONE guifg=#{{gray}} guibg=#{{lgray}}
hi VertSplit    gui=NONE guifg=#{{gray}} guibg=#{{lgray}}

" Diff
hi DiffText     gui=NONE guifg=#ff78f0 guibg=#a02860
hi DiffChange   gui=NONE guifg=#e03870 guibg=#601830
hi DiffDelete   gui=NONE guifg=#a0d0ff guibg=#0020a0
hi DiffAdd      gui=NONE guifg=#a0d0ff guibg=#0020a0

" Cursor
{{ hi(['Cursor', 'lCursor', 'CursorIM'], black, lgray)}}
" Fold
{{ hi(['Folded', "FoldedColumn"], lcyan, blue) }}
" Other
hi Directory    gui=NONE guifg=#c8c8ff guibg=NONE
hi LineNr       gui=NONE guifg=#707070 guibg=NONE
hi NonText      gui=BOLD guifg=#{{truewhite}} guibg=NONE
hi SpecialKey   gui=BOLD guifg=#8888ff guibg=NONE
hi Title        gui=BOLD guifg=fg      guibg=NONE
{{ hi (['Visual', 'VisualNOS'], lyellow, yellow) }}
" Syntax group
hi Comment      gui=NONE guifg=#{{lgray}} guibg=NONE
hi Constant     gui=NONE guifg=#{{red}} guibg=NONE
hi Error        gui=BOLD guifg=#{{lred}} guibg=#8000ff
hi Identifier   gui=NONE guifg=#{{cyan}} guibg=NONE
hi Ignore       gui=NONE guifg=bg      guibg=NONE
hi PreProc      gui=NONE guifg=#{{red}} guibg=NONE
hi Special      gui=NONE guifg=#{{green}} guibg=NONE
hi Statement    gui=NONE guifg=#{{blue}} guibg=NONE
hi Todo         gui=BOLD,UNDERLINE guifg=#{{magenta}} guibg=NONE
hi Type         gui=NONE guifg=#{{green}} guibg=NONE
hi Underlined   gui=UNDERLINE guifg=fg guibg=NONE
