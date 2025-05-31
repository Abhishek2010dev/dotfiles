return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      cmd = "LazyDev",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "snacks.nvim", words = { "Snacks" } },
        },
      },
    },
    "saghen/blink.cmp",
  },
  config = function()
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
      } or {},
      virtual_text = {
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
          return diagnostic.message
        end,
      },
    }

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(event)
        local opts = { buffer = event.buf, silent = true }

        local function map(keys, func, desc, modes)
          modes = modes or "n"
          vim.keymap.set(modes, keys, func, vim.tbl_extend("force", opts, { desc = desc }))
        end

        local function client_supports_method(client, method, bufnr)
          if vim.fn.has "nvim-0.11" == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if
          client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
        then
          local highlight_augroup = vim.api.nvim_create_augroup("custom-lsp-highlight", { clear = false })

          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("custom-lsp-detach", { clear = true }),
            callback = function(ev)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = "custom-lsp-highlight", buffer = ev.buf }
            end,
          })
        end

        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, "Toggle Inlay Hints")
        end

        map("<leader>cl", function()
          Snacks.picker.lsp_config()
        end, "LSP Info")
        map("gd", function()
          Snacks.picker.lsp_definitions()
        end, "Goto Definition")
        map("gr", function()
          Snacks.picker.lsp_references()
        end, "References", { "n" })
        map("gI", function()
          Snacks.picker.lsp_implementations()
        end, "Goto Implementation")
        map("gy", function()
          Snacks.picker.lsp_type_definitions()
        end, "Goto T[y]pe Definition")
        map("gD", function()
          Snacks.picker.lsp_declarations()
        end, "Goto Declaration")
        map("K", vim.lsp.buf.hover, "Hover")
        map("gK", vim.lsp.buf.signature_help, "Signature Help")
        map("<C-k>", vim.lsp.buf.signature_help, "Signature Help", "i")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "v" })
        map("<leader>cc", vim.lsp.codelens.run, "Run Codelens", { "n", "v" })
        map("<leader>cC", vim.lsp.codelens.refresh, "Refresh Codelens")
        map("<leader>cR", function()
          Snacks.rename.rename_file()
        end, "Rename File")
        map("<leader>cr", vim.lsp.buf.rename, "Rename")
        map("<leader>cA", vim.lsp.buf.code_action, "Source Action")
        map("<a-n>", function()
          Snacks.words.jump(vim.v.count1, true)
        end, "Next Reference")
        map("<a-p>", function()
          Snacks.words.jump(-vim.v.count1, true)
        end, "Prev Reference")
        map("<leader>cd", vim.diagnostic.open_float, "Show Diagnostic")
        map("<leader>cq", vim.diagnostic.setloclist, "Diagnostics to Location List")
      end,
    })

    require("mason").setup {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      install_root_dir = vim.fn.stdpath "data" .. "/mason",
      PATH = "prepend",
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
      registries = {
        "github:mason-org/mason-registry",
      },
      providers = {
        "mason.providers.registry-api",
        "mason.providers.client",
      },
      github = {
        download_url_template = "https://github.com/%s/releases/download/%s/%s",
      },
      pip = {
        install_args = {},
      },
    }

    local capabilities = require("blink.cmp").get_lsp_capabilities()

    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "Snacks" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      },
    }

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "stylua",
      "lua_ls",
      "rust_analyzer",
    })
    require("mason-tool-installer").setup { ensure_installed = ensure_installed }

    require("mason-lspconfig").setup {
      automatic_enable = {
        exclude = {
          "rust_analyzer",
        },
      },
      ensure_installed = {},
      automatic_installation = true,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    }
  end,
}
