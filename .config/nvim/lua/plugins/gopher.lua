return {
	"olexsmir/gopher.nvim",
	ft = "go", -- Only load this plugin for Go filetypes
	build = function()
		vim.cmd.GoInstallDeps() -- Installs gomodifytags, gotests, impl, iferr
	end,
	config = function()
		require("gopher").setup({})

		local opts = { noremap = true, silent = true }
		local map = function(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
		end

		-- Register which-key group (optional but recommended)
		require("which-key").register({
			["<leader>cg"] = { name = "+Go (Gopher)" },
		})

		-- Tag Manipulation
		map("<leader>cga", ":GoTagAdd<CR>", "Add struct tags")
		map("<leader>cgr", ":GoTagRm<CR>", "Remove struct tags")

		-- Test Generation
		map("<leader>cgt", ":GoTestAdd<CR>", "Generate test for current function")
		map("<leader>cgT", ":GoTestsAll<CR>", "Generate tests for all functions")
		map("<leader>cge", ":GoTestsExp<CR>", "Generate tests with example output")

		-- Interface Implementation
		map("<leader>cgi", ":GoImpl<CR>", "Implement interface")

		-- Error Handling
		map("<leader>cgc", ":GoCmt<CR>", "Generate doc comments")
		map("<leader>cgo", ":GoIfErr<CR>", "Insert if err != nil")

		-- Running Go Commands
		map("<leader>cgrr", ":GoRun<CR>", "Run Go file/package")
		map("<leader>cgrb", ":GoBuild<CR>", "Build Go file/package")
		map("<leader>cgrt", ":GoTest<CR>", "Run Go tests")
		map("<leader>cgrv", ":GoTest -v<CR>", "Run Go tests (verbose)")

		-- Module/Dependency Management
		map("<leader>cgm", ":GoModTidy<CR>", "Run go mod tidy")
		map("<leader>cgg", ":GoGet<CR>", "Run go get")
		map("<leader>cgu", ":GoUpdateDeps<CR>", "Update Go dependencies")

		-- Other Utilities
		map("<leader>cgd", ":GoDoc<CR>", "View Go documentation")
		map("<leader>cgl", ":GoLint<CR>", "Run golint")
		map("<leader>cgf", ":GoFmt<CR>", "Run gofmt")
	end,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"neovim/nvim-lspconfig",
	},
}
