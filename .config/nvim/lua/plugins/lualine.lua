return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional for icons
  event = "VeryLazy",
  config = function()
    -- Store laststatus to restore later
    vim.g.lualine_laststatus = vim.o.laststatus

    -- Set empty statusline until lualine loads if arguments are provided
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = " "
    else
      -- Hide statusline on starter page
      vim.o.laststatus = 0
    end

    -- Define icons (minimal set, replace with your preferred icons or use a plugin like nvim-web-devicons)
    local icons = {
      diagnostics = {
        Error = " ",
        Warn = " ",
        Info = " ",
        Hint = " ",
      },
      git = {
        added = " ",
        modified = " ",
        removed = " ",
      },
    }

    require("lualine").setup {
      options = {
        theme = "auto", -- Use Neovim's colorscheme
        globalstatus = vim.o.laststatus == 3, -- Use global statusline if laststatus=3
        disabled_filetypes = {
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "filename",
            path = 1, -- Show relative path
            shorting_target = 40, -- Shorten long paths
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        },
        lualine_x = {
          {
            function()
              return Snacks.profiler.status()
            end,
            cond = function()
              return Snacks and Snacks.profiler and Snacks.profiler.status
            end,
          },
          -- Noice command status (if noice.nvim is installed)
          {
            function()
              return require("noice").api.status.command.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.command.has()
            end,
            color = { fg = "#ff9e64" }, -- Statement-like color
          },
          -- Noice mode status
          {
            function()
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = { fg = "#b4f9f8" }, -- Constant-like color
          },
          -- DAP status (if nvim-dap is installed)
          {
            function()
              return " " .. require("dap").status()
            end,
            cond = function()
              return package.loaded["dap"] and require("dap").status() ~= ""
            end,
            color = { fg = "#f7768e" }, -- Debug-like color
          },
          -- Lazy updates (if lazy.nvim is used)
          {
            function()
              return require("lazy.status").updates()
            end,
            cond = require("lazy.status").has_updates,
            color = { fg = "#ffcc66" }, -- Special-like color
          },
          -- Git diff status (if gitsigns.nvim is installed)
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date "%R"
          end,
        },
      },
      extensions = { "neo-tree", "lazy", "fzf" },
    }

    -- Restore laststatus
    vim.o.laststatus = vim.g.lualine_laststatus

    -- Optional: Trouble.nvim integration (if installed)
    if package.loaded["trouble"] then
      local trouble = require "trouble"
      local symbols = trouble.statusline {
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      }
      table.insert(require("lualine").get_config().sections.lualine_c, {
        symbols and symbols.get,
        cond = function()
          return vim.b.trouble_lualine ~= false and symbols.has()
        end,
      })
      require("lualine").setup() -- Re-apply config with trouble integration
    end
  end,
}
