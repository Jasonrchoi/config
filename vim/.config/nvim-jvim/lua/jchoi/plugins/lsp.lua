return {
    {
        'VonHeikemen/lsp-zero.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        cmd = 'Mason',
        branch = 'v2.x',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            {
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end
            },
            { 'williamboman/mason-lspconfig.nvim', },

            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
            { 'SmiteshP/nvim-navic' }
        },
        config = function()
            local lsp = require('lsp-zero').preset({})

            local navic = require('nvim-navic')

            lsp.on_attach(function(client, bufnr)
                lsp.default_keymaps({ buffer = bufnr })
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end)
            require('mason').setup({})
            require('mason-lspconfig').setup({
                -- Replace the language servers listed here
                -- with the ones you want to install
                ensure_installed = { 'lua_ls', 'helm_ls', 'dockerls', 'marksman', 'pyright', 'terraformls', 'tflint', 'bashls', 'docker_compose_language_service', 'jsonls', 'jedi_language_server', 'ruff_lsp', 'rust_analyzer', 'yamlls' },
                handlers = {
                    lsp.default_setup,
                }
            })


            lsp.setup()

            local cmp = require('cmp')
            -- local cmp_action = require('lsp-zero').cmp_action()

            require('luasnip.loaders.from_vscode').lazy_load()

            cmp.setup({
                preselect = cmp.PreselectMode.None,
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end
                }
            })
        end
    },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
}
