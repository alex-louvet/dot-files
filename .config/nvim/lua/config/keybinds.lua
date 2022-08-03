local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end

-- Mover around buffers
map('n', '<C-h>', ':wincmd h<CR>')
map('n', '<C-j>', ':wincmd j<CR>')
map('n', '<C-k>', ':wincmd k<CR>')
map('n', '<C-l>', ':wincmd l<CR>')

-- NvimTree map
map('n', '<C-n>', ':NvimTreeToggle<CR>')

-- Zen mode
map('n', '<C-Z>', ':TZAtaraxis<CR>')
