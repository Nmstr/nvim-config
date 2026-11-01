return {
	-- Better terminal
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
}
