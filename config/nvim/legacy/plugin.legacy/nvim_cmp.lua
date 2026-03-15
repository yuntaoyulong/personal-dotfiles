--[[--
Copyright (c) 2021, Soul Inc
Author: Hongbo Liu <liulu3@soulapp.com>
Date  : 2021-11-25 19:32:05
--]]--

local function remove_key(maps, keys)
  for idx,val in ipairs(keys) do
    maps[val] = nil
  end

  return maps
end

local cmp = require('cmp')

local compare = require('cmp.config.compare')
local cmdline_maps = remove_key(cmp.mapping.preset.cmdline(), {"<Tab>", "<C-E>"})

cmp.setup({
  enabled = true,
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<A-m>'] = cmp.mapping.scroll_docs(4),
    ['<A-p>'] = cmp.mapping.scroll_docs(-4),
    -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
    -- ['<C-y>'] = cmp.config.disable,
  }),
  cmp.setup.cmdline('/', {
    mapping = cmdline_maps,
    sources = {
      { name = 'buffer' },
    }
  }),
  cmp.setup.cmdline(':', {
    mapping = cmdline_maps,
    -- completion = { autocomplete = false },
    sorting = {
      comparators  = {
        compare.score,
        compare.recently_used,
        compare.locality,
        compare.kind,
      }
    },
    sources = cmp.config.sources({
      { name = 'path' },
      {
        name = 'cmdline',
        priority = 100,
        -- keyword_length = 1,
        -- keyword_pattern = [[^\@<!Man\s]],
      },
      {
        name = 'cmdline_history',
        priority = 1,
        max_item_count = 5,
      },
    })
  }),
  -- sources = cmp.config.sources({
  sources = ({
    -- { name = 'ultisnips', priority = 100 }, -- For ultisnips users.
    {
      name = 'luasnip',
      -- keyword_pattern = "\\%([^[:alnum:][:blank:]]\\|\\w\\+\\)",
      -- keyword_pattern = [[\v(\w|\.)+]],
    },
    -- { name = 'ultisnips' }, -- For ultisnips users.
    { name = 'nvim_lsp' },
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
    { name = 'path' },
    { name = 'tags' },
    { name = 'calc' },
    { name = 'orgmode' },
    {
      name = 'tmux',
      max_item_count = 10,
      --[[ option = {
        all_panes = true,
        label = '[Tmux]',
      }, ]]
    },
  }),
  formatting = {
    -- Completions fields order: "abbr", "kind", "menu"
    -- fields = {},
    format = require("lspkind").cmp_format({
      -- with_text = true,
      -- mode = 'symbol',
      maxwidth = 50,
      menu = ({
        buffer = "[Buf]",
        nvim_lsp = "[LSP]",
        tags = "TAG",
        -- ultisnips = "[US]",
        luasnip = "[LuaS]",
        nvim_lua = "[Lua]",
        tmux = '[Tmux]',
        calc = '[Cal]'
        -- bazel = '[Bazel]'
        -- vim-dadbod-completion = '[Sql]',
      }),
    }),
  },
})

-- require('cmp_cmdline').cmdline_length = 2
-- require('cmp_cmdline').cmdargs_length = 1

cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
  sources = {
    {name = "dap"},
    {name = 'omni', keyword_length = 0},
  },
})

-- cmp.register_source('ultisnips', require'nvim_cmp_ultisnip'.new())
