local group = vim.api.nvim_create_augroup("my_autocmds", { clear = true })

vim.api.nvim_create_user_command("W", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file name for current buffer", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local text = table.concat(lines, "\n")
  if vim.bo.endofline then
    text = text .. "\n"
  end

  vim.fn.system({ "sudo", "tee", file }, text)
  if vim.v.shell_error ~= 0 then
    vim.notify("sudo write failed: " .. file, vim.log.levels.ERROR)
    return
  end

  vim.bo.modified = false
  vim.cmd("checktime")
  vim.notify("Wrote with sudo: " .. file)
end, { desc = "Write current buffer with sudo" })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
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
