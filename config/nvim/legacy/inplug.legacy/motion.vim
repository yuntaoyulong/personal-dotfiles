" Author: Hongbo Liu <lhbf@qq.com>
" Date  : 2021-01-18 17:23:09

" Plug 'https://github.com/rhysd/clever-f.vim'
" Plug 'https://github.com/terryma/vim-expand-region'
" Plug 'https://github.com/vim-scripts/camelcasemotion.git'

" ts region hop "{{{
Plug 'https://github.com/mfussenegger/nvim-treehopper'

omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
xnoremap <silent> m :lua require('tsht').nodes()<CR>
"}}}

" hope-lua "{{{
LuaPlug 'https://github.com/hiberabyss/hop.nvim', 'self.setup{teasing = false}'
" LuaPlug 'https://github.com/phaazon/hop.nvim', 'self.setup{teasing = false}'
" LuaPlug 'https://github.com/Weissle/easy-action', 'self.setup()'

map <silent> <Space>w <Cmd>HopWord<cr>
" map <silent> <Space>m <Cmd>HopChar2MW<cr>
map <silent> <Space>a <Cmd>HopAnywhere<cr>
" map <silent> <Space>a <Cmd>HopAnywhereCurrentLine<cr>
map <silent> <Space>j <Cmd>HopVerticalAC<cr>
map <silent> <Space>k <Cmd>HopVerticalBC<cr>
map <silent> <Space>s <Cmd>HopChar2MW<cr>
nmap <silent> f <Cmd>HopChar1<cr>
xmap <silent> f <Cmd>HopChar1<cr>
"}}}

" camelcasemotion"{{{
" map <silent> ,bb <Plug>CamelCaseMotion_b
"}}}

" sneak "{{{
" Plug 'https://github.com/justinmk/vim-sneak'

" let g:sneak#label = 1
" let g:sneak#use_ic_scs = 1
"}}}

" ScrollOther "{{{
" scroll other window
function! ScrollOtherWindow(scroll_cmd)
  if tabpagewinnr(tabpagenr(), '$') > 1
    wincmd w
    execute('normal ' . a:scroll_cmd)
    wincmd p
  endif
endfunction

nnoremap <silent> <A-y> <esc>:call ScrollOtherWindow("\<lt>C-y>")<cr>
nnoremap <silent> <A-e> <esc>:call ScrollOtherWindow("\<lt>C-e>")<cr>
nnoremap <silent> <S-A-J> <esc>:call ScrollOtherWindow("\<lt>C-d>")<cr>
nnoremap <silent> <S-A-K> <esc>:call ScrollOtherWindow("\<lt>C-u>")<cr>
"}}}

" LuaPlug 'https://github.com/cbochs/portal.nvim', "self.setup()"

" vim:set fdm=marker:
" === Telescope (模糊搜索/文件导航) ===
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
