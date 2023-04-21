-- import gitsigns plugin safely
local setup, gitsigns = pcall(require, "gitsigns")
if not setup then
	return
end

local function map(mode, l, r, opts)
	vim.keymap.set(mode, l, r, opts)
end

map("n", "<leader>gl", gitsigns.toggle_current_line_blame)
-- configure/enable gitsigns
gitsigns.setup()
