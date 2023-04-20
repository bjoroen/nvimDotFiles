vim.g.mapleader = " "

local k = vim.keymap

-- general keymaps
k.set("i", "jk", "<ESC>")
k.set("i", "jj", "<ESC>")
k.set("i", "kk", "<ESC>")

k.set("n", "<leader>h", ":nohl<CR>")

-- window management
k.set("n", "<leader>sv", "<C-w>v") -- split window vertically
k.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
k.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
k.set("n", "<leader>sx", ":close<CR>") -- close current split window

k.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
k.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
k.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
k.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab


-- Save 
k.set("n", "<leader>w", ":w<CR>") -- Save file


----------------------
-- Plugin Keybinds
----------------------

-- vim-maximizer
k.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- Nvim-tree
k.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer


-- Telescope
k.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
k.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
k.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
k.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
k.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags
