local status, go = pcall(require, "gopher")
if not status then
	return
end

go.setup({})
