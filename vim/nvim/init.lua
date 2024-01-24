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
  { -- theme
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  { -- syntax
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        auto_install = true,
        ensure_installed = { "lua", "vim", "vimdoc" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
  { -- fuzzy finder
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  { -- comment lines
    "numToStr/Comment.nvim",
    opts = {}
  },
  { -- list of todos
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  { -- report errors
    "folke/trouble.nvim",
    opts = { icons = false }
  },
  { -- status line
    "nvim-lualine/lualine.nvim",
    dependencies = { "WhoIsSethDaniel/lualine-lsp-progress.nvim" },
  },
  { -- todo.txt support
    "freitass/todo.txt-vim"
  },
  { -- git
    "tpope/vim-fugitive"
  },
  { -- outline of file
    "simrat39/symbols-outline.nvim"
  },
  { -- indent helper
    "echasnovski/mini.indentscope",
    version = false,
  },
  { -- indent helper
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {}
  },
  { -- project tree
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  { -- git commit
    "rhysd/committia.vim"
  },
  { -- git status in files
    "lewis6991/gitsigns.nvim"
  },
  { -- automatically open/close braces
    "Raimondi/delimitMate"
  },
  { -- lsp helper
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  { -- lsp installer
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },
  { -- autocompletion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      { "hrsh7th/cmp-buffer" }, -- use text in buffer
      { "hrsh7th/cmp-path" },   -- filesystem path
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require("cmp")
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
        preselect = "item",
        formatting = lsp_zero.cmp_format(),
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-f>"] = cmp_action.luasnip_jump_forward(),
          ["<C-b>"] = cmp_action.luasnip_jump_backward(),
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        completion = {
          completeopt = "menu,menuone,noinsert"
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end
  },
  { -- lsp config
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    opts = {
      inlay_hints = {
        enabled = true,
      },
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({ buffer = bufnr })

        -- inlay hints
        if vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(0, true)
        end
      end)

      local lspconfig = require("lspconfig")
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rust_analyzer", "taplo" },
        automatic_installation = true,
        handlers = {
          -- default configuration
          lsp_zero.default_setup,

          -- rust
          rust_analyzer = function()
            lspconfig.rust_analyzer.setup({
              settings = {
                ["rust-analyzer"] = {
                  check = {
                    command = "clippy"
                  },
                }
              }
            })
          end,

          -- lua
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            lspconfig.lua_ls.setup(lua_opts)
          end,
        }
      })
    end
  },
  { -- fuzzy finder file browser
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim"
    },
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

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  -- tabline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      local bufferline = require("bufferline")
      bufferline.setup {
        options = {
          separator_style = "slant",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            }
          },
          custom_filter = function(buf_number, buf_numbers)
            -- dont show quickfix buffers in the bufferline
            if vim.bo[buf_number].filetype ~= "qf" then
              return true
            end
          end
        }
      }
    end
  },

  { -- highlight selected words
    "rrethy/vim-illuminate"
  },
})

-- update time for git status in files
vim.opt.updatetime = 50

-- key mappings
vim.keymap.set("n", "==", vim.lsp.buf.format, { desc = "Reformat file with LSP" })

-- TODO: key mappings
--
--
-- TODO: map go back and forth using leader

-- git status in files
require("gitsigns").setup({
  on_attach = function()
    local gs = package.loaded.gitsigns
    vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
    vim.keymap.set("n", "<leader>gd", gs.diffthis, { desc = "Diff current file" })
    vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Toggle inlay blame" })
  end
})

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
local indent_char = "▏"
require('mini.indentscope').setup({
  draw = {
    delay = 10,
  },
  symbol = indent_char,
})
require("ibl").setup {
  indent = { char = indent_char },
  scope = { enabled = false },
}

-- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find Grep" })
vim.keymap.set("n", "<leader>fo", builtin.buffers, { desc = "Find opened buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })

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

local lualine_refresh = 80

-- status line for lsp
local lsp_progress = {
  "lsp_progress",
  only_show_attached = true,
  message = { initializing = "Init…", commenced = "WIP", completed = "Done" },
  timer = {
    spinner = lualine_refresh,
  },
  -- mix of "bouncingBall" and "point" from https://github.com/sindresorhus/cli-spinners
  spinner_symbols = {
    "●∙∙∙∙∙",
    "∙●∙∙∙∙",
    "∙∙●∙∙∙",
    "∙∙∙●∙∙",
    "∙∙∙∙●∙",
    "∙∙∙∙∙●",
    "∙∙∙∙●∙",
    "∙∙∙●∙∙",
    "∙∙●∙∙∙",
    "∙●∙∙∙∙",
  },
  display_components = { "spinner", "lsp_client_name", { "title", "message", } },
}

-- status line
require("lualine").setup {
  options = {
    icons_enabled = false,
    theme = "catppuccin",
    component_separators = "|",
    section_separators = "",
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = lualine_refresh,
      tabline = lualine_refresh,
      winbar = lualine_refresh,
    }
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { { "filename", path = 4 } },
    lualine_c = { lsp_progress },
    lualine_x = { "diagnostics" },
    lualine_y = { "searchcount", "filetype", "encoding", "fileformat" },
    lualine_z = { "progress", "location" },
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { "trouble", "symbols-outline", "nvim-tree", "fzf", "fugitive", "mason", "lazy" }
}
vim.o.laststatus = 3 -- removes the nvim statusbar since we are using lualine

-- neovide
if vim.g.neovide then
  function GetOS()
    -- source: https://gist.github.com/Zbizu/43df621b3cd0dc460a76f7fe5aa87f30
    local osname

    -- unix systems
    local fh = assert(io.popen("uname -o 2>/dev/null", "r"))
    if fh then
      osname = fh:read()
    end

    return osname or "Windows"
  end

  -- set font size
  local font_sizes = {
    ["GNU/Linux"] = 11,
    ["Darwin"] = 13,
    ["Windows"] = 10,
  }
  local font_size = font_sizes[GetOS()]
  vim.o.guifont = "JetBrains Mono:h" .. font_size

  -- set default directory
  if GetOS() == "Windows" then
    vim.cmd("cd $USERPROFILE")
  else
    vim.cmd("cd $HOME")
  end

  -- cursor
  vim.g.neovide_cursor_vfx_mode = "sonicboom"
  vim.g.neovide_cursor_animation_length = 0.05
end
