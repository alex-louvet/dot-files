require("packer").startup(function()
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- A better status line
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- File management --
	use("ryanoasis/vim-devicons")
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icons
		},
	})
	use({
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	})

	-- Tim Pope Plugins --
	use("tpope/vim-surround")

	-- Syntax Highlighting and Colors --
	use({
		"numToStr/Comment.nvim",
	})
	use({
		"windwp/nvim-autopairs",
	})

	-- Zen mode Plugins --
	use({
		"Pocco81/true-zen.nvim",
		config = function()
			require("true-zen").setup({
				integrations = {
					twilight = true,
				},
			})
		end,
	})
	use({
		"folke/twilight.nvim",
		config = function()
			require("twilight").setup({
				context = 2,
			})
		end,
	})

	-- Colorschemes
	use("RRethy/nvim-base16")

	-- LSP and more
	use("nvim-treesitter/nvim-treesitter")
	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	})
	use("jose-elias-alvarez/null-ls.nvim")
	use("L3MON4D3/LuaSnip")
end)
