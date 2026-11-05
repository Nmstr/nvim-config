return {
	-- LSP Plugins
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
		-- Java support
		{ "nvim-java/nvim-java" },
	},
	config = function()
		-- Java
		require("java").setup()
		vim.lsp.enable("jdtls")

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
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
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
}
