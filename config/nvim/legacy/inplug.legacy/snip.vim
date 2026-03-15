Plug 'https://github.com/honza/vim-snippets.git'

" Ultisnip "{{{
" Plug 'https://github.com/SirVer/ultisnips.git'

" default priority is 0
let g:UltiSnipsSnippetDirectories = ['UltiSnips', 'MyCusSnips', 'TencentSnips']
let g:cfamily_style_sep = ' '
" let g:UltiSnipsEnableSnipMate = 0 " Because vim-snippets add priority line
"}}}

Plug 'https://github.com/L3MON4D3/LuaSnip'

imap <silent><expr> <Tab>
      \ luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 

" -1 for jumping backwards.
snoremap <silent> <c-j> <cmd>lua require('luasnip').jump(1)<Cr>
inoremap <silent> <c-j> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <c-x><c-j> <cmd>lua snip_jump_end()<Cr>
inoremap <silent> <c-x><c-j> <cmd>lua snip_jump_end()<Cr>
snoremap <silent> <c-k> <cmd>lua require('luasnip').jump(-1)<Cr>
inoremap <silent> <c-k> <cmd>lua require('luasnip').jump(-1)<Cr>

nmap <silent> \su <Cmd>LuaSnipUnlinkCurrent<cr>

" snoremap <silent> <BS> <BS>gh<cmd>lua require('luasnip').jump(1)<Cr>
smap <silent> <c-h> <BS>gh<cmd>lua require('luasnip').jump(1)<Cr>
