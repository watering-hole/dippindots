-- Set up configurations
vim.g.mapleader = " "

-- Function to clone lazy.nvim if not present
local function setup_lazy_nvim()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)
end

setup_lazy_nvim()

require("color")
require("settings")
require("keybindings")

local lualine = require("plugins.lualine")
local telescope = require("plugins.telescope")
local lspconfig = require("lsp.lsp")
local mason = require("lsp.mason")

require("lazy").setup({
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },
        opts = telescope,
        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("fzf")
        end,
        keys = {
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Telescope buffers" },
            { "<leader>gf", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto definition" },
        },
    },
    {"nvim-telescope/telescope-symbols.nvim"},
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
        opts = lualine,
    },
    { "hrsh7th/cmp-nvim-lsp" },
    lspconfig,
    mason,
    {
        "mason-lspconfig.nvim",
        opts = {}
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            build = "make install_jsregexp",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
            },
            "saadparwaiz1/cmp_luasnip",
        },
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
            name = "lazydev",
            group_index = 0,
            })
        end,
        config = function(_, opts)
            require("cmp").setup(opts)
        end,
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} 
    },
    { "lukas-reineke/indent-blankline.nvim" },
    {
        'iamcco/markdown-preview.nvim',
        build = 'cd app && yarn install'
    },
    {
        'brenoprata10/nvim-highlight-colors',
        config = function()
            require("nvim-highlight-colors").setup({
                render = 'background',
                virtual_symbol = '■',
                virtual_symbol_prefix = '',
                virtual_symbol_suffix = ' ',
                virtual_symbol_position = 'inline',
                enable_hex = true,
                enable_short_hex = true,
                enable_rgb = true,
                enable_hsl = true,
                enable_ansi = true,
                enable_xterm256 = true,
                enable_xtermTrueColor = true,
                enable_hsl_without_function = true,
                enable_var_usage = true,
                enable_named_colors = true,
                enable_tailwind = false,
                custom_colors = {
                    { label = '%-%-theme%-primary%-color', color = '#0f1219' },
                    { label = '%-%-theme%-secondary%-color', color = '#1f2937' },
                }
            })
        end
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                background_colour = "#000000",
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'j-hui/fidget.nvim',
        }
    },
    {
        'ojroques/vim-oscyank',
        config = function()
            vim.keymap.set('n', '<leader>c', '<Plug>OSCYankOperator')
            vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
            vim.keymap.set('v', '<leader>c', '<Plug>OSCYankVisual')
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
        config = function()
            local mason_tsserver = vim.fn.stdpath("data")
            .. "/mason/packages/typescript-language-server/node_modules/typescript/lib/tsserver.js"

            require("typescript-tools").setup({
                settings = {
                    separate_diagnostic_server = true,
                    publish_diagnostic_on = "insert_leave",
                    expose_as_code_action = {},
                    tsserver_path = vim.uv.fs_stat(mason_tsserver) and mason_tsserver or nil,
                    tsserver_plugins = {},
                    tsserver_max_memory = "auto",
                    tsserver_format_options = {},
                    tsserver_file_preferences = {},
                    tsserver_locale = "en",
                    complete_function_calls = false,
                    include_completions_with_insert_text = true,
                    code_lens = "off",
                    disable_member_code_lens = true,
                    jsx_close_tag = {
                        enable = false,
                        filetypes = { "javascriptreact", "typescriptreact" },
                    },
                },
            })
        end
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                {"nvim-dap-ui"}
            },
        }
    },
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("markview").setup({})
        end,
    },
})
