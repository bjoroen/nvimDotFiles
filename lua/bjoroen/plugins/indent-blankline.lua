local setup, blankline = pcall(require, "ibl")
if not setup then
	return
end

blankline.setup({ scope = { show_start = false, show_end = false } })
