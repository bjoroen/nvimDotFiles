local setup, toggleterm = pcall(require, "toggleterm")
if not setup then
	return
end

toggleterm.setup({
	size = 10,
	open_mapping = [[<c-t>]],
	shading_factor = 2,
	direction = "float",
	float_opts = {
		border = "curved",
		highlights = { border = "Normal", background = "Normal" },
	},
})
