local function map(m, k, v)
	vim.keymap.set(m, k, v, { silent = true })
end

-- Mover around buffers
map("n", "<C-h>", ":wincmd h<CR>")
map("n", "<C-j>", ":wincmd j<CR>")
map("n", "<C-k>", ":wincmd k<CR>")
map("n", "<C-l>", ":wincmd l<CR>")

-- NvimTree map
map("n", "<C-n>", ":NvimTreeToggle<CR>")

-- Zen mode
map("n", "<leader>zz", ":TZAtaraxis<CR>")

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>")
map("n", "<leader>fg", ":Telescope live_grep<CR>")
map("n", "<leader>fb", ":Telescope buffers<CR>")
map("n", "<leader>fh", ":Telescope help_tags<CR>")

-- LSP
map("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
map("n", "<leader>lh", ":lua vim.lsp.buf.hover()<CR>")
map("n", "gi", ":lua vim.lsp.buf.implementation()<CR>")
map("n", "<leader>rn", ":lua vim.lsp.utils.rename()<CR>")
map("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>")
map("n", "gr", ":lua vim.lsp.buf.references()<CR>")
map("n", "<leader>ld", ":lua vim.diagnostic.open_float()<CR>")
map("n", "[d", ":lua vim.diagnostic.goto_prev()<CR>")
map("n", "]d", ":lua vim.diagnostic.goto_next()<CR>")
map("n", "<leader>lq", ":lua vim.diagnostic.setloclist()<CR>")
map("n", "<leader>lf", ":lua vim.lsp.buf.formatting()<CR>")
