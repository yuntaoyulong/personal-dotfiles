local map = vim.keymap.set

map("v", "<C-c>", '"+y', { silent = true })

map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Live grep" })
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Buffers" })
map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Help tags" })

map({ "n", "x", "o" }, "<leader>s", function() require("flash").jump() end, { desc = "Flash Jump" })
map({ "n", "x", "o" }, "<leader>S", function() require("flash").remote() end, { desc = "Flash Remote" })

map("n", "<leader>gg", "<cmd>LazyGit<CR>", { silent = true, desc = "LazyGit" })
map("n", "<leader>e", "<cmd>Oil<CR>", { silent = true, desc = "Oil" })
map("n", "<leader>pl", "<cmd>Lazy<CR>", { silent = true, desc = "Plugins (Lazy)" })
map("n", "<leader>pm", "<cmd>Mason<CR>", { silent = true, desc = "Mason" })
map("n", "<leader>ph", "<cmd>checkhealth<CR>", { silent = true, desc = "Health" })
map({ "n", "v" }, "<leader>fm", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, { desc = "Format" })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { silent = true, desc = "Diagnostics" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { silent = true, desc = "Quickfix" })
map("n", "<leader>cs", "<cmd>TodoTelescope<CR>", { silent = true, desc = "Todo Search" })

map("n", "<leader>mp", "<cmd>MarpPPT<CR>", { silent = true, desc = "Marp PPTX" })
map("n", "<leader>md", "<cmd>MarpPDF<CR>", { silent = true, desc = "Marp PDF" })
map("n", "<leader>mP", "<cmd>MarpPreview<CR>", { silent = true, desc = "Marp Preview" })
