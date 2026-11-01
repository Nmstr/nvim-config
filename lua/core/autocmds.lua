-- Markdown spell checking
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.spell = true
	end,
})

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Terminal-mode navigation
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*toggleterm#*",
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }

		-- Navigate between Neovim splits from a terminal
		vim.keymap.set("t", "<C-h>", "<Cmd>wincmd h<CR>", opts)
		vim.keymap.set("t", "<C-j>", "<Cmd>wincmd j<CR>", opts)
		vim.keymap.set("t", "<C-k>", "<Cmd>wincmd k<CR>", opts)
		vim.keymap.set("t", "<C-l>", "<Cmd>wincmd l<CR>", opts)

		-- Allow normal Neovim window commands
		vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
	end,
})

-- C/C++: use 2 spaces for indentation
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.expandtab = true
	end,
})
