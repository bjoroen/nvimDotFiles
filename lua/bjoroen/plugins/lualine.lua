local status, lualine = pcall(require, "lualine")
if not status then
	return
end

lualine.setup({
	section_separators = "",
	component_separators = "",
})
