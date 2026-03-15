--[[ local gps = require("nvim-gps")
gps.setup {
  depth = 2,
} ]]

local navic = require("nvim-navic")

-- ❌ [修复] 注释掉出错的函数
-- local function IsChineseIM()
--   return vim.api.nvim_get_option('iminsert') > 0
-- end

local function file_exist()
  local filename = vim.fn.expand('%')
  if vim.fn.filereadable(filename) == 0 then
    return "[New]"
  end

  return ""
end

-- indentLine {{{
require("ibl").setup {
  -- char = "|",
  -- char = '┊',
  exclude = {
  buftypes = {"terminal"}
  },
}
-- }}}

require'lualine'.setup {
  --[[ tabline = {
    lualine_a = {'buffers'},
  }, ]]

  options = {
    globalstatus = true,
  },
  extensions = {'quickfix', 'fzf', 'fugitive'},
  sections = {
    --[[ lualine_a = {
      {'window', show_filename_only = false},
    }, ]]
    lualine_c = {
      { 'filename', path = 1, newfile_status = true },
      -- { file_exist },
      { 
        function()
          return navic.get_location()
        end, 
        cond = function() 
          return navic.is_available()
        end
      },
      -- { navic.get_location, cond = navic.is_available },
      
      -- ❌ [修复] 注释掉这行调用，因为 IsChineseIM 已经没了
      -- { '"中"', cond = IsChineseIM},
    }
  },
  inactive_sections = {
    lualine_a = {'mode'},
  },
}

require("bufferline").setup {
  options = {
    numbers = function(opts)
      -- local left_cnt = require('bufferline.ui')
      -- local left_cnt = require('bufferline.ui').marker.left_count
      return string.format('%s', opts.raise(opts.ordinal))
      -- return string.format('%s', opts.raise(opts.ordinal - opts.left_trunc))
    end,
    custom_filter = function(buf, buf_nums)
      if vim.bo[buf].buftype == 'terminal' then
        return false
      end

      return true
    end,
    show_buffer_icons = true,
    show_buffer_close_icons = false,
    -- show_tab_indicators = true,
    show_close_icon = false,
    always_show_bufferline = false,
    -- separator_style = "thin",
    -- separator_style = {'', ''},
  }
}
