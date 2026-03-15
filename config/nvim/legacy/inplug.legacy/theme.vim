" Plug 'https://github.com/folke/lsp-colors.nvim'
" Plug 'https://github.com/folke/trouble.nvim'

" icon "{{{
Plug 'https://github.com/ryanoasis/vim-devicons'
"}}}

" Show filenames "{{{
" Plug 'https://github.com/ldelossa/buffertag'

" command! -nargs=0 WinFilename lua require('buffertag').toggle()
"}}}

" colorscheme "{{{
" Plug 'https://github.com/joshdick/onedark.vim'
let g:onedark_terminal_italics = 1

" Plug 'https://github.com/sainnhe/sonokai'
" Plug 'https://github.com/arcticicestudio/nord-vim'

" Plug 'https://github.com/EdenEast/nightfox.nvim'
" Plug 'https://github.com/bluz71/vim-moonfly-colors'
Plug 'https://github.com/navarasu/onedark.nvim'

let g:onedark_config = {
      \ 'transparent': v:true,
      \ }

" let g:onedark_transparent_background = v:true
"}}}

Plug 'https://github.com/itchyny/vim-cursorword'
" Plug 'https://github.com/RRethy/vim-illuminate'
" Plug 'https://github.com/yamatsum/nvim-cursorline'

if v:version >= 800 || has('nvim')
  au TextYankPost * lua vim.highlight.on_yank {timeout=500}
endif

Plug 'https://github.com/nvim-lualine/lualine.nvim'
" Plug 'https://github.com/SmiteshP/nvim-gps'

Plug 'https://github.com/SmiteshP/nvim-navic'

" IndentLine "{{{
Plug 'https://github.com/lukas-reineke/indent-blankline.nvim'

let g:indentLine_char = '┊'
" let g:indentLine_char = '|'
" let g:indent_blankline_enabled = 0

" let g:indent_blankline_buftype_exclude = ['terminal']
" let g:indent_blankline_filetype_exclude = ['help', 'text']
let g:indent_blankline_filetype = ['vim', 'cpp', 'lua', 'yaml', 'python']
"}}}

" bufferline "{{{
Plug 'https://github.com/akinsho/bufferline.nvim'

nnoremap <silent> gB :BufferLinePickClose<CR>

nnoremap <silent><leader>g <Cmd>call vim#pick_buffer(v:count)<cr>
" nnoremap <silent><leader>2 <Cmd>BufferLineGoToBuffer 2<CR>

function! BuflineSplitOpenWindow(count, cmd)
  execute(a:cmd)
  if a:count == 0 && !empty(bufname('#'))
    execute('buffer #')
  else
    call luaeval(printf('require("bufferline").go_to_buffer(%d, true)', a:count))
  endif
endfunction

nmap <silent> <a-s> :<c-u>call BuflineSplitOpenWindow(v:count, 'split')<cr>
nmap <silent> <a-v> :<c-u>call BuflineSplitOpenWindow(v:count, 'vsplit')<cr>
"}}}

Plug 'https://github.com/powerman/vim-plugin-AnsiEsc', {'on': 'AnsiEsc'}

" which-key "{{{
Plug 'https://github.com/folke/which-key.nvim'
"}}}

" Git "{{{
Plug 'lewis6991/gitsigns.nvim'
Plug 'kdheepak/lazygit.nvim'
"}}}

augroup cursor_restore
  " restore cursor position
  autocmd! BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

function! s:ThemeInit()
  " highlight ColorColumn ctermbg=black guibg=lightgrey
  " highlight SignColumn ctermfg=none ctermbg=none guibg=none

  if has('vim_starting')
    try
      colorscheme onedark
      " colorscheme nightfox
      " colorscheme moonfly
      " colorscheme solarized
      " colorscheme sonokai
      " colorscheme neodark
      " colorscheme nord
    catch
      colorscheme desert
    endtry
  endif

  highlight TermCursor ctermfg=red guifg=red
endfunction

call vim#add_post_handler(function('s:ThemeInit'))

function! s:GitInit() abort
lua << EOF
local ok_gitsigns, gitsigns = pcall(require, "gitsigns")
if ok_gitsigns then
  gitsigns.setup({
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "^" },
      changedelete = { text = "~" },
    },
  })
end

vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { silent = true, desc = "LazyGit" })
EOF
endfunction

call vim#add_post_handler(function('s:GitInit'))
" call insert(g:post_handlers, funcref('s:ThemeInit'))
" let g:plugin_confs['theme']['post'] = funcref('s:ThemeInit')
" === Log 文件高亮 ===
Plug 'mtdl9/vim-log-highlighting'
" 语法解析核心（所有格式的高级显示都靠它）
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Markdown 实时预览
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" Markdown 界面美化（在 Vim 内部把标题、表格渲染得像文档一样）
Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'chrisbra/csv.vim'
Plug 'folke/flash.nvim'

" 2. 启动界面核心
Plug 'goolord/alpha-nvim'
" 启动页的图标（可选，需要 Nerd Fonts）
Plug 'nvim-tree/nvim-web-devicons'
