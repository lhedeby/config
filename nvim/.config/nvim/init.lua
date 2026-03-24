-- >> SHOULD ALWAYS BE FIRST
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- << SHOULD ALWAYS BE FIRST

vim.o.hlsearch = true
vim.o.mouse = 'a'
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.scrolloff = 10
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true

vim.wo.number = true
vim.wo.signcolumn = 'yes'

vim.opt.relativenumber = true
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.clipboard = 'unnamedplus'
vim.opt.wrap = false
vim.opt.colorcolumn = '80'

-------------------------
-- normal mode keymaps --
-------------------------
vim.keymap.set("n", "<leader>l", "<C-^>")
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', '<leader>ff', vim.lsp.buf.format, { desc = '[F]ormat Code' })
vim.keymap.set('n', '<leader>fs', '<cmd>w<CR>', { desc = '[S]ave' })
vim.keymap.set('n', '<leader>w', '<c-w>', { desc = '[W]indow' })
vim.keymap.set('n', '<leader>src', '<cmd>source $MYVIMRC<cr>', { desc = '[S]ource [R][C]' })
vim.keymap.set('n', '<leader>fe', '<cmd>edit $MYVIMRC<cr>', { desc = '[E]dit Vimrc' })
vim.keymap.set('n', '<leader>fw', '<cmd>edit ~/.wezterm.lua<cr>', { desc = 'Edit [W]ezterm config' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>dd', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end,
    { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end,
    { desc = "Go to next diagnostic message" })
-------------------------
-- insert mode keymaps --
-------------------------
vim.keymap.set("i", "\\j", "()")
vim.keymap.set("i", "\\k", "\"\"")
vim.keymap.set("i", "\\l", "\'\'")
vim.keymap.set("i", "\\f", "=>")
-------------------------
-- visual mode keymaps --
-------------------------
vim.keymap.set('v', '<leader>ff', vim.lsp.buf.format, { desc = '[F]ormat Code' })

-- bicepparam is a bicep file
vim.filetype.add({
    extension = {
        bicepparam = 'bicep'
    }
})

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {
        'lhedeby/around.nvim',
        event = "VeryLazy",
        config = function()
            vim.keymap.set('x', 'a', require('nvim-around').around, { desc = '[A]round' })
        end
    },
    { 'tpope/vim-fugitive', event = "VeryLazy" },
    { 'tpope/vim-rhubarb',  event = "VeryLazy" },
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'mason-org/mason.nvim', opts = {} },
            'mason-org/mason-lspconfig.nvim',
            { 'j-hui/fidget.nvim',    opts = {} },
        },

        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
                    map('K', function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover")

                    local fzf = require('fzf-lua')
                    map('gr', fzf.lsp_references, '[G]oto [R]eferences')
                    map('gi', fzf.lsp_implementations, '[G]oto [I]mplementation')
                    map('gd', fzf.lsp_definitions, '[G]oto [D]efinition')
                    map('gO', fzf.lsp_document_symbols, 'Open Document Symbols')
                    map('gt', fzf.lsp_typedefs, '[G]oto [T]ype Definition')
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                    map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
                end,
            })

            -- See :help vim.diagnostic.Opts
            vim.diagnostic.config {
                severity_sort = true,
                float = { border = 'rounded', source = 'if_many' },
                underline = { severity = vim.diagnostic.severity.ERROR },
                signs = vim.g.have_nerd_font and {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '󰅚 ',
                        [vim.diagnostic.severity.WARN] = '󰀪 ',
                        [vim.diagnostic.severity.INFO] = '󰋽 ',
                        [vim.diagnostic.severity.HINT] = '󰌶 ',
                    },
                } or {},
                virtual_text = {
                    source = 'if_many',
                    spacing = 2,
                    format = function(diagnostic)
                        local diagnostic_message = {
                            [vim.diagnostic.severity.ERROR] = diagnostic.message,
                            [vim.diagnostic.severity.WARN] = diagnostic.message,
                            [vim.diagnostic.severity.INFO] = diagnostic.message,
                            [vim.diagnostic.severity.HINT] = diagnostic.message,
                        }
                        return diagnostic_message[diagnostic.severity]
                    end,
                },
            }

            local servers = {
                -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = 'Replace',
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { 'missing-fields' } },
                            diagnostics = {
                                globals = { 'vim' }
                            }

                        },
                    },
                },
            }

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua',
            })

            require("mason").setup({
                registries = {
                    "github:mason-org/mason-registry",
                    -- "github:Crashdummyy/mason-registry",
                },
            })

            require('mason-lspconfig').setup {
                ensure_installed = {},
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }
        end,
    },
    {
        "seblyng/roslyn.nvim",
        opts = {},
    },
    {
        'echasnovski/mini.files',
        version = false,
        config = function()
            require('mini.files').setup()
            vim.keymap.set("n", "<leader>e", function() MiniFiles.open() end, { desc = "[E]xplorer" })
        end
    },
    -- { "hrsh7th/cmp-cmdline" },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help'
        },
        config = function()
            local cmp = require 'cmp'
            cmp.setup {
                window = {
                    completion = {
                        border = 'rounded',
                        scrollbar = true,
                    },
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-s>'] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                },
            }
        end
    },
    {
        'folke/which-key.nvim',
        event = "VeryLazy",
        opts = {
            win = {
                border = "double", -- none, single, double, shadow
            }
        }
    },
    {
        'lewis6991/gitsigns.nvim',
        event = "VeryLazy",
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
            },
        },
    },
    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     priority = 1000,
    --     config = function()
    --         vim.cmd.colorscheme('catppuccin-mocha')
    --         require("catppuccin").setup({
    --             integrations = {
    --                 cmp = true,
    --                 gitsigns = true,
    --                 treesitter = true,
    --             }
    --         })
    --     end
    -- },
    -- {
    --     'sainnhe/gruvbox-material',
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         -- Optionally configure and load the colorscheme
    --         -- directly inside the plugin declaration.
    --         vim.g.gruvbox_material_enable_italic = true
    --         vim.g.gruvbox_material_background = 'hard'
    --         vim.cmd.colorscheme('gruvbox-material')
    --     end
    -- },

    -- {
    --     'sainnhe/everforest',
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         -- Optionally configure and load the colorscheme
    --         -- directly inside the plugin declaration.
    --         vim.g.everforest_enable_italic = true
    --         vim.g.everforest_background = 'hard'
    --         vim.cmd.colorscheme('everforest')
    --     end
    -- },
    -- {
    --     "EdenEast/nightfox.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function()
    --         vim.cmd.colorscheme('carbonfox')
    --     end
    -- },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},

        config = function()
            vim.cmd.colorscheme('tokyonight-night')
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        event = "VeryLazy",
        opts = {
            options = {
                icons_enabled = false,
                theme = 'tokyonight',
                -- theme = 'carbonfox',
                -- theme = 'everforest',
                -- theme = 'catppuccin-mocha',
                -- theme = 'gruvbox-material',
                component_separators = '|',
                section_separators = '',
            },
        },
    },
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        config = function()
            local fzf = require('fzf-lua')
            vim.keymap.set('n', '<leader>?', fzf.oldfiles, { desc = '[?] Find recently opened files' })
            vim.keymap.set('n', '<leader><space>', fzf.buffers, { desc = '[ ] Find existing buffers' })
            vim.keymap.set('n', '<leader>/', function()
                fzf.blines({ previewer = false })
            end, { desc = '[/] Fuzzily search in current buffer' })
            vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>sh', fzf.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sd', fzf.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>so', fzf.oldfiles, { desc = '[O]ld files' })
        end
    },
    { "shortcuts/no-neck-pain.nvim" },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs',
        opts = {
            ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { 'ruby' },
            },
            indent = { enable = true, disable = { 'ruby' } },
        }
    }
})
