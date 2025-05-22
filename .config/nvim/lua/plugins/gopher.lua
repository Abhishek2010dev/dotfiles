return {
	"olexsmir/gopher.nvim",
	ft = "go",
	build = function()
		vim.cmd.GoInstallDeps()
	end,
	config = function()
		require("gopher").setup({
			log_level = vim.log.levels.INFO,
			timeout = 2000,
			commands = {
				go = "go",
				gomodifytags = "gomodifytags",
				gotests = "gotests",
				impl = "impl",
				iferr = "iferr",
			},
			gotests = {
				template = "default",
				template_dir = nil,
				named = false,
			},
			gotag = {
				transform = "snakecase",
				default_tag = "json",
			},
			iferr = {
				message = nil,
			},
		})

		local keymap = vim.keymap.set
		local opts = { noremap = true, silent = true }

		keymap("n", "<leader>ta", ":GoTagAdd json<CR>", opts)
		keymap("n", "<leader>tt", ":GoTestsAll<CR>", opts)
		keymap("n", "<leader>ie", ":GoIfErr<CR>", opts)
		keymap("n", "<leader>gi", ":GoImpl ", opts)
	end,
}
