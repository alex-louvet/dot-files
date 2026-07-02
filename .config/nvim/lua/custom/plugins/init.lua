-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    ft = { 'markdown' },
  },
  {
    'OXY2DEV/markview.nvim',
    lazy = false,

    -- Completion for `blink.cmp`
    dependencies = { 'saghen/blink.cmp' },
    ---@type markview.config
    opts = {
      preview = {
        -- Modes where the full preview is shown
        modes = { 'n', 'no', 'c' },

        -- Modes where hybrid mode is active (must overlap with `modes`)
        hybrid_modes = { 'n' },

        -- KEY OPTION: clear lines around cursor instead of by TS node
        linewise_hybrid_mode = true,

        -- How many lines above/below cursor to clear in linewise mode
        -- { 0, 0 } = only the cursor line; { 1, 1 } = 3 lines total, etc.
        edit_range = { 0, 0 },
      },
      markdown = {
        headings = {
          heading_1 = { style = 'icon', icon = '󰼏  ', sign = '󰌕 ', sign_hl = 'MarkviewHeading1Sign', hl = 'MarkviewHeading1' },
          heading_2 = { style = 'icon', icon = '󰎨  ', sign = '󰌖 ', sign_hl = 'MarkviewHeading2Sign', hl = 'MarkviewHeading2' },
          heading_3 = { style = 'icon', icon = '󰼑  ', hl = 'MarkviewHeading3' },
          heading_4 = { style = 'icon', icon = '󰎲  ', hl = 'MarkviewHeading4' },
          heading_5 = { style = 'icon', icon = '󰼓  ', hl = 'MarkviewHeading5' },
          heading_6 = { style = 'icon', icon = '󰎴  ', hl = 'MarkviewHeading6' },
          shift_width = 1,
        },
      },
    },
    config = function(_, opts)
      require('markview').setup(opts)
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          vim.api.nvim_set_hl(0, 'MarkviewHeading1', { fg = '#e06c75', bg = '#2d2223', bold = true })
          vim.api.nvim_set_hl(0, 'MarkviewHeading2', { fg = '#e5c07b', bg = '#2d2a1e', bold = true })
          vim.api.nvim_set_hl(0, 'MarkviewHeading3', { fg = '#98c379', bg = '#1e2d1e', bold = true })
          vim.api.nvim_set_hl(0, 'MarkviewHeading4', { fg = '#56b6c2', bg = '#1a2a2d', bold = true })
          vim.api.nvim_set_hl(0, 'MarkviewHeading5', { fg = '#61afef', bg = '#1a2233', bold = true })
          vim.api.nvim_set_hl(0, 'MarkviewHeading6', { fg = '#c678dd', bg = '#261a2d', bold = true })
        end,
      })
      vim.api.nvim_exec_autocmds('ColorScheme', {})
    end,
  },
  {
    'matkrin/telescope-spell-errors.nvim',
    config = function()
      require('telescope').load_extension 'spell_errors'
    end,
    dependencies = 'nvim-telescope/telescope.nvim',
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
  {
    'tjdevries/present.nvim',
    dependencies = { 'folke/snacks.nvim' },
    ft = { 'markdown' },
  },
  {
    '3rd/image.nvim',
    enabled = false,
    ft = { 'markdown' },
    opts = {

      backend = 'kitty', -- or "ueberzug" or "sixel"
      processor = 'magick_cli', -- or "magick_rock"
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = 'inline', -- or "inline"
          floating_windows = true, -- if true, images will be rendered in floating markdown windows
          filetypes = { 'markdown', 'vimwiki' }, -- markdown extensions (ie. quarto) can go here
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      scale_factor = 1.0,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', 'snacks_notif', 'scrollview', 'scrollview_sign' },
      editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
      hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' }, -- render image files as images when opened
    },
  },
  {
    'lervag/wiki.vim',
    -- tag = "v0.10", -- uncomment to pin to a specific release
    init = function()
      -- wiki.vim configuration goes here, e.g.
    end,
  },
  {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    enabled = false,
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  },
  {
    'benlubas/molten-nvim',
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.molten_image_provider = 'none'
      vim.g.molten_output_win_max_height = 12

      -- NEW: Show code execution results as non-blocking virtual text
      vim.g.molten_show_virtual_text = true
      vim.g.molten_virt_text_output = true
      -- Centers the text or wraps it gracefully
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_lines_prefix_char = ' \n '
      vim.g.molten_virt_lines_suffix_char = ' \n '
    end,
    config = function()
      -- Change the color of the output text itself (e.g., to a distinct teal/cyan)
      vim.api.nvim_set_hl(0, 'MoltenVirtualText', { fg = '#00ADB5', italic = true })

      -- Optional: Change the color of the little "Output:" prefix label
      vim.api.nvim_set_hl(0, 'MoltenVirtualTextOutput', { fg = '#FF2E63', bold = true })
    end,
  },
  {
    'goerz/jupytext.nvim',
    version = '*',
    lazy = false,
    opts = {
      update = true,
      -- Force Jupytext to ALWAYS present notebooks as percent-style Python code
      format = 'py:percent',
      -- Explicitly tell Neovim to treat these buffers as Python
      filetype = 'python',
    },
    config = function(_, opts)
      require('jupytext').setup(opts)

      -- Automate pairing and syncing when saving a standard script
      local sync_grp = vim.api.nvim_create_augroup('JupytextSyncBackend', { clear = true })
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = sync_grp,
        pattern = '*.py',
        callback = function()
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          local is_notebook = false
          for _, line in ipairs(lines) do
            if line:match '^# %%%%-*' or line:match '^# %%' then
              is_notebook = true
              break
            end
          end

          if is_notebook then
            local current_file = vim.fn.expand '%:p'
            vim.fn.jobstart { 'jupytext', '--set-formats', 'py:percent,ipynb', '--sync', current_file }
          end
        end,
      })
    end,
  },

  -- 2. Molten Engine
  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.molten_image_provider = 'none'
      vim.g.molten_output_win_max_height = 15
      vim.g.molten_show_virtual_text = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_prefix = ' ↳ '
      vim.g.molten_virt_lines_suffix_char = ' \n '
    end,
    config = function()
      vim.api.nvim_set_hl(0, 'MoltenVirtualText', { fg = '#00ADB5', italic = true })
    end,
  },

  -- 3. NotebookNavigator (Handles cell hopping & execution natively)
  {
    'GCBallesteros/NotebookNavigator.nvim',
    keys = {
      {
        ']x',
        function()
          require('notebook-navigator').move_cell 'd'
        end,
        desc = 'Next code cell',
      },
      {
        '[x',
        function()
          require('notebook-navigator').move_cell 'u'
        end,
        desc = 'Prev code cell',
      },
      {
        '<leader>X',
        function()
          require('notebook-navigator').run_cell()
        end,
        desc = 'Run current cell',
      },
    },
    dependencies = { 'echasnovski/mini.nvim' },
    opts = {
      activate_hydra_keys = nil,
      repl_backend = 'molten',
    },
    ft = { 'python' },
  },
  -- {
  --   'folke/snacks.nvim',
  --   ---@type snacks.Config
  --   opts = {
  --     scroll = {},
  --   },
  -- },
}
