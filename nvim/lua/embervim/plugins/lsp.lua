return {
	-- Mason (Package Manager)
	{
		"williamboman/mason.nvim",
		lazy = false,
		keys = {
			{ "<leader>hm", "<cmd>Mason<cr>" },
		},
		dependencies = {
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
		},
		config = function()
			-- ------------------- --
			-- Mason Default Tools --
			-- ------------------- --
			require("mason").setup({})
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- LSPs
					-- "ts_ls",
					"rust-analyzer",
					"gopls",
					"lua-language-server",
					"yaml-language-server",
					"tailwindcss-language-server",
					"prisma-language-server",

					-- Formatters
					"prettierd",
					"goimports",
					"stylua",
					"fixjson",
					"shfmt",

					-- Linters
					-- "eslint-lsp",
				},
				auto_upadate = true,
			})
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "VonHeikemen/lsp-zero.nvim", branch = "v4.x" },
			{ "MysticalDevil/inlay-hints.nvim" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "rafamadriz/friendly-snippets" },
		},
		config = function()
			-- --------------------------- --
			-- LSP Setup (nvim-lspconfig)  --
			-- --------------------------- --
			local lsp_zero = require("lsp-zero")
			local lsp_defaults = require("lspconfig").util.default_config
			require("inlay-hints").setup({
				autocmd = { enable = false },
			})
			lsp_defaults.capabilities =
				vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = " ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
			})

			-- All Available LSP Servers
			-- https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
			--
			-- Quick setup for lsp servers
			-- https://www.lazyvim.org/
			--
			-- Keep in mind most LSP settings are already setup for us!
			-- We are just doing some more setup here to enable inlay hints.
			-- (Or you can customize whatever you want!)
			require("mason-lspconfig").setup({
				handlers = {
					-- ----------------- --
					-- START OF HANDLERS --
					-- ----------------- --
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,

					-- ------------- --
					-- ts_ls         --
					-- ------------- --
					ts_ls = function()
						require("lspconfig").ts_ls.setup({
							init_options = {
								preferences = {
									importModuleSpecifierEnding = "minimal",
									importModuleSpecifierPreference = "non-relative",
								},
							},
							settings = {
								typescript = {
									inlayHints = {
										includeInlayParameterNameHints = "all",
										-- includeInlayParameterNameHints = false,
										includeInlayParameterNameHintsWhenArgumentMatchesName = false,
										includeInlayFunctionParameterTypeHints = false,
										includeInlayVariableTypeHints = false,
										includeInlayVariableTypeHintsWhenTypeMatchesName = false,
										includeInlayPropertyDeclarationTypeHints = false,
										includeInlayFunctionLikeReturnTypeHints = false,
										includeInlayEnumMemberValueHints = false,
									},
								},
								javascript = {
									inlayHints = {
										-- includeInlayParameterNameHints = "all",
										includeInlayParameterNameHintsWhenArgumentMatchesName = false,
										includeInlayFunctionParameterTypeHints = false,
										includeInlayVariableTypeHints = false,
										includeInlayVariableTypeHintsWhenTypeMatchesName = false,
										includeInlayPropertyDeclarationTypeHints = false,
										includeInlayFunctionLikeReturnTypeHints = false,
										includeInlayEnumMemberValueHints = false,
									},
								},
							},
						})
					end,

					-- ------------- --
					-- gopls         --
					-- ------------- --
					gopls = function()
						require("lspconfig").gopls.setup({
							settings = {
								gopls = {
									gofumpt = true,
									codelenses = {
										gc_details = false,
										generate = true,
										regenerate_cgo = true,
										run_govulncheck = true,
										test = true,
										tidy = true,
										upgrade_dependency = true,
										vendor = true,
									},
									hints = {
										assignVariableTypes = false,
										compositeLiteralFields = false,
										compositeLiteralTypes = false,
										constantValues = false,
										functionTypeParameters = false,
										parameterNames = false,
										rangeVariableTypes = false,
									},
									analyses = {
										fieldalignment = false,
										nilness = true,
										unusedparams = true,
										unusedwrite = true,
										useany = true,
									},
									usePlaceholders = true,
									completeUnimported = true,
									staticcheck = true,
									directoryFilters = {
										"-.git",
										"-.vscode",
										"-.idea",
										"-.vscode-test",
										"-node_modules",
										"-vendor",
									},
									semanticTokens = true,
								},
							},
						})
					end,

					-- --------------- --
					-- END OF HANDLERS --
					-- --------------- --
				},
			})

			-- --------------------------- --
			-- Completion Setup (nvim-cmp) --
			-- --------------------------- --
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()
			cmp.setup({
				sources = {
					{ name = "path" },
					{ name = "nvim_lsp" },
					{ name = "luasnip", keyword_length = 2 },
					{ name = "buffer", keyword_length = 3 },
					per_filetype = {
						codecompanion = { "codecompanion" },
					},
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(), -- Previous item
					["<C-n>"] = cmp.mapping.select_next_item(), -- Next item
					["<C-s>"] = cmp.mapping.complete(), -- Start completion
					["<C-e>"] = cmp.mapping.close(), -- Close completion
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Complete
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				experimental = {
					-- ghost_text = true,
				},
				formatting = lsp_zero.cmp_format({ details = true }),
			})
		end,
	},

	-- LSP Saga
	{
		"nvimdev/lspsaga.nvim",
		lazy = false,
		event = { "LspAttach" },
		keys = {
			{ "K", "<CMD>Lspsaga hover_doc<CR>", desc = "Hover" },
			{ "L", "<CMD>lua vim.diagnostic.open_float()<CR>", desc = "Show Line Diagnostics" },
			{ "gd", "<CMD>Lspsaga goto_definition<CR>zz", desc = "Go to Definition" },
			{ "<leader>lq", "<CMD>Lspsaga finder<CR>", desc = "Definition & References" },
			{ "<leader>lr", "<CMD>Lspsaga rename ++project<CR>", desc = "Rename" },
			{ "<leader>ld", "<CMD>Lspsaga peek_definition<CR>", desc = "Peek Definition" },
			{ "<leader>lt", "<CMD>Lspsaga peek_type_definition<CR>", desc = "Peek Type Definition" },
			{ "<leader>lb", "<CMD>Lspsaga show_buf_diagnostics<CR>", desc = "Buffer Diagnostics" },
			{ "<leader>lw", "<CMD>Lspsaga show_workspace_diagnostics ++float<CR>", desc = "Workspace Diagnostics" },
			{ "<leader>la", "<CMD>Lspsaga code_action<CR>", desc = "Code Action" },
			{
				"[e",
				function()
					require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
				end,
				desc = "Previous Error",
			},
			{
				"]e",
				function()
					require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
				end,
				desc = "Next Error",
			},
			{
				"[d",
				function()
					require("lspsaga.diagnostic"):goto_prev()
				end,
				desc = "Previous Diagnostic",
			},
			{
				"]d",
				function()
					require("lspsaga.diagnostic"):goto_next()
				end,
				desc = "Next Diagnostic",
			},
			{
				"<leader>lo",
				function()
					vim.lsp.buf.code_action({
						apply = true,
						context = {
							only = { "source.removeUnused" },
						},
					})
				end,
				desc = "Organize all imports",
			},
			{
				"<leader>li",
				function()
					vim.lsp.buf.code_action({
						apply = true,
						context = {
							only = { "source.addMissingImports" },
						},
					})
				end,
				desc = "Add missing imports",
			},
			{
				"<leader>lc",
				"<CMD>checkhealth lspconfig<CR>",
				desc = "Active LSP Clients",
			},
		},
		config = function()
			require("lspsaga").setup({
				ui = {
					code_action = "",
				},
				symbol_in_winbar = {
					enable = false,
				},
				code_action = {
					keys = {
						quit = { "q", "<ESC>" },
					},
				},
				diagnostic = {
					show_code_action = false,
				},
				hover = {
					max_width = 0.5,
					max_height = 0.5,
				},
			})
		end,
	},

	-- Code Outline
	{
		"hedyhli/outline.nvim",
		lazy = true,
		keys = {
			{ "<leader>o", "<CMD>Outline<CR>", desc = "Toggle code outline" },
		},
		config = function()
			require("outline").setup({})
		end,
	},
}
