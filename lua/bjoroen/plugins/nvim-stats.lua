local Job = require("plenary.job")

local shouldWrite = true
local data = {
	timestamp_start = "",
	timestamp_end = "",
}

local send_data = function()
	data.timestamp_end = tostring(os.time())
	shouldWrite = true

	local json_data = '{"timestamp_start": "'
		.. data.timestamp_start
		.. '", "timestamp_end": "'
		.. data.timestamp_end
		.. '"}'
	Job:new({
		command = "nvim-stats",
		args = { "--json", json_data },
	}):start()
end

local start_time = function()
	if shouldWrite then
		shouldWrite = false
		data.timestamp_start = tostring(os.time())
	end
end

vim.api.nvim_create_autocmd("CursorMoved", {
	callback = start_time,
})

vim.api.nvim_create_autocmd("CursorMovedI", {
	callback = start_time,
})

vim.api.nvim_create_autocmd("CursorHold", {
	callback = send_data,
})

vim.api.nvim_create_autocmd("CursorHoldI", {
	callback = send_data,
})

vim.api.nvim_create_autocmd("UILeave", {
	callback = send_data,
})
