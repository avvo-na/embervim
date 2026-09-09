return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				ensure_installed = {
					"vim",
					"lua",
					"markdown",
					"markdown_inline",
					"typescript",
					"javascript",
					"cpp",
					"go",
					"rust",
				},

				highlight = { enable = true },
				indent = { enable = true },
				textobjects = {
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[["] = "@class.outer",
						},
					},
				},
			})
		end,
	},
}
