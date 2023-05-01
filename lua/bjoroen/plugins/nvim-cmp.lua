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

-- load vs-code like snippets from plugins (e.g. friendly-snippets)
require("luasnip/loaders/from_vscode").lazy_load()

vim.opt.completeopt = "menu,menuone,noselect"
local border_opts =
	{ border = "single", winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Constant,Search:None" }

local kind_icons = {
	Class = "ﴯ",
	Color = "",
	Constant = "",
	Constructor = "",
	Enum = "",
	EnumMember = "",
	Event = "",
	Field = "",
	File = "",
	Folder = "",
	Function = "",
	Interface = "",
	Keyword = "",
	Method = "",
	Module = "",
	Operator = "",
	Property = "ﰠ",
	Reference = "",
	Snippet = "",
	Struct = "",
	Text = "",
	TypeParameter = "",
	Unit = "",
	Value = "",
	Variable = "",
}

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
		["<C-e>"] = cmp.mapping.abort(), -- close completion window
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	}),

	window = {
		completion = cmp.config.window.bordered({
			scrollbar = false,
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Constant,Search:None",
		}),
		documentation = cmp.config.window.bordered(border_opts),
	},
	-- sources for autocompletion
	sources = cmp.config.sources({
		{
			name = "nvim_lsp",
		}, -- lsp
		{ name = "buffer" }, -- text within current buffer
		{ name = "path" }, -- file system paths
	}),

	formatting = {
		format = function(_, vim_item)
			-- Kind icons
			vim_item.abbr = " " .. vim_item.abbr
			vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) --Concatonate the icons with name of the item-kind
			return vim_item
		end,
	},

	matching = {
		disallow_fuzzy_matching = false,
	},
})
