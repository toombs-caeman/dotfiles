" override some fields of the default term extension
function! airline#extensions#termline#init(ext)
    call a:ext.add_statusline_func('airline#extensions#termline#apply')
    call a:ext.add_inactive_statusline_func('airline#extensions#termline#unapply')
endfunction
function! airline#extensions#termline#apply(...)
  if &buftype == 'terminal' || bufname('%')[0] == '!'
    return call('s:make', a:000)
  endif
endfunction
function! airline#extensions#termline#unapply(...)
  if getbufvar(a:2.bufnr, '&buftype') == 'terminal'
    return call('s:make', a:000)
  endif
endfunction

function! s:make(...)
    call a:1.add_section('airline_a', '%{airline#parts#mode()}')
    call a:1.add_section('airline_path', '%{airline#extensions#termline#context()}')
    call a:1.split()
    call a:1.add_section('airline_y', '')
    call a:1.add_section('airline_z', airline#section#create_right(['linenr', 'maxlinenr']))
    return 1
endfunction

function! airline#extensions#termline#context()
  let repo = substitute(system('git rev-parse --show-toplevel 2>/dev/null'), '[[:cntrl:]]', '', 'g')
  let context = substitute(substitute(getcwd(), repo, '', ''), $HOME, $USER, '')
  if (! len(repo)) | return context | endif
  let status = system('git status 2>/dev/null')

  let branch = get(matchlist(status, 'On branch \([^[:cntrl:]]*\)\|^HEAD detached at \([^[:cntrl:]]*\)'), 1, '')

  let behind = get(matchlist(status, 'Your branch is behind.*by \([[:num:]]*\)'), 1, '')
  let ahead =  get(matchlist(status, 'Your branch is ahead.*by \([[:num:]]*\)'), 1, '')
  let uptodate =  matchstr(status, 'Your branch is up to date')
  if len(behind) | let behind = '↓' . behind | endif
  if len(ahead)  | let ahead = '↑' . ahead | endif
  if !len(ahead) && !len(behind) && !len(uptodate) | let behind = 'L' | endif

  let dirty = ''
  if len(matchstr(status, 'Changes ')) | let dirty = '✬' | endif

  return substitute(repo,'.*/','','g') . '(' . dirty . branch . behind . ahead . ')' . context
endfunction


