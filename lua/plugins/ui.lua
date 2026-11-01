return {
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

	-- Git itegration
	{ "lewis6991/gitsigns.nvim", opts = {} },

	-- Popup showing available keybinds
	{ "folke/which-key.nvim", opts = {} },

	-- Markdown rendering in the buffer
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},

	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}
