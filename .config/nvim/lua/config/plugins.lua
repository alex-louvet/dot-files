require('lualine').setup()
require("nvim-tree").setup({
    open_on_setup_file = false
})
require("true-zen").setup({
    integrations = {
        twilight = true
    }
})
require("twilight").setup({
    context = 2
})

require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- A better status line
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- File management --
    use 'ryanoasis/vim-devicons'
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        }
    }

    -- Tim Pope Plugins --
    use 'tpope/vim-surround'

    -- Syntax Highlighting and Colors --
    use 'vim-python/python-syntax'
    use 'ap/vim-css-color'

    -- Zen mode Plugins --
    use({
        "Pocco81/true-zen.nvim",
        config = function()
            require("true-zen").setup {
                integrations = {
                    twilight = true
                }
            }
        end,
    })
    use {
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup {
                context = 2
            }
        end
    }

    -- Colorschemes
    use 'RRethy/nvim-base16'
end
)
