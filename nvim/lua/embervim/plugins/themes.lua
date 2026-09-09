return {
	-- VSCode Dark +
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local c = require("vscode.colors").get_colors()
			require("vscode").setup({
				-- transparent = false,
				-- italic_comments = false,
				-- disable_nvimtree_bg = true,
				-- group_overrides = {
				-- 	Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
				-- },
				-- color_overrides = {
				-- 	vscDarkYellow = "#aaaaaa",
				-- },
			})
		end,
	},

	-- Catppuccin
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		name = "catppuccin",
		opts = {
			integrations = {
				aerial = true,
				alpha = true,
				cmp = true,
				dashboard = true,
				flash = true,
				gitsigns = true,
				headlines = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				leap = true,
				lsp_trouble = true,
				mason = true,
				markdown = true,
				mini = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				navic = { enabled = true, custom_bg = "lualine" },
				neotest = true,
				neotree = true,
				noice = true,
				notify = true,
				semantic_tokens = true,
				telescope = true,
				treesitter = true,
				which_key = true,
			},
		},
	},

	-- Rose Pine
	{
		"rose-pine/neovim",
		lazy = false,
		priority = 1000,
		name = "rose-pine",
	},

	-- Kanagawa
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		name = "kanagawa",
	},

	-- Tokyonight
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
	},

	-- Monokai
	{
		"loctvl842/monokai-pro.nvim",
		lazy = false,
		priority = 1000,
	},

	-- Cyberdream
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("cyberdream").setup({
				transparent = true,
				italic_comments = true,
				hide_fillchars = false,
				borderless_telescope = true,
				terminal_colors = true,
				cache = false,
				extensions = {
					telescope = true,
					notify = true,
					mini = true,
				},
			})
		end,
	},

	-- Transparent
	{
		"xiyaowong/transparent.nvim",
		config = function()
			require("transparent").setup({ -- Optional, you don't have to run setup.
				groups = { -- table: default groups
					"Normal",
					"NormalNC",
					"Comment",
					"Constant",
					"Special",
					"Identifier",
					"Statement",
					"PreProc",
					"Type",
					"Underlined",
					"Todo",
					"String",
					"Function",
					"Conditional",
					"Repeat",
					"Operator",
					"Structure",
					"LineNr",
					"NonText",
					"SignColumn",
					"CursorLine",
					"CursorLineNr",
					"StatusLine",
					"StatusLineNC",
					"EndOfBuffer",
					"WinBar",
				},
				extra_groups = {}, -- table: additional groups that should be cleared
				exclude_groups = {}, -- table: groups you don't want to clear
			})

			require("transparent").clear_prefix("lualine")
		end,
	},
}
