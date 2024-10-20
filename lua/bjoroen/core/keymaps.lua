vim.g.mapleader = " "

local k = vim.keymap

vim.api.nvim_create_user_command("DiagnosticToggle", function()
	local config = vim.diagnostic.config
	local vt = config().virtual_text
	config({
		virtual_text = not vt,
		-- underline = not vt,
		signs = not vt,
	})
end, { desc = "toggle diagnostic" })

-- Toggle error and warning
k.set("n", "<leader>tt", ":DiagnosticToggle<CR>")

-- general keymaps
k.set("i", "jk", "<ESC>")
k.set("i", "jj", "<ESC>")
k.set("i", "kk", "<ESC>")

-- Pasting
k.set("n", "<leader>p", '"0p')

-- window management
k.set("n", "<leader>|", "<C-w>v") -- split window vertically
k.set("n", "<leader>-", "<C-w>s") -- split window horizontally
k.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
k.set("n", "<leader>sx", ":close<CR>") -- close current split window

k.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
k.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
k.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
k.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

-- Save / quit
k.set("n", "<leader>w", "<cmd>w<cr>") -- Save file
k.set("n", "<leader>q", "<cmd>q<cr>") -- Quite buffer

-- No highlight
k.set("n", "<leader>h", "<cmd>noh<cr>")

-- File explorer
k.set("n", "<leader>e", ":Rexplore<CR>") -- toggle file explorer

----------------------
-- Plugin Keybind
----------------------
-- Gophher Keybinds
k.set("n", "<leader>tf", ":GoTestFile<CR>")
k.set("n", "<leader>er", ":GoIfErr<CR>")
k.set("n", "<leader>at", ":GoAddTag json<CR>")

-- vim-maximizer
k.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- Nvim-tree

-- Telescope
k.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
k.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
k.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
k.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
k.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

-- ToggleTerm
local t_opts = { silent = true }
-- k.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>")
k.set("t", "<C-k>", "<C-\\><C-N><C-w>h", t_opts)

-- Debugging
k.set("n", "<leader>db", "<cmd>DapToggleBreakpoint <CR>")
k.set("n", "<leader>dso", "<cmd>DapStepOver <CR>")
k.set("n", "<leader>dsi", "<cmd>DapStepInto <CR>")
