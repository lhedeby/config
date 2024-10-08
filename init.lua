--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- vim.loader.enable()

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'lhedeby/around.nvim', event = "VeryLazy" },
  { 'tpope/vim-fugitive',  event = "VeryLazy" },
  { 'tpope/vim-rhubarb',   event = "VeryLazy" },
  -- 'tpope/vim-surround',
  -- 'tpope/vim-sleuth',
  -- 'mfussenegger/nvim-dap',
  -- 'rcarriga/nvim-dap-ui',
  -- 'Issafalcon/lsp-overloads.nvim',
  { 'github/copilot.vim',  event = "VeryLazy" },
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = "VeryLazy",
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'Hoffs/omnisharp-extended-lsp.nvim',
      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        tag = "legacy",
        opts = {}
      },
      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },
  {
    --"hrsh7th/cmp-cmdline"
  },
  { 'echasnovski/mini.files',        version = false },
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   version = "*",
  --   lazy = true,
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   config = function()
  --     require("nvim-tree").setup {
  --       disable_netrw = true,
  --       hijack_netrw = true,
  --       renderer = {
  --         group_empty = true,
  --         highlight_git = true,
  --         special_files = { "bin", "debug" }
  --       },
  --       filters = {
  --         dotfiles = false,
  --       },
  --       view = {
  --         number = true,
  --         relativenumber = true,
  --         width = 45,
  --       },
  --
  --       diagnostics = {
  --         enable = true,
  --         show_on_dirs = true,
  --       },
  --       modified = {
  --         enable = true,
  --       },
  --       git = {
  --         enable = true,
  --         timeout = 700,
  --       },
  --       actions = {
  --         open_file = {
  --           resize_window = false,
  --         }
  --       }
  --     }
  --   end,
  -- },


  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      -- 'L3MON4D3/LuaSnip',
      -- 'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp-signature-help'
    },
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    opts = {
      window = {
        border = "double", -- none, single, double, shadow
      }
    }
  },
  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = "VeryLazy",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
    },
  },
  -- { "catppuccin/nvim",               name = "catppuccin" },
  -- { "sainnhe/everforest" },
  -- { "EdenEast/nightfox.nvim" },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  { -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'tokyonight',
        -- theme = 'nightfox',
        component_separators = '|',
        section_separators = '',
      },
    },
  },
  -- "gc" to comment visual regions/lines
  -- REMOVE IN 0.10
  {
    'numToStr/Comment.nvim',
    event = "VeryLazy",
    opts = {}
  },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', event = "VeryLazy", version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  -- {
  --   'nvim-telescope/telescope-fzf-native.nvim',
  --   -- NOTE: If you are having trouble with this installation,
  --   --       refer to the README for telescope-fzf-native for more instructions.
  --   build = 'make',
  --   cond = function()
  --     return vim.fn.executable 'make' == 1
  --   end,
  -- },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
      }
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },

  --{ import = 'custom.plugins' },
}, {})

-- Add filetypes
vim.filetype.add({
  extension = {
    bicepparam = 'bicep'
  }
})

-- Set highlight on search
vim.o.hlsearch = true
-- vim.opt.colorcolumn = "80"


-- Make line numbers default
vim.wo.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.scrolloff = 10
-- vim.cmd.colorscheme "catppuccin"
-- vim.cmd.colorscheme "everforest"
vim.cmd.colorscheme "tokyonight-night"
-- vim.cmd.colorscheme "carbonfox"

vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- last buffer
vim.keymap.set("n", "<leader>l", "<C-^>")

vim.keymap.set('n', ';', ':')


-- insert mode keymaps
vim.keymap.set("i", "\\j", "()")
vim.keymap.set("i", "\\k", "\"\"")
vim.keymap.set("i", "\\l", "\'\'")
vim.keymap.set("i", "\\f", "=>")


--
-- minifiles
require('mini.files').setup()
vim.keymap.set("n", "<leader>e", function() MiniFiles.open() end, { desc = "[E]xplorer" })

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
-- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Why would I wrap?
vim.opt.wrap = false


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<leader>so', require('telescope.builtin').oldfiles, { desc = '[O]ld files' })



vim.keymap.set('x', 'a', require('nvim-around').around, { desc = '[A]round' })


vim.keymap.set('n', '<leader>ff', vim.lsp.buf.format, { desc = '[F]ormat Code' })
vim.keymap.set('v', '<leader>ff', vim.lsp.buf.format, { desc = '[F]ormat Code' })

vim.keymap.set('n', '<leader>fs', '<cmd>w<CR>', { desc = '[S]ave' })
vim.keymap.set('n', '<leader>w', '<c-w>', { desc = '[W]indow' })



-- vimrc mapping TODO
vim.keymap.set('n', '<leader>src', '<cmd>source $MYVIMRC<cr>', { desc = '[S]ource [R][C]' })
vim.keymap.set('n', '<leader>fe', '<cmd>edit $MYVIMRC<cr>', { desc = '[E]dit Vimrc' })
-- edit wezterm config
vim.keymap.set('n', '<leader>fw', '<cmd>edit ~/.wezterm.lua<cr>', { desc = 'Edit [W]ezterm config' })

