return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({ style = "dark" })
      require("onedark").load()
    end,
  },

  { "nvim-tree/nvim-web-devicons" },
  { "nvim-lua/plenary.nvim" },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "SmiteshP/nvim-navic" },
    config = function()
      local ok_navic, navic = pcall(require, "nvim-navic")
      if ok_navic then
        navic.setup({})
      end
      require("lualine").setup({ options = { theme = "onedark" } })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    config = function()
      require("bufferline").setup({})
    end,
  },

  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
    config = function()
      require("telescope").setup({})
      pcall(require("telescope").load_extension, "fzf")
    end,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok_ts, ts = pcall(require, "nvim-treesitter")
      if ok_ts and type(ts.setup) == "function" then
        ts.setup({
          install = { "bash", "cpp", "json", "lua", "markdown", "markdown_inline", "yaml" },
          highlight = { enable = true },
          indent = { enable = true },
        })
      else
        local ok_legacy, legacy = pcall(require, "nvim-treesitter.configs")
        if ok_legacy then
          legacy.setup({
            ensure_installed = { "bash", "cpp", "json", "lua", "markdown", "markdown_inline", "yaml" },
            highlight = { enable = true },
            indent = { enable = true },
          })
        end
      end
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "honza/vim-snippets",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-calc",
      "dmitmel/cmp-cmdline-history",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-omni",
      "quangnguyen30192/cmp-nvim-tags",
      "andersevenrud/compe-tmux",
      "onsails/lspkind-nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local function cmdline_maps()
        local maps = cmp.mapping.preset.cmdline()
        maps["<Tab>"] = nil
        maps["<C-E>"] = nil
        return maps
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "tags" },
          { name = "calc" },
          { name = "omni" },
          { name = "tmux", max_item_count = 10 },
        }),
        formatting = {
          format = require("lspkind").cmp_format({ maxwidth = 50 }),
        },
      })

      cmp.setup.cmdline("/", {
        mapping = cmdline_maps(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmdline_maps(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
          { name = "cmdline_history", max_item_count = 5 },
        }),
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "bashls", "clangd", "jsonls", "lua_ls", "marksman", "yamlls" },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
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
        local lspconfig = require("lspconfig")
        for server, opts in pairs(servers) do
          if lspconfig[server] then
            lspconfig[server].setup(opts)
          end
        end
      end
    end,
  },

  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
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
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({})
    end,
  },
  { "kdheepak/lazygit.nvim" },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({})
    end,
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        view_options = {
          show_hidden = true,
        },
      })
    end,
  },

  {
    "folke/flash.nvim",
    config = function()
      require("flash").setup({})
    end,
  },

  {
    "hiberabyss/hop.nvim",
    config = function()
      require("hop").setup({ teasing = false })
      local map = vim.keymap.set
      map("n", "<Space>w", "<Cmd>HopWord<CR>", { silent = true })
      map("n", "<Space>a", "<Cmd>HopAnywhere<CR>", { silent = true })
      map("n", "<Space>j", "<Cmd>HopVerticalAC<CR>", { silent = true })
      map("n", "<Space>k", "<Cmd>HopVerticalBC<CR>", { silent = true })
      map("n", "<Space>s", "<Cmd>HopChar2MW<CR>", { silent = true })
      map("n", "f", "<Cmd>HopChar1<CR>", { silent = true })
      map("x", "f", "<Cmd>HopChar1<CR>", { silent = true })
    end,
  },

  {
    "mfussenegger/nvim-treehopper",
    config = function()
      local map = vim.keymap.set
      map({ "o", "x" }, "m", function()
        require("tsht").nodes()
      end, { silent = true })
    end,
  },

  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "███╗   ██╗███████╗ ██████╗",
        "████╗  ██║██╔════╝██╔═══██╗",
        "██╔██╗ ██║█████╗  ██║   ██║",
        "██║╚██╗██║██╔══╝  ██║   ██║",
        "██║ ╚████║███████╗╚██████╔╝",
        "╚═╝  ╚═══╝╚══════╝ ╚═════╝",
      }
      dashboard.section.buttons.val = {
        dashboard.button("e", "New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "Find file", ":Telescope find_files <CR>"),
        dashboard.button("p", "Plugins", ":Lazy<CR>"),
        dashboard.button("t", "Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "Config", ":e $MYVIMRC <CR>"),
        dashboard.button("q", "Quit", ":qa<CR>"),
      }
      local stats = require("lazy").stats()
      local version = vim.version()
      dashboard.section.footer.val = string.format(
        "Neovim v%d.%d.%d  |  %d plugins loaded",
        version.major,
        version.minor,
        version.patch,
        stats.loaded
      )
      alpha.setup(dashboard.opts)
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    config = function()
      require("render-markdown").setup({
        heading = { icons = { "① ", "② ", "③ ", "④ ", "⑤ ", "⑥ " } },
      })
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = { "markdown" },
  },

  {
    "3rd/image.nvim",
    config = function()
      local ok, image = pcall(require, "image")
      if not ok then
        return
      end
      image.setup({
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
            only_render_image_at_cursor = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
          },
        },
      })
    end,
  },

  {
    "chrisbra/csv.vim",
    ft = { "csv" },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      local ok, ibl = pcall(require, "ibl")
      if ok then
        ibl.setup({})
      end
    end,
  },

  {
    "itchyny/vim-cursorword",
  },

  {
    "ryanoasis/vim-devicons",
  },

  {
    "github/copilot.vim",
  },

  {
    "mtdl9/vim-log-highlighting",
    ft = { "log" },
  },

  {
    "powerman/vim-plugin-AnsiEsc",
    cmd = { "AnsiEsc" },
  },

  {
    "marp-team/marp.vim",
    enabled = false,
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({})
    end,
  },

  {
    "custom/marp-commands",
    dir = vim.fn.stdpath("config"),
    name = "marp-commands",
    config = function()
      local function marp_ensure()
        if vim.fn.executable("marp") == 1 then
          return true
        end
        vim.notify("marp not found. Install with: yay -S marp-cli-bin", vim.log.levels.WARN)
        return false
      end

      local function marp_export(ext)
        if not marp_ensure() then
          return
        end
        if vim.bo.modified then
          vim.cmd("silent update")
        end
        local src = vim.fn.expand("%:p")
        if src == "" then
          vim.notify("No file to export", vim.log.levels.WARN)
          return
        end
        local out = vim.fn.expand("%:p:r") .. "." .. ext
        local fmt_flag = ""
        if ext == "pptx" then
          fmt_flag = "--pptx"
        elseif ext == "pdf" then
          fmt_flag = "--pdf"
        end
        local cmd = string.format("marp --allow-local-files %s -- %s -o %s", fmt_flag, vim.fn.shellescape(src), vim.fn.shellescape(out))
        vim.cmd("silent !" .. cmd)
        if vim.v.shell_error ~= 0 then
          vim.notify(string.format("Marp export failed (exit %d): %s", vim.v.shell_error, out), vim.log.levels.ERROR)
          return
        end
        vim.notify("Marp exported: " .. out)
      end

      local function marp_preview()
        if not marp_ensure() then
          return
        end
        if vim.bo.modified then
          vim.cmd("silent update")
        end
        local src = vim.fn.expand("%:p")
        if src == "" then
          vim.notify("No file to preview", vim.log.levels.WARN)
          return
        end
        vim.cmd("terminal marp --preview --allow-local-files -- " .. vim.fn.shellescape(src))
      end

      vim.api.nvim_create_user_command("MarpPPT", function() marp_export("pptx") end, {})
      vim.api.nvim_create_user_command("MarpPDF", function() marp_export("pdf") end, {})
      vim.api.nvim_create_user_command("MarpPreview", marp_preview, {})
    end,
  },
}
