-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	return
end

-- import telescope builtin
local builtin_setup, builtin = pcall(require, "telescope.builtin")
if not actions_setup then
	return
end

-- configure telescope
telescope.setup({
	-- configure custom mappings
	defaults = {
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous, -- move to prev result
				["<C-j>"] = actions.move_selection_next, -- move to next result
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
			},
		},
	},
})

local k = vim.keymap

k.set("n", "<leader>gb", function()
	builtin.git_branches()
end) -- Git Branches
k.set("n", "<leader>gc", function()
	builtin.git_commits()
end) -- Git Commits

telescope.load_extension("fzf")
