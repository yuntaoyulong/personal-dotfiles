local succ, ls = pcall(require, 'luasnip')
if not succ then
  return
end

local util = require("luasnip.util.util")
local types = require("luasnip.util.types")
local node_util = require("luasnip.nodes.util")

ls.setup({
  history = true,
  store_selection_keys="<Tab>",
  snip_env = {
    s = require("luasnip.nodes.snippet").S,
    sn = require("luasnip.nodes.snippet").SN,
    t = require("luasnip.nodes.textNode").T,
    f = require("luasnip.nodes.functionNode").F,
    i = require("luasnip.nodes.insertNode").I,
    c = require("luasnip.nodes.choiceNode").C,
    d = require("luasnip.nodes.dynamicNode").D,
    r = require("luasnip.nodes.restoreNode").R,
    l = require("luasnip.extras").lambda,
    rep = require("luasnip.extras").rep,
    p = require("luasnip.extras").partial,
    m = require("luasnip.extras").match,
    n = require("luasnip.extras").nonempty,
    dl = require("luasnip.extras").dynamic_lambda,
    fmt = require("luasnip.extras.fmt").fmt,
    fmta = require("luasnip.extras.fmt").fmta,
    conds = require("luasnip.extras.expand_conditions"),
    types = require("luasnip.util.types"),
    events = require("luasnip.util.events"),
    parse = require("luasnip.util.parser").parse_snippet,
    ai = require("luasnip.nodes.absolute_indexer"),
    postfix = require("luasnip.extras.postfix").postfix,
    psm = require("luasnip.util.parser").parse_snipmate,
  },
 --  ext_opts = {
 --    [types.choiceNode] = {
 --      active = {
	-- virt_text = {{"●", "GruvboxOrange"}}
 --      }
 --    },
 --    [types.insertNode] = {
 --      active = {
	-- virt_text = {{"●", "GruvboxBlue"}}
 --      }
 --    }
 --  },
  parser_nested_assembler = function(_, snippet)
    local select = function(snip, no_move)
      snip.parent:enter_node(snip.indx)
      -- upon deletion, extmarks of inner nodes should shift to end of
      -- placeholder-text.
      for _, node in ipairs(snip.nodes) do
	node:set_mark_rgrav(true, true)
      end

      -- SELECT all text inside the snippet.
      if not no_move then
	vim.api.nvim_feedkeys(
	  vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
	  "n",
	  true
	  )
	node_util.select_node(snip)
      end
    end
    function snippet:jump_into(dir, no_move)
      if self.active then
	-- inside snippet, but not selected.
	if dir == 1 then
	  self:input_leave()
	  return self.next:jump_into(dir, no_move)
	else
	  select(self, no_move)
	  return self
	end
      else
	-- jumping in from outside snippet.
	self:input_enter()
	if dir == 1 then
	  select(self, no_move)
	  return self
	else
	  return self.inner_last:jump_into(dir, no_move)
	end
      end
    end
    -- this is called only if the snippet is currently selected.
    function snippet:jump_from(dir, no_move)
      if dir == 1 then
	return self.inner_first:jump_into(dir, no_move)
      else
	self:input_leave()
	return self.prev:jump_into(dir, no_move)
      end
    end
    return snippet
  end,
})

local mysnip_dir = vim.fn.expand('$MYSNIP')
require("luasnip.loaders.from_snipmate").lazy_load({
  paths = {mysnip_dir},
  default_priority = 5000,
})
require("luasnip.loaders.from_snipmate").lazy_load()
require("luasnip.loaders.from_lua").lazy_load({
  paths = {mysnip_dir},
  default_priority = 5000,
})

ls.filetype_extend("all", { "_" })
ls.filetype_extend("zsh", {"sh"})

function snip_jump_end()
  local session = require("luasnip.session")
	local current = session.current_nodes[vim.api.nvim_get_current_buf()]
  local snip = current and current.parent.snippet or nil
  local end_node = snip.insert_nodes[0]

  while end_node and ls.jumpable(1) do
    local current = session.current_nodes[vim.api.nvim_get_current_buf()]
    if current == end_node then
      break
    end
    ls.jump(1)
  end
end

vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})
