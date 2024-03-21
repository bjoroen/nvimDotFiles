-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

-- import lspconfig plugin safely
local util_status, util = pcall(require, "lspconfig/util")
if not util_status then
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

-- import typescript plugin safely
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
	return
end

local rust_tool_setup, rt = pcall(require, "rust-tools")
if not rust_tool_setup then
	return
end

local keymap = vim.keymap -- for conciseness

local border = {
	{ "╭", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╮", "FloatBorder" },
	{ "│", "FloatBorder" },
	{ "╯", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╰", "FloatBorder" },
	{ "│", "FloatBorder" },
}

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- Border for flaoting windows
	local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opt, ...)
		opt = opt or {}
		opt.border = opt.border or border
		return orig_util_open_floating_preview(contents, syntax, opt, ...)
	end

	-- set keybinds
	keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts) -- got to declaration
	keymap.set("n", "gi", "<Cmd>lua vim.lsp.buf.implementation<CR>", opts) -- got to declaration
	keymap.set("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- see available code actions
	keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts) -- smart rename
	keymap.set("n", "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- show  diagnostics for line
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "<leader>lsh", "<cmd>lua vim.lsp.buf.signature_help()<CR>")

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
		keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports
		keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables
	end

	if client.name == "rust_analzyer" then
		keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
		-- Code action groups
		keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
	end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.rs",
	callback = function()
		vim.lsp.buf.format({ timeout_ms = 200 })
	end,
	group = format_sync_grp,
})

vim.diagnostic.config({
	virtual_text = {
		-- source = "always", -- Or "if_many"
		prefix = "●", -- Could be '■', '▎', 'x'
	},
	severity_sort = true,
	float = {
		source = "always", -- Or "if_many"
	},
})

-- Ltex
lspconfig.ltex.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		ltex = {
			language = "en-GB",
		},
	},
})

lspconfig.eslint.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		packageManager = "npm",
	},
})

-- Rust
rt.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
		root_dir = util.root_pattern("Cargo.toml"),
		["rust-analyzer"] = {

			-- enable clippy on save
			checkOnSave = {
				command = "clippy",
			},
		},
	},
})

rt.hover_range.hover_range()

--Go
lspconfig.gopls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = util.root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			completeUnimported = true,
			analyses = {
				unuseparams = true,
			},
		},
	},
})

-- Zig
lspconfig.zls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig.clangd.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Kotlin
-- lspconfig.kotlin_language_server.setup({
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- })

-- configure html server
lspconfig["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure typescript server with plugin
typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
	},
})

-- configure css server
lspconfig["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure tailwindcss server
lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure emmet language server
lspconfig["emmet_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

-- configure lua server (with special settings)
lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})
