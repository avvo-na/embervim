return {
  {
    "numToStr/Comment.nvim" ,
    lazy = true,
    keys = {
      { "<leader>/", "<cmd>lua require(\"Comment.api\").toggle.linewise.current()<CR>", desc = "Comment Line" },
      { "<leader>/", "<esc><cmd>lua require(\"Comment.api\").toggle.linewise(vim.fn.visualmode())<cr>", mode = "v", desc = "Comment Block" },
    },
    config = function()
      require("Comment").setup({
        mappings = {
          basic = false,
          extra = false,
        },
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end
  },

  -- Correct commenting in TSX/JSX files
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
}
