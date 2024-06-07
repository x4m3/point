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
        ensure_installed = { "lua", "vim", "vimdoc", "regex" },
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
        current_line_blame_formatter = "<author> • <author_time:%Y-%m-%d> • <summary>",
        current_line_blame_formatter_opts = {
          relative_time = true,
        },
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Hunk Stage" })
          map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Hunk Reset" })
          map("v", "<leader>hs", function() gitsigns.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end,
            { desc = "Visual Hunk Stage" })
          map("v", "<leader>hr", function() gitsigns.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end,
            { desc = "Visual Hunk Reset" })
          map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Hunk Undo Stage" })
          map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Hunk Preview" })
          map("n", "<leader>hb", function() gitsigns.blame_line { full = true } end, { desc = "Hunk Blame" })
          map("n", "<leader>h]", gitsigns.next_hunk, { desc = "Hunk Next" })
          map("n", "<leader>h[", gitsigns.prev_hunk, { desc = "Hunk Previous" })
        end
      })

      require("scrollbar.handlers.gitsigns").setup()
    end
  },
  { -- automatically open/close braces
    "Raimondi/delimitMate"
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
      { "onsails/lspkind.nvim" },                           -- pictograms
      { "hrsh7th/cmp-calc" },                               -- calc
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        preselect = "item",
        formatting = {
          format = require("lspkind").cmp_format({
            mode = "symbol_text",
            preset = "codicons",
            maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
            ellipsis_char = "...",
            -- TODO: improve menu layout
          })
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<ScrollWheelUp>"] = cmp.mapping.scroll_docs(-6),
          ["<ScrollWheelDown>"] = cmp.mapping.scroll_docs(6),
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
          { name = "luasnip",                keyword_length = 2 },
          { name = "buffer",                 keyword_length = 3 },
          { name = "async_path" },
          { name = "emoji" },
          { name = "calc" },
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
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
      { -- show when code action is available
        "kosayoda/nvim-lightbulb"
      },
      { -- vscode icons (required nerdfont)
        "mortepau/codicons.nvim"
      },
    },
    opts = {
      inlay_hints = {
        enabled = true,
      },
    },
    config = function()
      -- register icons
      local codicons = require("codicons")
      local signs = {
        { name = "DiagnosticSignError", text = codicons.get("error") },
        { name = "DiagnosticSignWarn",  text = codicons.get("warning") },
        { name = "DiagnosticSignHint",  text = codicons.get("lightbulb") },
        { name = "DiagnosticSignInfo",  text = codicons.get("info") },
      }
      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      -- show when code action is available
      require("nvim-lightbulb").setup({
        autocmd = {
          enabled = true,
        },
        sign = {
          text = codicons.get("lightbulb-sparkle")
        },
      })

      -- define default lsp capabilities
      local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
      local default_setup = function(server)
        require("lspconfig")[server].setup({
          capabilities = lsp_capabilities,
        })
      end

      local lspconfig = require("lspconfig")
      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rust_analyzer", "taplo", "jsonls" },
        automatic_installation = true,
        handlers = {
          -- default lsp setup
          default_setup,

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
            local runtime_path = vim.split(package.path, ";")
            table.insert(runtime_path, "lua/?.lua")
            table.insert(runtime_path, "lua/?/init.lua")

            local config = {
              settings = {
                Lua = {
                  -- Disable telemetry
                  telemetry = { enable = false },
                  runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    path = runtime_path,
                  },
                  diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" }
                  },
                  workspace = {
                    checkThirdParty = false,
                    library = {
                      -- Make the server aware of Neovim runtime files
                      vim.fn.expand("$VIMRUNTIME/lua"),
                      vim.fn.stdpath("config") .. "/lua"
                    }
                  }
                }
              }
            }

            local lua_opts = vim.tbl_deep_extend("force", config, {})
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
  { -- show which key is what
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  },
  { -- tabline
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
        hide_if_all_visible = true,
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
  { -- UI replacement
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
        override = {
          -- override the default lsp markdown formatter with Noice
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          -- override the lsp markdown formatter with Noice
          ["vim.lsp.util.stylize_markdown"] = true,
          -- override cmp documentation with Noice (needs the other options to work)
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        lsp_doc_border = true, -- nice border when hovering
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        config = function()
          require("notify").setup {
            fps = 60,
            stages = "slide",
            timeout = 1500,
          }
        end
      }
    }
  },
  { -- surround
    "tpope/vim-surround"
  },
  { -- programming dictionary
    "psliwka/vim-dirtytalk",
    build = ":DirtytalkUpdate",
    config = function()
      vim.o.spelllang = vim.o.spelllang .. ",programming"
    end,
  },
  { -- distraction free
    "folke/zen-mode.nvim",
  },
  { -- markdown preview
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
})

-- update time for git status in files
vim.opt.updatetime = 50

-- LSP key mappings
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Floating diagnostic" })
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next diagnostic" })

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    -- enable inlay hints
    vim.lsp.inlay_hint.enable()

    local opts = { buffer = event.buf }

    -- TODO: descriptions

    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.keymap.set("n", "==", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", opts)
    vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  end
})

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
-- telescope extensions
require("telescope").load_extension "ui-select"
require("telescope").load_extension "notify"

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find Grep" })
vim.keymap.set("n", "<leader>fo", builtin.buffers, { desc = "Find opened buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })
vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Find string" })
vim.keymap.set("n", "<leader>fw", builtin.lsp_dynamic_workspace_symbols, { desc = "Find LSP symbols in workspace" })
vim.keymap.set("n", "<leader>fn", require("telescope").extensions.notify.notify, { desc = "Find past notifications" })

local lualine_refresh = 80

local navic = require("nvim-navic")

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
    lualine_c = { "branch", "diff" },
    lualine_x = { "diagnostics" },
    lualine_y = { "filetype", "encoding", "fileformat" },
    lualine_z = { "progress", "location" },
  },
  tabline = {},
  winbar = {
    lualine_a = {
      { -- file breadcrumbs
        function()
          if navic.is_available() then
            local ret = navic.get_location()
            if string.len(ret) == 0 then
              ret = "🏁 -- Start here"
            end
            return ret
          else
            return "👀 -- Nothing to see here"
          end
        end
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
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

  -- Paste from system clipboard
  vim.api.nvim_create_user_command("Paste", function()
    vim.cmd.normal('"*p')
  end, {})
end
