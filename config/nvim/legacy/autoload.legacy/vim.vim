let s:type_map = {
      \ '^f': 'function',
      \ '^m': 'map',
      \ '^c': 'command'
      \ }

function! vim#source(dir)
  let l:files = expand(a:dir)->readdir()
  call map(l:files, {_, f -> execute(printf('source %s/%s', a:dir, f))})
endfunction

function! vim#ismyplug()
  let myplug = resolve(expand('$MYPLUG'))
  let cur_path = resolve(expand('%:p'))
  if cur_path =~ '^'. myplug . '/mysnippets'
    return v:false
  endif

  return cur_path =~ '^'. myplug || cur_path == expand('$HOME/.vimrc')
endfunction

function! vim#pre_wrap(fun, cmd = '')
  if !empty(a:cmd)
    execute(a:cmd)
  endif

  if type(a:fun) == v:t_string
    return function(a:fun)
  endif

  return a:fun
endfunction

function! vim#is_vim()
  return vim#ismyplug() || resolve(expand('%:p')) =~ '^'. resolve(expand('$BUNDLE'))
endfunction

function! vim#letvar_if_not(name, default)
  if !exists(a:name)
    execute(printf('let %s = a:default', a:name))
  endif
endfunction

function! vim#plug_ft_init()
  if !vim#ismyplug()
    return
  endif

        " \ :execute printf('CtrlSF -W %s %s', expand('<cword>'), $MYPLUG)<cr>:
        " \CtrlSFOpen<cr>
  nmap <buffer> <silent> ,ff
        \ <Cmd>execute 'Grepper -noprompt -cword -cd ' .$MYPLUG<cr>

  augroup myplug_vimft_source
    autocmd! BufWritePost <buffer> source %
  augroup END
endfunction

function! vim#pick_buffer(count)
  if a:count == 0
    BufferLinePick
  endif

  call luaeval(printf('require("bufferline").go_to_buffer(%d, true)', a:count))
endfunction

function! s:lookup_get_type(type)
  let type = a:type
  for key in keys(s:type_map)
    if type =~ key
      let type = s:type_map[key]
      break
    endif
  endfor

  return type
endfunction

function! vim#lookup_complete(lead, cmdline, cursor_pos) abort
  let items = a:cmdline->split()
  if len(items) < 2
    return []
  endif

  let type = items[1]
  let type = s:lookup_get_type(type)

  if type == 'map'
    return []
  endif

  if s:type_map->values()->index(type) < 0
    return []
  endif

  return getcompletion('', type)
endfunction

function! vim#lookup(type, name = '')
  let name = a:name
  if empty(name)
    let name = expand('<cword>')
  endif
  let name = name->trim('()', 2)

  call lookup#jump_to_file_defining(s:lookup_get_type(a:type), name)
endfunction

function! vim#op_line(handler, type = '') abort
  if empty(a:type)
    set operatorfunc=function('vim#op_line',[a:handler])
    return "g@"
  endif

  let handler_type = type(a:handler)
  if handler_type == v:t_string
    execute a:handler
  else
    call a:handler()
  endif
endfunction

function! vim#fzf_lookup(type)
  let actions = {
        \ '': printf('Vlookup %s {}', a:type)
        \ }

  let comp_list = getcompletion('Vlookup ' .a:type, 'cmdline')
  call fzf#list(comp_list, actions)
endfunction

function! s:add_post_handler(list, fun)
  let Fun = a:fun
  let type = type(Fun)
  if type(Fun) == v:t_string
    let Fun = function(Fun)
  endif

  if index(a:list, Fun) >= 0
    return
  endif
  call add(a:list, Fun)
endfunction

function! s:run_handlers(list)
  for Handler in a:list
    call Handler()
  endfor
endfunction

let g:post_handlers = []
function! vim#add_post_handler(fun)
  call s:add_post_handler(g:post_handlers, a:fun)
endfunction

function! vim#run_post_handlers()
  call s:run_handlers(g:post_handlers)
endfunction

let g:post_vimenter = []
function! vim#add_post_vimenter(fun)
  call s:add_post_handler(g:post_vimenter, a:fun)
endfunction

function! vim#run_post_vimenter()
  call s:run_handlers(g:post_vimenter)
endfunction

function! vim#uniq_add(list, item)
  if index(a:list, a:item) >= 0
    return
  endif

  call add(a:list, a:item)
endfunction

function! vim#extend(name, obj)
  let name = a:name

  if !exists(name)
    execute printf('let %s = a:obj', name)
    return
  endif

  execute printf('call extend(%s, a:obj, "force")', name)
endfunction

function! vim#exe_omni(fun_name, findstart, base)
  execute(printf('let result = %s(%d, "%s")',
        \ a:fun_name, a:findstart, escape(a:base, "'\"")))

  return result
endfunction

function! vim#special_win_init()
  " setl nowrap
  call LoadMotionMap()
  unmap <buffer> d
  unmap <buffer> u
  ALEDisableBuffer
  call myqf#reset_changetick()

  setl wrap
  stopinsert
endfunction

function! vim#qfwin_init()
  call vim#special_win_init()

  nmap <nowait> <buffer> <silent> q <Cmd>call myqf#confirm_exit()<cr>
  " nmap <nowait> <buffer> <silent> q <Cmd>q<cr>

  setlocal modifiable

  nmap <nowait> <buffer> <silent> dd <Cmd>call myqf#remove_line()<cr>
  vmap <nowait> <buffer> <silent> d :call myqf#remove_visual()<cr>

  nnoremap <silent> <buffer> [[ :<C-U>call QuickfixItemJump('b', 'n', v:count1)<CR>
  nnoremap <silent> <buffer> ]] :<C-U>call QuickfixItemJump('' , 'n', v:count1)<CR>

  nnoremap <silent> <buffer> <C-t> <C-W><Enter><C-W>T
  nnoremap <silent> <buffer> <C-s> <C-W><Enter><C-W>=
  nnoremap <silent> <buffer> <C-h> <C-W><Enter><C-W>H

  command! -buffer -nargs=0 QFRefactor call qf_refactor#replace()
  command! -buffer -nargs=0 W QFRefactor

  setlocal nomodified

  " highlight QuickFixLine ctermbg=none
endfunction

function! vim#cmdwin_init()
  call vim#special_win_init()

  nmap <buffer> <silent> f f
  lua require('cmp').close()
endfunction

function! vim#same_indent_range() abort
  let cur_indent = indent('.')
  let lnnr = line('.')
  let start = lnnr - 1
  while start > 0
    if indent(start) != cur_indent || empty(getline(start))
      break
    endif
    let start -= 1
  endw
  let start += 1

  let end = lnnr + 1
  while end <= line('$')
    if indent(end) != cur_indent || getline(end)->empty()
      break
    endif
    let end += 1
  endw
  let end -= 1

  return [start, end]
endfunction

function! vim#sel_block_column() abort
  let col = virtcol('.')
  let [start, end] = vim#same_indent_range()
  call feedkeys(printf("%dgg%d|\<c-v>%dgg", start, col, end))
endfunction

function! vim#redraw()
  diffupdate | normal! <C-L><CR>
  set cmdheight=1
  " redraw
  " nnoremap <silent> <C-L> :nohlsearch<CR>
endfunction

function! vim#log(msg)
  let file = stdpath('cache') . '/my.log'
  let msg = printf('[%s][%s] %s', strftime('%F %T'), expand('%:~')[-15:], a:msg)
  call writefile([msg], file, "a")
endfunction
