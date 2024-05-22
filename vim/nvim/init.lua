-- plugins manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
vim.g.mapleader = ";"
vim.g.maplocalleader = ","

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- search, and clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- mode is already in status line, don't show it
vim.opt.showmode = false

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
  },
  { -- todo.txt support
    "freitass/todo.txt-vim"
  },
  { -- git
    "tpope/vim-fugitive"
  },
  { -- outline of file
    "https://git.sr.ht/~hedy/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    opts = {},
  },
  { -- indent helper
    "echasnovski/mini.indentscope",
    version = false,
  },
  { -- project tree
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  { -- git commit
    "rhysd/committia.vim"
  },
  { -- git status in files
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function()
          local gs = package.loaded.gitsigns
          vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
        end
      })

      require("scrollbar.handlers.gitsigns").setup()
    end
  },
  { -- git blame info
    "f-person/git-blame.nvim"
  },
  { -- automatically open/close braces
    "Raimondi/delimitMate"
  },
  { -- lsp helper
    -- TODO: remove and do everything by hand
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
      { "hrsh7th/cmp-buffer" },                             -- use text in buffer
      { "https://codeberg.org/FelipeLema/cmp-async-path" }, -- filesystem path
      { "hrsh7th/cmp-nvim-lsp-signature-help" },            -- current parameter from signature
      { "hrsh7th/cmp-nvim-lua" },                           -- neovim lua api
      { "hrsh7th/cmp-emoji" },                              -- emoji
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
          ["<Tab>"] = cmp_action.luasnip_supertab(),
          ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-k>"] = cmp.mapping.scroll_docs(-4),
          ["<C-j>"] = cmp.mapping.scroll_docs(4),
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
          { name = "nvim_lua" },
          { name = "nvim_lsp_signature_help" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "async_path" },
          { name = "emoji" },
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
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } }
      },
      {
        "SmiteshP/nvim-navic",
        opts = { lsp = { auto_attach = true } }
      },
      { "b0o/schemastore.nvim" },
      { -- lsp status
        "j-hui/fidget.nvim",
        tag = "v1.0.0",
        opts = {
          progress = {
            display = {
              render_limit = false, -- How many LSP messages to show at once
              done_ttl = 5, -- How long a message should persist after completion
              done_icon = "✅", -- Icon shown when all LSP progress tasks are complete
              done_style = "Constant", -- Highlight group for completed LSP tasks
              progress_ttl = math.huge, -- How long a message should persist when in progress
              progress_icon = {
                pattern = {
                  -- mix of "bouncingBall" and "point" from https://github.com/sindresorhus/cli-spinners
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
                period = 1
              },
              progress_style = "WarningMsg", -- Highlight group for in-progress LSP tasks
              group_style = "Title",         -- Highlight group for group name (LSP server name)
              icon_style = "Question",       -- Highlight group for group icons
            },
          },

        },
      },
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
        vim.lsp.inlay_hint.enable()
      end)

      lsp_zero.set_sign_icons({
        error = "✘",
        warn = "▲",
        hint = "⚑",
        info = "»"
      })

      local lspconfig = require("lspconfig")
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rust_analyzer", "taplo", "jsonls" },
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
                  cargo = {
                    buildScripts = {
                      enable = true,
                    },
                    features = "all",
                  },
                  procMacro = {
                    enable = true
                  },
                }
              }
            })
          end,

          -- json schema
          jsonls = function()
            lspconfig.jsonls.setup({
              settings = {
                json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
                },
              },
            })
          end,

          -- lua
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            lspconfig.lua_ls.setup(lua_opts)
          end,

          -- tailwind with support for rust
          tailwindcss = function()
            lspconfig.tailwindcss.setup({
              settings = {
                includeLanguages = {
                  rust = "html",
                },
              },
              filetype = {
                "rust",
              },
            })
          end
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
  -- TODO: remove lsp_zero
  -- TODO: add https://github.com/onsails/lspkind.nvim

  -- helper to show which key is mapped to what
  -- TODO: make it work with existing bindings
  -- {
  --   "folke/which-key.nvim",
  --   event = "VeryLazy",
  --   init = function()
  --     vim.o.timeout = true
  --     vim.o.timeoutlen = 1000
  --   end,
  --   opts = {}
  -- },
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
  { -- git diff view / conflict
    "sindrets/diffview.nvim",
  },
  { -- telescope ui selector
    "nvim-telescope/telescope-ui-select.nvim"
  },
  { -- color selector
    "uga-rosa/ccc.nvim",
    config = function()
      local ccc = require "ccc"
      ccc.setup {
        highlighter = {
          auto_enable = true,
          lsp = true
        }
      }
    end
  },
  {
    "vidocqh/data-viewer.nvim",
    opts = {
      autoDisplayWhenOpenFile = true,
      view = {
        float = false,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua"
    }
  },
  { -- keep casing in substitutions
    -- Visual mode :'<,'>%SubstituteCase/aaa/bbb/g
    -- Normal mode :%SubstituteCase/aaa/bbb/g
    "vim-scripts/keepcase.vim"
  },
  { -- scrollbar
    "petertriho/nvim-scrollbar",
    config = function()
      local colors = require("catppuccin.palettes").get_palette "mocha"

      require("scrollbar").setup({
        handle = {
          color = colors.surface2,
        },
        marks = {
          Cursor = { text = " ", color = colors.surface2 },
          Search = { color = colors.orange },
          Error = { color = colors.error },
          Warn = { color = colors.warning },
          Info = { color = colors.info },
          Hint = { color = colors.hint },
          Misc = { color = colors.purple },
        }
      })
    end
  },
  { -- highlight search
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("scrollbar.handlers.search").setup({
      })
    end,
  },
  { -- system clipboard with ssh support, highlights copied text
    "ibhagwan/smartyank.nvim",
    config = function()
      require("smartyank").setup({
        highlight = {
          timeout = 420,
        }
      })
    end
  },
})

