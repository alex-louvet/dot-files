-- Config was built using the following config:
-- https://github.com/numToStr/dotfiles/tree/master/neovim/.config/nvim/
-- https://gitlab.com/dwt1/dotfiles/-/blob/master/.config/nvim/init.lua

-- Vanilla Config
require("config.settings")
require("config.autocmd")
require("config.plugins")
require("config.keybinds")

-- Setups
vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
require("catppuccin").setup()
vim.cmd([[colorscheme catppuccin]])

require("lualine").setup()
require("nvim-tree").setup({
	open_on_setup_file = false,
})
require("true-zen").setup({
	integrations = {
		twilight = true,
	},
})
require("twilight").setup({
	context = 2,
})

require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all"
	ensure_installed = {
		"bash",
		"bibtex",
		"c",
		"comment",
		"css",
		"fish",
		"haskell",
		"html",
		"javascript",
		"json",
		"latex",
		"lua",
		"markdown",
		"org",
		"python",
		"rust",
		"scss",
		"toml",
		"typescript",
		"vue",
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	auto_install = true,

	-- List of parsers to ignore installing (for "all")
	-- ignore_install = { "javascript" },

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		-- disable = { "c", "rust" },

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true, -- default is disabled anyways
	},
})
require("mason").setup({
	ui = {
		border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})
require("mason-lspconfig").setup({
	ensure_installed = { "html", "hls", "tsserver", "texlab", "sumneko_lua", "marksman", "pyright", "rust_analyzer" },
	automatic_installation = true,
})

require("telescope").setup({
	defaults = {
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		set_env = { ["COLORTERM"] = "truecolor" },
	},
})

require("nvim-autopairs").setup()
require("Comment").setup()

require("luasnip.loaders.from_vscode").lazy_load()

local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	sources = {
		-- Code Actions
		null_ls.builtins.code_actions.eslint_d,
		null_ls.builtins.code_actions.proselint,
		null_ls.builtins.code_actions.shellcheck,
		null_ls.builtins.code_actions.refactoring,

		-- Completion
		null_ls.builtins.completion.luasnip,
		null_ls.builtins.completion.spell,

		-- Formatting
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.eslint_d,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.codespell,
		null_ls.builtins.formatting.latexindent,
		null_ls.builtins.formatting.markdownlint,
		null_ls.builtins.formatting.rustfmt,

		-- Diagnostic
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.diagnostics.chktex,
		null_ls.builtins.diagnostics.codespell,
		null_ls.builtins.diagnostics.fish,
		null_ls.builtins.diagnostics.luacheck,
		null_ls.builtins.diagnostics.markdownlint,
		null_ls.builtins.diagnostics.pylint,

		-- Hover
		null_ls.builtins.hover.dictionary,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					vim.lsp.buf.formatting_sync()
				end,
			})
		end
	end,
})

-- LSP config
require("lspconfig").html.setup({})
require("lspconfig").hls.setup({})
require("lspconfig").tsserver.setup({})
require("lspconfig").texlab.setup({})
require("lspconfig").sumneko_lua.setup({
	on_attach = function(client, bufnr)
		client.resolved_capabilities.document_formatting = false
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>", {})
	end,
})
require("lspconfig").marksman.setup({})
require("lspconfig").pyright.setup({})
require("lspconfig").rust_analyzer.setup({
	on_attach = function(client, bufnr)
		client.resolved_capabilities.document_formatting = false
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>", {})
	end,
})
