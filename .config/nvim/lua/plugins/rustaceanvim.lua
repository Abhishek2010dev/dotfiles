return {
  "mrcjkb/rustaceanvim",
  version = vim.fn.has "nvim-0.10.0" == 0 and "^4" or nil,
  ft = { "rust" },
  opts = {
    server = {
      on_attach = function(_, bufnr)
        vim.keymap.set("n", "<leader>cR", function()
          vim.cmd.RustLsp "codeAction"
        end, { desc = "Code Action", buffer = bufnr })
        vim.keymap.set("n", "<leader>dr", function()
          vim.cmd.RustLsp "debuggables"
        end, { desc = "Rust Debuggables", buffer = bufnr })
      end,
      default_settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true,
            },
          },
          checkOnSave = true,
          diagnostics = {
            enable = true,
          },
          procMacro = {
            enable = true,
            ignored = {
              ["async-trait"] = { "async_trait" },
              ["napi-derive"] = { "napi" },
              ["async-recursion"] = { "async_recursion" },
            },
          },
          files = {
            excludeDirs = {
              ".direnv",
              ".git",
              ".github",
              ".gitlab",
              "bin",
              "node_modules",
              "target",
              "venv",
              ".venv",
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    -- Check if rust-analyzer is installed
    if vim.fn.executable "rust-analyzer" == 0 then
      vim.notify(
        "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
        vim.log.levels.ERROR,
        { title = "rustaceanvim" }
      )
    end
    -- Set up rustaceanvim with provided options
    vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
  end,
}
