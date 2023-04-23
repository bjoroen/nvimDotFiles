-- import nvim-cmp plugin safely
local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
	print(cmp_status)
	return
end

-- import luasnip plugin safely
local luasnip_status, luasnip = pcall(require, "luasnip")
if not luasnip_status then
	return
end

-- import lspkind plugin safely
local lspkind_status, lspkind = pcall(require, "lspkind")
if not lspkind_status then
	return
end

local ts_status, ts_util = pcall(require, "nvim-treesitter.ts_utils")
if not ts_status then
	return
end

-- load vs-code like snippets from plugins (e.g. friendly-snippets)
require("luasnip/loaders/from_vscode").lazy_load()

vim.opt.completeopt = "menu,menuone,noselect"
local border_opts =
	{ border = "single", winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Constant,Search:None" }

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<s-Tab>"] = cmp.mapping.select_prev_item(), -- previous suggestion
		["<Tab>"] = cmp.mapping.select_next_item(), -- next suggestion
		["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
		["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-space>"] = cmp.mapping.complete(), -- show completion suggestions
		["<C-e>"] = cmp.mapping.abort(), -- close completion window
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	}),

	window = {
		completion = cmp.config.window.bordered(border_opts),
		documentation = cmp.config.window.bordered(border_opts),
		scrollbar = false,
	},
	-- sources for autocompletion
	sources = cmp.config.sources({
		{
			name = "nvim_lsp",
			priority = 1000,
			entry_filter = function(entry, context)
				local kind = entry:get_kind()
				local node = ts_util.get_node_at_cursor():type()
				local line = context.cursor_line
				local col = context.cursor.col
				local char_before_cursor = string.sub(line, col - 1, col - 1)

				-- Better autocomplete after .
				if char_before_cursor == "." then
					if kind == 2 or kind == 5 then
						return true
					else
						return false
					end
				elseif string.match(line, "^%s*%w*$") then
					if kind == 3 or kind == 6 then
						return true
					else
						return false
					end
				end

				if node == "arguments" then
					if kind == 6 then
						return true
					else
						return false
					end
				end
			end,

			-- Only get varibales in fucntion call
		}, -- lsp
		-- { name = "luasnip", priority = 350 }, -- snippets
		{ name = "buffer", priority = 500 }, -- text within current buffer
		{ name = "path", priority = 250 }, -- file system paths
	}),
	-- configure lspkind for vs-code like icons
	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = lspkind.cmp_format({
			maxwidth = 50,
			ellipsis_char = "...",
		}),
	},
})
