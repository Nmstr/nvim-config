return {
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

	-- Guess indentation used in buffer
	{ "NMAC427/guess-indent.nvim", opts = {} },

	-- Markdown editing
	{ "SidOfc/mkdx" },
}
