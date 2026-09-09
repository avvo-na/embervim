return {
	dir = "/Users/dan/Developer/personal/review.nvim",
	name = "review.nvim",
	cmd = { "Review" },
	keys = {
		{ "<leader>gr", "<cmd>Review<cr>", desc = "Review changes" },
	},
	dependencies = {
		{
			"esmuellert/codediff.nvim",
			tag = "v2.49.0",
			opts = {
				diff = {
					layout = "inline",
				},
				explorer = {
					position = "bottom",
					height = 10,
					initial_focus = "modified",
				},
			},
		},
		"MunifTanjim/nui.nvim",
	},
	opts = {
		keymaps = {
			popup_submit = "<C-CR>",
			send_sidekick = false,
		},
		ui = {
			hide_tabline = true,
		},
	},
}
