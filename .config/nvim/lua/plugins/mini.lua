return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.surround").setup()
		require("mini.indentscope").setup()

		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })

		statusline.section_location = function()
			return "%2l:%-2v"
		end
	end,
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"Trouble",
				"alpha",
				"dashboard",
				"fzf",
				"help",
				"lazy",
				"mason",
				"neo-tree",
				"notify",
				"snacks_dashboard",
				"snacks_notif",
				"snacks_terminal",
				"snacks_win",
				"toggleterm",
				"trouble",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})
	end,
}
