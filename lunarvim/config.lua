-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
vim.opt.cmdheight = 2 -- more space in the neovim command line for displaying messages
vim.opt.guifont = "monospace:h17" -- the font used in graphical neovim applications
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.relativenumber = true -- relative line numbers
vim.opt.wrap = true -- wrap lines

-- use treesitter folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
lvim.transparent_window = true
lvim.colorscheme = "onedark"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.format_on_save.enabled = false
lvim.log.level = "warn"
lvim.builtin.lualine.style = "default"
lvim.plugins = {
  {
    'navarasu/onedark.nvim',
    config = function()
      require('onedark').setup {
        style = 'deep',
        transparent = true,  -- Show/hide background
        term_colors = true, -- Change terminal color as per the selected theme style
        ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
        cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

        -- toggle theme style ---
        toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
        toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

        -- Change code style ---
        -- Options are italic, bold, underline, none
        -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
        code_style = {
            comments = 'italic',
            keywords = 'bold',
            functions = 'bold,underline',
            strings = 'italic',
            variables = 'none'
        },

        -- Lualine options --
        lualine = {
            transparent = false, -- lualine center bar transparency
        },

        -- Custom Highlights --
        colors = {}, -- Override default colors
        highlights = {}, -- Override highlight groups

        -- Plugins Config --
        diagnostics = {
            darker = true, -- darker colors for diagnostic
            undercurl = true,   -- use undercurl instead of underline for diagnostics
            background = true,    -- use background color for virtual text
        },
      }
    end
  },
  -- {
  --   "marko-cerovac/material.nvim",
  --   config = function()
  --     vim.g.material_style = "deep ocean"
  --     require('material').setup({

  --         contrast = {
  --             terminal = true, -- Enable contrast for the built-in terminal
  --             sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
  --             floating_windows = false, -- Enable contrast for floating windows
  --             cursor_line = false, -- Enable darker background for the cursor line
  --             lsp_virtual_text = false, -- Enable contrasted background for lsp virtual text
  --             non_current_windows = false, -- Enable contrasted background for non-current windows
  --             filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
  --         },

  --         styles = { -- Give comments style such as bold, italic, underline etc.
  --             comments = {  italic = true },
  --             strings = {italic = true },
  --             keywords = { underline = true },
  --             functions = { bold = true },
  --             variables = {},
  --             operators = {},
  --             types = {},
  --         },

  --         plugins = { -- Uncomment the plugins that you use to highlight them
  --             -- Available plugins:
  --             -- "coc",
  --             -- "colorful-winsep",
  --             -- "dap",
  --             -- "dashboard",
  --             -- "eyeliner",
  --             -- "fidget",
  --             -- "flash",
  --             -- "gitsigns",
  --             -- "harpoon",
  --             -- "hop",
  --             -- "illuminate",
  --             -- "indent-blankline",
  --             -- "lspsaga",
  --             -- "mini",
  --             -- "neogit",
  --             -- "neotest",
  --             -- "neo-tree",
  --             -- "neorg",
  --             -- "noice",
  --             -- "nvim-cmp",
  --             -- "nvim-navic",
  --             -- "nvim-tree",
  --             -- "nvim-web-devicons",
  --             -- "rainbow-delimiters",
  --             -- "sneak",
  --             -- "telescope",
  --             "trouble",
  --             -- "which-key",
  --             -- "nvim-notify",
  --         },

  --         disable = {
  --             colored_cursor = false, -- Disable the colored cursor
  --             borders = false, -- Disable borders between verticaly split windows
  --             background = false, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
  --             term_colors = false, -- Prevent the theme from setting terminal colors
  --             eob_lines = false -- Hide the end-of-buffer lines
  --         },

  --         high_visibility = {
  --             lighter = false, -- Enable higher contrast text for lighter style
  --             darker = false -- Enable higher contrast text for darker style
  --         },

  --         lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )

  --         async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)

  --         custom_colors = nil, -- If you want to override the default colors, set this to a function

  --         custom_highlights = {}, -- Overwrite highlights with your own
  --     })
  --   end,
  -- },
  -- {
  --   "sindrets/diffview.nvim",
  --   event = "BufRead",
  -- },
  -- {
  --   "f-person/git-blame.nvim",
  --   event = "BufRead",
  --   config = function()
  --     vim.cmd "highlight default link gitblame SpecialComment"
  --     vim.g.gitblame_enabled = 0
  --   end,
  -- },
  --
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter').setup {
        options = {
          theme = 'onedark'
        }
      }
    end
  },
  {
    'sindrets/diffview.nvim'
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      require("gitblame").setup { enabled = true }
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = {
        fg = "NONE", -- The gui style to use for the fg highlight group.
        bg = "BOLD", -- The gui style to use for the bg highlight group.
      },
      merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- highlighting of the line containing the todo comment
      -- * before: highlights before the keyword (typically comment characters)
      -- * keyword: highlights of the keyword
      -- * after: highlights after the keyword (todo text)
      highlight = {
        multiline = true, -- enable multine todo comments
        multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
        before = "", -- "fg" or "bg" or empty
        keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      -- list of named colors where we try to extract the guifg from the
      -- list of highlight groups or use the hex color if hl not found as a fallback
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF00FF" }
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    }
  },

  {
    "folke/trouble.nvim",
      cmd = "TroubleToggle",
  },


  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
          '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true,          -- Hide cursor while scrolling
        stop_eof = true,             -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil,       -- Default easing function
        pre_hook = nil,              -- Function to run before the scrolling animation starts
        post_hook = nil,             -- Function to run after the scrolling animation ends
      })
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1
    end,
  },
  {
    "kristijanhusak/vim-carbon-now-sh"
  },
  {
    "ibhagwan/fzf-lua"
  },
  {
      'dense-analysis/ale',
      config = function()
          -- Configuration goes here.
          local g = vim.g

          g.ale_ruby_rubocop_auto_correct_all = 1

          g.ale_linters = {
              ruby = {'rubocop', 'ruby'},
              lua = {'lua_language_server'}
          }
      end
  },
  {
    'neoclide/coc.nvim'
  },
  {
  -- AI
    "Bryley/neoai.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    cmd = {
        "NeoAI",
        "NeoAIOpen",
        "NeoAIClose",
        "NeoAIToggle",
        "NeoAIContext",
        "NeoAIContextOpen",
        "NeoAIContextClose",
        "NeoAIInject",
        "NeoAIInjectCode",
        "NeoAIInjectContext",
        "NeoAIInjectContextCode",
    },
    keys = {
        { "<leader>as", desc = "summarize text" },
        { "<leader>ag", desc = "generate git message" },
    },
    config = function()
        require("neoai").setup({
            -- Options go here
        })
    end
  }
  -- {
  --   "ethanholz/nvim-lastplace",
  --   event = "BufRead",
  --   config = function()
  --     require("nvim-lastplace").setup({
  --       lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
  --       lastplace_ignore_filetype = {
  --         "gitcommit", "gitrebase", "svn", "hgcommit",
  --       },
  --       lastplace_open_folds = true,
  --     })
  --   end,
  -- },
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = "black" },
  {
    name = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespace
    -- options such as `--line-width 80` become either `{"--line-width", "80"}` or `{"--line-width=80"}`
    args = { "--print-width", "100" },
    ---@usage only start in these filetypes, by default it will attach to all filetypes it supports
    filetypes = { "typescript", "typescriptreact" },
  },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { name = "flake8" },
  {
    name = "shellcheck",
    args = { "--severity", "warning" },
  },
}

local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  {
    name = "proselint",
  },
}
vim.cmd [[
  augroup remember_folds
    autocmd!
    autocmd BufWinLeave *.* mkview
    autocmd BufWinEnter *.* silent! loadview
  augroup END
]]
vim.cmd('autocmd BufRead,BufNewFile .env lua vim.diagnostic.disable()')

lvim.icons.ui.Folder = "󰉋"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git = { staged = "✓", untracked = "★" }
