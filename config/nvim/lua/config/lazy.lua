local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.schedule(function()
      vim.notify("lazy.nvim bootstrap failed:\n" .. out, vim.log.levels.ERROR)
    end)
    return
  end
end

vim.opt.rtp:prepend(lazypath)
local ok, lazy = pcall(require, "lazy")
if not ok then
  vim.schedule(function()
    vim.notify("lazy.nvim not available", vim.log.levels.ERROR)
  end)
  return
end

lazy.setup("plugins", {
  checker = { enabled = false },
  change_detection = { notify = false },
})
