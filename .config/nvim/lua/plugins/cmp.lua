return {
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			opts = {},
		},
		"folke/lazydev.nvim",
		{ "nvim-tree/nvim-web-devicons", opts = {} },
		"onsails/lspkind-nvim",
	},
	--- @module 'blink.cmp'
	--- @type blink.cmp.Config
	opts = {
		keymap = {
			preset = "default",
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			menu = {
				border = "rounded",
				draw = {
					components = {
						kind_icon = {
							text = function(ctx)
								local icon = ctx.kind_icon
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								else
									icon = require("lspkind").symbolic(ctx.kind, {
										mode = "symbol",
									})
								end

								return icon .. ctx.icon_gap
							end,
							highlight = function(ctx)
								local hl = ctx.kind_hl
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										hl = dev_hl
									end
								end
								return hl
							end,
						},
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = {
					border = "rounded",
				},
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "lazydev", "buffer" },
			providers = {
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
			},
		},

		snippets = { preset = "luasnip" },

		fuzzy = { implementation = "lua" },

		signature = { enabled = true },
	},
}
-- return {
-- 	"hrsh7th/nvim-cmp",
-- 	dependencies = {
-- 		"hrsh7th/cmp-buffer",
-- 		"hrsh7th/cmp-path",
-- 		"hrsh7th/cmp-nvim-lsp",
-- 		"hrsh7th/cmp-cmdline",
-- 		{
-- 			"L3MON4D3/LuaSnip",
-- 			dependencies = {
-- 				"rafamadriz/friendly-snippets",
-- 			},
-- 		},
-- 		"saadparwaiz1/cmp_luasnip",
-- 		"onsails/lspkind-nvim",
-- 	},
-- 	config = function()
-- 		local cmp = require("cmp")
-- 		local luasnip = require("luasnip")
-- 		local lspkind = require("lspkind")
--
-- 		require("luasnip.loaders.from_vscode").lazy_load()
--
-- 		cmp.setup({
-- 			-- experimental = {
-- 			-- 	ghost_text = true,
-- 			-- },
-- 			sources = {
-- 				{ name = "lazydev", group_index = 0 },
-- 				{ name = "nvim_lsp" },
-- 				{ name = "luasnip" },
-- 				{ name = "path" },
-- 				{ name = "buffer" },
-- 				{ name = "nvim_lsp_signature_help" },
-- 			},
-- 			formatting = {
-- 				format = lspkind.cmp_format({
-- 					mode = "symbol_text",
-- 					maxwidth = 50,
-- 					ellipsis_char = "...",
-- 					show_labelDetails = true,
-- 					before = function(entry, vim_item)
-- 						vim_item.menu = ({
-- 							nvim_lsp = "[LSP]",
-- 							luasnip = "[Snip]",
-- 							path = "[Path]",
-- 							nvim_lsp_signature_help = "[Sig]",
-- 							buffer = "[Buf]",
-- 						})[entry.source.name] or "[Other]"
-- 						return vim_item
-- 					end,
-- 				}),
-- 			},
-- 			snippet = {
-- 				expand = function(args)
-- 					luasnip.lsp_expand(args.body)
-- 				end,
-- 			},
-- 			window = {
-- 				completion = cmp.config.window.bordered(),
-- 				documentation = cmp.config.window.bordered(),
-- 			},
-- 			mapping = cmp.mapping.preset.insert({}),
-- 		})
-- 	end,
-- }
