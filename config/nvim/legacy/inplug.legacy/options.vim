scriptencoding utf-8

" Formatter
Plug 'stevearc/conform.nvim'

" let s:vim_undodir = expand('$VIMCACHE/undo')
" let s:vim_backdir = expand('$VIMCACHE/backup')

" Enable embeded script highlight
let g:vimsyn_embed = 'lPr'

" if !isdirectory(expand('$VIMCACHE')) && exists('*mkdir')
"   call mkdir(s:vim_undodir, 'p')
"   call mkdir(s:vim_backdir, 'p')
" endif

" let &undodir = s:vim_undodir
" execute('set undodir=' . s:vim_undodir)
" execute('set backupdir=' . s:vim_backdir)

filetype plugin indent on

" %5 will restore the last 5 file buffers
" 'num remember last num files edited
set shada=!,'1000,<50,s10,h,%2

" set matchpairs+=<:>

" Mouse"{{{
set mouse+=c

" Avoid text selection when `<CMD> + click`
set mousemodel=extend
"}}}

" Column "{{{
" Recently vim can merge signcolumn and number column into one
set signcolumn=number
"}}}

" Lazy Redraw
set lazyredraw " :redraw to force draw

" set tildeop " ~ behavior like an operator

" Overall Preference settings "{{{
" set hidden
set shortmess+=A " No ATTENTION message when has swap file

set shortmess+=c
set nofixendofline
set nostartofline

set undofile
set backupext=.bak

set path+=include
set path+=../include

" set cpoptions+=W

set virtualedit=block

set define=^\(#\s*define\|[a-z]*\s*const\s*[a-z]*\)
" set wildignore+=*.o
set wildignore+=*.elf

set backspace=indent,eol,start

" set nostartofline

" theme "{{{
" set cursorline " [oc cul Highlight current line with hl-CursorLine
" set cursorcolumn " [ou cuc Hightlight current columon with hl-CursorColumn
set display+=lastline
" set display+=uhex " show unprintable char as <xx>
set termguicolors
"}}}

set expandtab

set showcmd
set noshowmode
set modeline
" set isfname-==
set isfname+=?

set number
set relativenumber

" Global status
set laststatus=3

set ruler
set pumheight=20 " popup menue max items

set complete-=i
" set completeopt-=preview
" set completeopt+=noinsert
" set completeopt+=noselect

set hlsearch
set incsearch

" set linebreak
set ignorecase
set fileignorecase
set wildignorecase
set smartcase

set formatoptions+=j " Delete comment character when joining commented lines
" set fo+=B " when join lines with multi-bytes, without space

if &tabpagemax < 50
  set tabpagemax=50
endif

if !empty(&viminfo)
  set viminfo+=!
endif

" popup menu
" set wildmode=longest,full
set wildmenu

" set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
set listchars=tab:\|\ ,trail:•,extends:#,nbsp:.
" set listchars=tab:\|\ ,trail:-,extends:>,precedes:<,nbsp:+

if has('syntax') && !exists('g:syntax_on')
  syntax enable " h syntax_cmd
endif

" Allow color schemes to do bright colors without forcing bold.
" if &t_Co == 8 && $TERM !~# '^linux'
"       set t_Co=16
" endif

" set t_Co=256
" set termguicolors

set sessionoptions-=options

" indent settings"{{{
set autoindent
" set smartindent

set smarttab
set shiftwidth=2
set tabstop=2
set shiftround

" C indention options
" set cinoptions=N-sg0,(0,W4,j1,J1+2s
" set cindent
"}}}

" timout settings"{{{
" set ttimeout
set timeoutlen=500
" set ttimeoutlen=50000 " Reduce delay when vim in tmux

" set timeout
" set timeoutlen
"}}}

" FileEncoding "{{{
" Choose encoding one by one, strictest should be first
" set fileencodings=ucs-bom,utf-8,gb2312,cp936,gbk,gb18030,latin1
set fileencodings=ucs-bom,utf-8,cp936,gbk,gb18030,latin1

set fileformats+=mac
" set fileformat=unix " set ff=mac
"}}}

" scroll settings "{{{

" set scrolloff=3

" if !&sidescrolloff
        " set sidescrolloff=5
" endif

"}}}

"}}}

" window "{{{
" set noequalalways
"}}}

" set diffopt=internal,filler,algorithm:patience

" fold "{{{
set foldlevelstart=99
set foldlevel=99
"}}}

function! s:FormatInit() abort
lua << EOF
local ok_conform, conform = pcall(require, "conform")
if not ok_conform then
  return
end

conform.setup({
  format_on_save = { timeout_ms = 700, lsp_format = "fallback" },
  formatters = {
    clang_format = {
      prepend_args = { "--style=LLVM" },
    },
  },
  formatters_by_ft = {
    bash = { "shfmt" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    json = { "jq" },
    lua = { "stylua" },
    markdown = { "prettier" },
    sh = { "shfmt" },
    yaml = { "prettier" },
  },
})

vim.keymap.set({ "n", "v" }, "<leader>fm", function()
  conform.format({ async = true, lsp_format = "fallback" })
end, { silent = true, desc = "Format buffer/range" })
EOF
endfunction

call vim#add_post_handler(function('s:FormatInit'))

 " vim:fdm=marker