-- update time for git status in files
vim.opt.updatetime = 50

-- key mappings
vim.keymap.set("n", "==", vim.lsp.buf.format, { desc = "Reformat file with LSP" })

-- tab navigation
vim.api.nvim_set_keymap("n", "<c-Tab>", ":bnext<CR>", { noremap = true, silent = true })

-- windows navigation
vim.api.nvim_set_keymap("n", "<Tab>", "<c-W>w", { noremap = true })
vim.api.nvim_set_keymap("n", "<S-Tab>", "<c-W>W", { noremap = true })

-- TODO: map go back and forth using leader

-- file browser
vim.api.nvim_create_user_command("Files", ":NvimTreeFindFileToggle", {})

-- git tool
-- TODO: config for layout view
-- TODO: disable winbar when entering and re-enable it when exiting
vim.keymap.set("n", "<leader>gdo", ":DiffviewOpen<CR>", { desc = "Git diff open" })
vim.keymap.set("n", "<leader>gdc", ":DiffviewClose<CR>", { desc = "Git diff close" })
vim.keymap.set("n", "<leader>glb", ":DiffviewFileHistory<CR>", { desc = "Show branch history" })
vim.keymap.set("n", "<leader>glf", ":DiffviewFileHistory %<CR>", { desc = "Show file history" })

-- project tree
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
require("nvim-tree").setup({
  view = {
    width = 50,
    side = "right"
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },
})

-- indent lines
local indent_char = "▏"
require("mini.indentscope").setup({
  draw = {
    delay = 10,
  },
  symbol = indent_char,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Disable indentscope for certain filetypes",
  callback = function()
    local ignore_filetypes = {
      "help",
      "lazy",
      "mason",
      "NvimTree",
      "Trouble"
    }
    if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
      vim.b.miniindentscope_disable = true
    end
  end,
})

-- telescope
require("telescope").setup {
  defaults = {
    layout_strategy = "center",
  },
  pickers = {
    find_files = {
      hidden = true
    }
  }
}
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find Grep" })
vim.keymap.set("n", "<leader>fo", builtin.buffers, { desc = "Find opened buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })
vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Find string" })
vim.keymap.set("n", "<leader>fw", builtin.lsp_dynamic_workspace_symbols, { desc = "Find LSP symbols in workspace" })

-- telescope file browser
require("telescope").load_extension "file_browser"
vim.api.nvim_set_keymap(
  "n",
  "<leader>fb",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true, desc = "File browser" }
)

-- telescope ui selector
require("telescope").load_extension "ui-select"

local lualine_refresh = 80

-- git blame
vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
vim.g.gitblame_message_template = "<author> • <date> • <summary>"
vim.g.gitblame_date_format = "%Y-%m-%d (%r)"
vim.g.gitblame_message_when_not_committed = "Not Committed Yet"
local git_blame = require("gitblame")
local function IsGitBlameAvailable()
  if git_blame.is_blame_text_available() == false then
    return false
  end

  if git_blame.get_current_blame_text() == nil then
    return false
  end

  return true
end

-- file breadcrumbs with lsp
local function FileBreadcrumbs()
  -- TODO: replace by https://github.com/SmiteshP/nvim-navic?tab=readme-ov-file#lualine
  local breadcrumbs = require("nvim-navic")
  if not breadcrumbs.is_available() then
    return ""
  end

  return breadcrumbs.get_location()
end

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
    lualine_b = { { "filename", path = 3, shorting_target = 80, } },
    lualine_c = { "branch" },
    lualine_x = { "diagnostics", "searchcount" },
    lualine_y = { "filetype", "encoding", "fileformat" },
    lualine_z = { "progress", "location" },
  },
  tabline = {},
  winbar = {
    lualine_a = {},
    lualine_b = { FileBreadcrumbs },
    lualine_c = {},
    lualine_x = { "diff" },
    lualine_y = { { git_blame.get_current_blame_text, cond = IsGitBlameAvailable } },
    lualine_z = {},
  },
  inactive_winbar = {},
  extensions = { "trouble", "symbols-outline", "nvim-tree", "fzf", "fugitive", "mason", "lazy", "quickfix" }
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
