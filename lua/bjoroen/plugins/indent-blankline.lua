local setup, blankline = pcall(require, "indent_blankline")
if not setup then
	return
end

-- vim.cmd [[highlight IndentBlanklineContextChar guifg=#00FF00 gui=nocombine]]

blankline.setup({
	show_current_context = true,
	show_current_context_start = true,
	use_treesitter = true,
})