--vim.keymap.set('i', '<C-s>', '<cmd>w<CR>')

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  -- ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      -- init_selection = '<c-space>',
      -- node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
--vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>dd', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end
  --
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  -- nmap('<leader>wl', function()
  -- print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  eslint = {
    enable = true,
    lintTask = {
      enable = true,
    },
    diagnostics = {
      enable = true,
      run_on = "type",
    }
  },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { 'vim' } },
      completion = {
        callSnippet = "Replace"
      },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    if server_name == 'omnisharp' then
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
        handlers = {
          ['textDocument/definition'] = require('omnisharp_extended').handler
        }
      }
    else
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      }
    end
  end,
}

-- debug setup
-- local dap, dapui = require("dap"), require("dapui")
--
-- vim.g.dotnet_build_project = function()
--   local default_path = vim.fn.getcwd() .. '/'
--   if vim.g['dotnet_last_proj_path'] ~= nil then
--     default_path = vim.g['dotnet_last_proj_path']
--   end
--   local path = vim.fn.input('Path to your *proj file', default_path, 'file')
--   vim.g['dotnet_last_proj_path'] = path
--   local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'
--   print('')
--   print('Cmd to execute: ' .. cmd)
--   local f = os.execute(cmd)
--   if f == 0 then
--     print('\nBuild: ✔️ ')
--   else
--     print('\nBuild: ❌ (code: ' .. f .. ')')
--   end
-- end
--
-- vim.g.dotnet_get_dll_path = function()
--   local request = function()
--     return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
--   end
--
--   if vim.g['dotnet_last_dll_path'] == nil then
--     vim.g['dotnet_last_dll_path'] = request()
--   else
--     if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
--       vim.g['dotnet_last_dll_path'] = request()
--     end
--   end
--
--   return vim.g['dotnet_last_dll_path']
-- end
--
--
--
-- dap.adapters.coreclr = {
--   type = 'executable',
--   -- command = 'C:/Users/ludwi/AppData/Local/nvim-data/mason/bin/netcoredbg',
--   command = 'C:/Users/8746/AppData/Local/nvim-data/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe',
--   args = { '--interpreter=vscode' }
-- }
-- dap.configurations.cs = {
--   {
--     type = "coreclr",
--     name = "launch - netcoredbg",
--     request = "launch",
--     program = function()
--       -- return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
--       if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
--         vim.g.dotnet_build_project()
--       end
--       return vim.g.dotnet_get_dll_path()
--     end,
--     env = {
--       ASPNETCORE_ENVIRONMENT = function()
--         -- todo: request input from ui
--         return "Development"
--       end,
--       ASPNETCORE_URLS = function()
--         -- todo: request input from ui
--         return "http://localhost:5050"
--       end,
--     },
--     cwd = function()
--       return vim.fn.input("Workspace folder: ", vim.fn.getcwd() .. "/", "file")
--     end,
--   },
-- }
--
-- dapui.setup()
--
-- vim.keymap.set('n', '<leader>do', function()
--   dapui.open()
-- end, { desc = "[O]pen UI" })
--
-- vim.keymap.set('n', '<leader>dp', function()
--   dapui.close()
-- end, { desc = "[P]close UI" })
--
-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   dapui.close()
-- end
--
--
--
-- -- vim.keymap.set('n', '<leader>dc', "<cmd>:lua require('dap').continue()<CR>")
-- -- vim.keymap.set('n', '<leader>db', "<cmd>:lua require('dap').toggle_breakpoint()<CR>")
--
-- vim.keymap.set('n', '<leader>dc', function() dap.continue() end, { desc = "[C]ontinue/Start Debugging" })
-- vim.keymap.set('n', '<leader>dq', function() dap.step_over() end, { desc = "[Q] Step over" })
-- vim.keymap.set('n', '<leader>dw', function() dap.step_into() end, { desc = "[W] Step into" })
-- vim.keymap.set('n', '<leader>de', function() dap.step_out() end, { desc = "[E] Step out" })
-- vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = "Set [B]reakpoint" })
--


-- nvim-cmp setup
local cmp = require 'cmp'
-- local luasnip = require 'luasnip'

-- luasnip.config.setup {}

cmp.setup {
  window = {
    completion = {
      border = 'rounded',
      scrollbar = '║',
    },
  },
  -- snippet = {
  --   expand = function(args)
  --     luasnip.lsp_expand(args.body)
  --   end,
  -- },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- open suggestions without writing
    ['<C-s>'] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    -- ['<Tab>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   elseif luasnip.expand_or_jumpable() then
    --     luasnip.expand_or_jump()
    --   else
    --     fallback()
    --   end
    -- end, { 'i', 's' }),
    -- ['<S-Tab>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_prev_item()
    --   elseif luasnip.jumpable(-1) then
    --     luasnip.jump(-1)
    --   else
    --     fallback()
    --   end
    -- end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    -- { name = 'luasnip' },
    { name = 'nvim_lsp_signature_help' },
  },
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
