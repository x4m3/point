-- plugins manager
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

-- leader keys
vim.g.maplocalleader = ","

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- load plugins
require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000,
    config = function()
      vim.cmd.colorscheme('catppuccin-mocha')
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          auto_install = true,
          ensure_installed = {"lua", "vim", "vimdoc"},
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
      })
    end
  }, -- syntax
  { 'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' } }, -- fuzzy finder
  { 'numToStr/Comment.nvim', opts = {} }, -- comment lines
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} }, -- list of todos
  { "folke/trouble.nvim", opts = { icons=false } }, -- report errors
  { "nvim-lualine/lualine.nvim" }, -- status line
  { "freitass/todo.txt-vim" }, -- todo.txt support
  { "tpope/vim-fugitive" }, -- git
  { "simrat39/symbols-outline.nvim" }, -- outline of file
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} }, -- indent helper
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, }, -- project tree
  { "rhysd/committia.vim" }, -- git commit
  { "lewis6991/gitsigns.nvim" }, -- git status in files
  { "Raimondi/delimitMate" }, -- automatically open/close braces
  { "mbbill/undotree" }, -- undo tree

  -- lsp helper
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = true,
  },

  -- autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
        preselect = 'item',
        formatting = lsp_zero.cmp_format(),
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({select = false}),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        }),
        completion = {
          completeopt = 'menu,menuone,noinsert'
        },
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({buffer = bufnr})
      end)

      require('mason-lspconfig').setup({
        ensure_installed = {},
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
        }
      })
    end
  },

  -- fuzzy finder file browser
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },

  -- helper to show which key is mapped to what
  -- TODO: make it work with existing bindings
  -- {
  --   "folke/which-key.nvim",
  --   event = "VeryLazy",
  --   init = function()
  --     vim.o.timeout = true
  --     vim.o.timeoutlen = 300
  --   end,
  --   opts = {}
  -- }
})

-- update time for git status in files
vim.opt.updatetime = 50

-- TODO: autocomplete file path
-- TODO: async runner
--
-- TODO: key mappings
--
--
-- TODO: map go back and forth using leader

-- git status in files
require('gitsigns').setup()

-- project tree
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
require("nvim-tree").setup({
  view = {
    width = 50,
  },
})

-- file outline
require("symbols-outline").setup()

-- indent lines
require("ibl").setup {
    indent = { char = "▏" },
    scope = { enabled = false },
}

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc="Find files"})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc="Find Grep"})
vim.keymap.set('n', '<leader>fo', builtin.buffers, {desc="Find opened buffers"})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc="Find help tags"})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {desc="Find references"})

-- telescope file browser
require("telescope").load_extension "file_browser"
vim.api.nvim_set_keymap(
  "n",
  "<leader>fb",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true, desc = "File browser" }
)

-- line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- status line
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = "catppuccin",
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {{'filename', path = 3}},
    lualine_x = {'filetype', 'encoding', 'fileformat'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {'trouble', 'symbols-outline', 'nvim-tree', 'fzf', 'fugitive', 'mason', 'lazy'}
}

-- neovide
if vim.g.neovide then
  vim.o.guifont = "JetBrains Mono:h11"
end
