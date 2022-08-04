local A = vim.api
local o = vim.o

-- Highlight the region on yank
A.nvim_create_autocmd("TextYankPost", {
	group = num_au,
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 120 })
	end,
})

-- Close NvimTree when no file is open
A.nvim_create_autocmd("BufEnter", {
	group = A.nvim_create_augroup("NvimTreeClose", { clear = true }),
	callback = function()
		local layout = A.nvim_call_function("winlayout", {})
		if
			layout[1] == "leaf"
			and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
			and layout[3] == nil
		then
			vim.cmd("quit")
		end
	end,
})
