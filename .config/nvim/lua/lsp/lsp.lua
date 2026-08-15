local servers = {
  "basedpyright",
  "djls",
  "rust_analyzer",
  "lua_ls",
}

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "creativenull/efmls-configs-nvim",
    "j-hui/fidget.nvim",
  },
  event = "BufReadPre",
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )

    vim.diagnostic.config({
      underline = false,
    })

    require("mason").setup()

    vim.diagnostic.config({
      underline = false,
    })

    require("mason-lspconfig").setup({
      ensure_installed = servers,
    })

    -- Shared LSP configuration
    for _, server in ipairs(servers) do
      vim.lsp.config(server, {
        capabilities = capabilities,
      })
    end

    -- EFM for formatting
    local prettiers = { "css", "scss", "sass", "less", "html", "javascript", "typescript", "json", "markdown", "yaml" }
    vim.lsp.config("efm", {
      filetypes = { unpack(prettiers), "python" },
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
      settings = {
        rootMarkers = { ".git/" },
        languages = (function()
          local languages = {}
          for _, filetype in ipairs(prettiers) do
            languages[filetype] = { require("efmls-configs.formatters.prettier_d") }
          end
          languages["python"] = { require("efmls-configs.formatters.black") }
          return languages
        end)(),
      },
    })

    -- Lua-language configurations
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
          format = {
            enable = true,
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
            },
          },
        },
      },
    })

    -- Enable LSP servers
    for _, server in ipairs(servers) do
      vim.lsp.enable(server)
    end
    vim.lsp.enable("efm")
  end,
}
