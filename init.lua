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
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Live substitution preview (in bottom panel)
vim.o.inccommand = "split"

-- Highlight line cursor is on
vim.o.cursorline = true

-- Min number between cursor and edge
vim.o.scrolloff = 10

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.spell = true
	end,
})

-- Diagnostic config
vim.diagnostic.config({
	update_in_insert = true,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	virtual_text = true,
	virtual_line = false,
	jump = { float = true },
})

-- Add space+q shortcut to see all diagnostics
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Keybinds to make split navigation easier
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

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

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Install lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
	-- Guess indentation used in buffer
	{ "NMAC427/guess-indent.nvim", opts = {} },
	-- Git itegration
	{ "lewis6991/gitsigns.nvim", opts = {} },
	-- Popup showing available keybinds
	{ "folke/which-key.nvim", opts = {} },
	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		enabled = true,
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown() },
				},
			})

			-- Enable extensions
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- Shortcuts
			-- See ":help telescope.builtin"
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
		end,
	},
	-- LSP Plugins
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs
			{ "mason-org/mason.nvim", opts = {} },
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			-- Status updates for LSP
			{ "j-hui/fidget.nvim", opts = {} },
			-- Allows extra capabilities provided by blink.cmp
			"saghen/blink.cmp",
			"saghen/blink.lib",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Rename variable under cursor
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					-- Execute a code action
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					-- Goto declaration
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					-- The following two autocommands are used to highlight references of the word under your cursor when your cursor rests there for a little while
					-- When you move your cursor, the highlights will be cleared (the second autocommand)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method("textDocument/documentHighlight", event.buf) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- Create a keymap to toggle inlay hints, if the language server supports them
					if client and client:supports_method("textDocument/inlayHint", event.buf) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Enable more capabilities
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			-- Enable following LSPs
			local servers = {
				pyright = {}, -- Python
				clangd = {}, -- C/C++
			}
			-- Ensure above servers and tools are installed
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				-- Lua
				"lua-language-server",
				"stylua",
				-- Python
				"pyright",
				"ruff",
				-- C/C++
				"clangd",
				"clang-format",
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			for name, server in pairs(servers) do
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				vim.lsp.config(name, server)
				vim.lsp.enable(name)
			end

			-- Special lua config (as recommended by neovim help docs)
			vim.lsp.config("lua_ls", {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (vim.uv.fs_stat(path .. "/luarc.json") or vim.uv.fs_stat(path .. "/luarc.jsonc"))
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							version = "LuaJIT",
							path = { "lua/?.lua", "lua/?/init.lua" },
						},
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
					})
				end,
				settings = {
					Lua = {},
				},
			})
			vim.lsp.enable("lua_ls")
		end,
	},
	-- Autoformat
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = {}
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				c = { "clang_format " },
				cpp = { "clang_format " },
			},
		},
	},
	-- Autocompletion
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "2.*",
		build = function()
			require("blink.cmp").build():pwait()
		end,
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {},
				opts = {},
			},
		},
		--- @module "blink.cmp"
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				preset = "super-tab",
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "prefer_rust_with_warning" },
			signature = { enabled = true },
		},
	},
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	-- Collection of various small independent plugins/modules
	{
		"nvim-mini/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			-- E.g.:
			-- - va)  - [V]isually select [A]round [)]paren
			-- - yinq - [Y]ank [I]nside [N]ext [Q]uote
			-- - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ l_lines = 500 })
			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
			-- Auto pairs
			require("mini.pairs").setup()
		end,
	},
	-- File tree
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })
			require("nvim-tree").setup({
				view = {
					side = "left",
					width = 30,
				},
				filters = {
					enable = true,
					custom = {
						"^\\.git$",
						-- Godot
						".gd.uid",
						".import",
						-- Python
						".pyc",
					},
				},
				renderer = {
					highlight_git = true,
					icons = {
						show = {
							git = false,
						},
					},
				},
			})
		end,
	},
	-- Markdown editing
	{ "SidOfc/mkdx" },
	-- Markdown rendering in the buffer
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	-- Better terminal
	{
		"akinsho/toggleterm.nvim",
		opts = {
			size = 12,
			direction = "horizontal",
			start_in_insert = true,
			persist_size = true,
			persist_mode = true,
		},
		keys = {
			{ "<leader>ta", "<cmd>ToggleTerm<cr>", desc = "[T]erminal toggle [A]ll" },
			{
				"<leader>tn",
				function()
					vim.ui.input({ prompt = "Terminal name: " }, function(name)
						if name and name ~= "" then
							vim.cmd("TermNew name=" .. vim.fn.fnameescape(name))
						end
					end)
				end,
				desc = "[T]erminal new [N]amed",
			},
			{ "<leader>tq", "<cmd>TermNew<cr>", desc = "[T]erminal new [Q]uick" },
			{ "<leader>ts", "<cmd>TermSelect<cr>", desc = "[T]erminal [S]elect" },
		},
	},
})
