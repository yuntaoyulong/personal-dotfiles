" Copyright (c) 2021, Soul Inc
" Author: Hongbo Liu <liulu3@soulapp.com>
" Date  : 2021-11-25 19:45:22

" NvimCmp "{{{
Plug 'https://github.com/hrsh7th/nvim-cmp'
Plug 'https://github.com/dmitmel/cmp-cmdline-history'
Plug 'https://github.com/onsails/lspkind-nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-cmdline'
Plug 'https://github.com/hrsh7th/cmp-path'
" Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'https://github.com/saadparwaiz1/cmp_luasnip'
Plug 'https://github.com/hrsh7th/cmp-buffer'
Plug 'https://github.com/hrsh7th/cmp-omni'
Plug 'https://github.com/quangnguyen30192/cmp-nvim-tags'
Plug 'https://github.com/andersevenrud/compe-tmux', {'branch': 'cmp'}
" Plug 'https://github.com/alexander-born/cmp-bazel'
Plug 'https://github.com/hrsh7th/cmp-calc'

" Setup buffer configuration (nvim-lua source only enables in Lua filetype).
" autocmd FileType lua lua require'cmp'.setup.buffer {
" \   sources = {
" \     { name = 'nvim_lua' },
" \     { name = 'buffer' },
" \   },
" \ }

" set completeopt=menu,menuone,noselect

" augroup cmp_cmdwin
"   autocmd CmdWinEnter * lua require('cmp').setup({enabled = false})
"   autocmd CmdWinLeave * lua require('cmp').setup({enabled = true})
" augroup END
"}}}

" let g:UltiSnipsRemoveSelectModeMappings = 0
" === GitHub Copilot (AI 补全) ===
Plug 'github/copilot.vim'

" === LSP + Mason ===
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

function! s:LspStackInit() abort
lua << EOF
local ok_mason, mason = pcall(require, "mason")
if ok_mason then
  mason.setup()
end

local ok_mason_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
if ok_mason_lsp then
  mason_lspconfig.setup({
    ensure_installed = { "bashls", "clangd", "jsonls", "lua_ls", "marksman", "yamlls" },
    automatic_installation = true,
  })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp_lsp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

local servers = {
  bashls = {},
  clangd = {},
  jsonls = {},
  marksman = {},
  yamlls = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
      },
    },
  },
}

for _, opts in pairs(servers) do
  opts.capabilities = capabilities
end

local has_new_api = vim.lsp and vim.lsp.config ~= nil and type(vim.lsp.enable) == "function"
if has_new_api then
  for server, opts in pairs(servers) do
    vim.lsp.config(server, opts)
    vim.lsp.enable(server)
  end
else
  local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
  if ok_lspconfig then
    for server, opts in pairs(servers) do
      if lspconfig[server] then
        lspconfig[server].setup(opts)
      end
    end
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my_lsp_keymaps", { clear = true }),
  callback = function(ev)
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "LSP Definition")
    map("gr", vim.lsp.buf.references, "LSP References")
    map("K", vim.lsp.buf.hover, "LSP Hover")
    map("<leader>rn", vim.lsp.buf.rename, "LSP Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "LSP Code Action")
  end,
})
EOF
endfunction

call vim#add_post_handler(function('s:LspStackInit'))
