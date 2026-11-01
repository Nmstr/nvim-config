-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Disable error bells
vim.opt.errorbells = false

-- Tab width
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- Convert tab to spaces
vim.o.expandtab = true

-- Transparent background
local function set_transparency()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
	vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#2a2a2a" }) -- Markdown Code Blocks
end
set_transparency()
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = set_transparency })

-- Set space as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable mouse mode
vim.o.mouse = "a"

-- Same indentation after line break
vim.o.breakindent = true

-- Undo history persist restarts
vim.o.undofile = true

-- Keep on signcolumn (for git signs)
vim.o.signcolumn = "yes"

-- Decrease update time (used for stuff like lsp updates)
vim.o.updatetime = 250

-- Configure split opening
vim.o.splitright = true
vim.o.splitbelow = true

-- Change display of certain characters
vim.o.list = true
vim.opt.listchars = {
	tab = "» ",
	trail = "·",
	nbsp = "␣",
}

-- Live substitution preview (in bottom panel)
vim.o.inccommand = "split"

-- Highlight line cursor is on
vim.o.cursorline = true

-- Min number between cursor and edge
vim.o.scrolloff = 10

-- Diagnostic config
vim.diagnostic.config({
	update_in_insert = true,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	virtual_text = true,
	virtual_lines = true,
	jump = { float = true },
})
