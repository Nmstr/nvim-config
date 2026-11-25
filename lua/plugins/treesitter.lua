return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		-- Install parsers
		require("nvim-treesitter").install({
			"lua",
			"python",
			"c",
			"cpp",
			"java",
			"rust",
			"markdown",
			"markdown_inline",
			"bash",
			"json",
			"yaml",
			"toml",
		})

		-- Enable treesitter highlighting
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"lua",
				"python",
				"c",
				"cpp",
				"java",
				"rust",
				"markdown",
				"bash",
				"json",
				"yaml",
				"toml",
			},
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
