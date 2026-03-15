function! plug#init()
  if empty(glob(expand('$PLUG_DIR/plug.vim')))
    silent !curl -fLo $PLUG_DIR/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    augroup plug_install
      autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
    augroup END
  endif

  source $PLUG_DIR/plug.vim

  command! -nargs=+ LuaPlug call plug#lua_handler(<args>)
endfunction

function! plug#get_current_name(cmd)
  let plugin_name = getline('.')

  if plugin_name !~# '\v^\s*(Plug|LuaPlug)'
    execute(a:cmd . '!')
    return
  endif

  let plugin_name = split(split(plugin_name, "'")[1], '/')[-1]
  let plugin_name = substitute(plugin_name, '\.git$', '', 'g')
  execute(a:cmd .' '. plugin_name)
endfunction

function! s:plug_loaded(spec)
  let rtp = join(filter([a:spec.dir, get(a:spec, 'rtp', '')], 'len(v:val)'), '/')
  return stridx(&rtp, rtp) >= 0 && isdirectory(rtp)
endfunction

function! plug#plug_names(...)
    return sort(filter(keys(filter(copy(g:plugs), { k, v -> !s:plug_loaded(v) })), 'stridx(v:val, a:1) != -1'))
endfunction

function! s:custom_expand(lua_exp, name)
  " Replace ${name} to require("name")
  let lua_expr = substitute(a:lua_exp, '\v\$\{(\S+)\}', 'require("\1")', 'g')
  if lua_expr =~ '^self'
    let require_cmd = printf('require("%s")', a:name)
    let res = substitute(lua_expr, '^self', require_cmd, '')
    return res
  endif

  return lua_expr
endfunction

let g:lua_plugins = []
function! plug#lua_handler(plugin, ...)
  let l:lua_name = a:plugin->split('/')[-1]->fnamemodify(':r')

  call plug#(a:plugin)
  if a:0 > 0
    let lua_cmd = s:custom_expand(a:1, lua_name)

    call vim#uniq_add(g:lua_plugins, lua_cmd)
  endif
endfunction

function! plug#load_lua_plugins()
  for lua_expr in g:lua_plugins
    call luaeval(lua_expr)
  endfor
endfunction

function! s:open_plugin_ur(line)
  let matches = matchlist(a:line, '\v[''"](\S+/\S+)[''"]')
  if len(matches) < 2
    return
  endif

  let l:url = matches[1]
  if l:url !~ '^http'
    let l:url = printf('https://github.com/%s', url)
  endif
  execute('silent !open ' . l:url)
endfunction

function! s:open_plug_file(line)
  let file =  a:line->split(':')[0:1]->join(':')

  execute('edit ' .expand(file))
endfunction

function! plug#open()
  let list = systemlist(printf(
        \ "rg -tvim -tlua --line-number -g '!backup' '%s' $MYPLUG",
        \ '^("|\s)*(Lua)?Plug\b'))

  let Handler = function('s:open_plug_file')

  let actions = {
        \ '': Handler,
        \ 'ctrl-o': function('s:open_plugin_ur'),
        \ 'ctrl-s': ['split', Handler],
        \ 'ctrl-v': ['vsplit', Handler],
        \ }

  let fzf_opts = [
        \ '-d', ':',
        \ '--with-nth', '3..',
        \ ]

  call fzf#list(list, actions, fzf#mypreview('{1}', '{2}', fzf_opts))
endfunction
