return {
	-- Window Manager (Auto-Resize)
	"danlikestocode/windows.nvim",
	lazy = true,
	event = { "WinNew" },
	keys = {
		{ "<C-w>f", "<CMD>WindowsMaximize<CR>", desc = "Fullscreen Window" },
		{ "<C-w>_", "<CMD>WindowsMaximizeVertically<CR>", desc = "Maximize Window Vertically" },
		{ "<C-w>|", "<CMD>WindowsMaximizeHorizontally<CR>", desc = "Maximize Window Horizontally" },
		{ "<C-w>=", "<CMD>WindowsEqualize<CR>", desc = "Equalize Windows" },
	},
	dependencies = {
		"anuvyklack/middleclass",
		"anuvyklack/animation.nvim",
	},
	config = function()
		require("windows").setup({
			ignore = {
				filetype = {
					"CHADTree",
					"sagaoutline",
					"Outline",
				},
			},
			animation = {
				enable = true,
				fps = 120,
			},
		})

		local autowidth = require("windows.autowidth")
		local autowidth_enabled = true

		local function sync_autowidth()
			local ok, lifecycle = pcall(require, "codediff.ui.lifecycle")
			local in_review = ok and lifecycle.get_session(vim.api.nvim_get_current_tabpage()) ~= nil
			local should_enable = not in_review

			if should_enable == autowidth_enabled then
				return
			end

			if should_enable then
				autowidth.enable()
			else
				autowidth.disable()
			end
			autowidth_enabled = should_enable
		end

		local group = vim.api.nvim_create_augroup("windows_codediff", { clear = true })
		vim.api.nvim_create_autocmd("TabEnter", {
			group = group,
			callback = sync_autowidth,
		})
		vim.api.nvim_create_autocmd("User", {
			group = group,
			pattern = { "CodeDiffOpen", "CodeDiffClose" },
			callback = function()
				vim.schedule(sync_autowidth)
			end,
		})
	end,
}
