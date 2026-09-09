return {
	"utilyre/barbecue.nvim",
	name = "barbecue",
	version = "*",
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons", -- optional dependency
	},
	opts = {
		show_dirname = false,
		show_navic = false,
	},
	config = function(_, opts)
		require("barbecue").setup(opts)

		local ui = require("barbecue.ui")
		local function sync_visibility()
			local ok, lifecycle = pcall(require, "codediff.ui.lifecycle")
			local in_review = ok and lifecycle.get_session(vim.api.nvim_get_current_tabpage()) ~= nil
			ui.toggle(not in_review)
		end

		local group = vim.api.nvim_create_augroup("barbecue_codediff", { clear = true })
		vim.api.nvim_create_autocmd("TabEnter", {
			group = group,
			callback = sync_visibility,
		})
		vim.api.nvim_create_autocmd("User", {
			group = group,
			pattern = { "CodeDiffOpen", "CodeDiffClose" },
			callback = function()
				vim.schedule(sync_visibility)
			end,
		})
	end,
}
