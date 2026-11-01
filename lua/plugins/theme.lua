return {
	"oxidescheme/nvim",
	name = "oxide",
	lazy = false,
	priority = 1000,
	config = function()
		require("oxide").setup({
			transparent = true,

			on_highlights = function(highlights, colors)
				-- Split separators
				highlights.WinSeparator = {
					fg = "#585b70",
					bg = "NONE",
				}
				-- Active statusline
				highlights.StatusLine = {
					fg = "#cdd6f4",
					bg = "#313244",
					bold = true,
				}
				-- Inactive statusline
				highlights.StatusLineNC = {
					fg = "#7f849c",
					bg = "#1e1e2e",
				}
			end,
		})
		vim.cmd.colorscheme("oxide")

		vim.api.nvim_set_hl(0, "Whitespace", {
			fg = "#585b70",
		})
	end,
}
