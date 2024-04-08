local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

local plugins = {
	--TODO: Group plugins better
	"nvim-lua/plenary.nvim",
	{
		dir = "~/dev/nvim-stats", -- Your path
		name = "nvim-stats",
		config = function()
			require("nvim-stats").setup()
		end,
	},

	{
		"AlexvZyl/nordic.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nordic").load()
		end,
	},

	"wakatime/vim-wakatime",

	{ "catppuccin/nvim", name = "catppuccin" }, -- colorscheme

	{ "cocopon/iceberg.vim", name = "iceberg" }, -- colorscheme

	{ "kvrohit/rasmus.nvim", name = "rasmus" },

	"tjdevries/colorbuddy.nvim",

	"christoomey/vim-tmux-navigator",

	"szw/vim-maximizer", -- maximizes and restores current window

	"tpope/vim-surround", -- add, delete, change surroundings (it's awesome)

	"inkarkat/vim-ReplaceWithRegister", -- replace with register contents using motion (gr + motion)

	"numtostr/comment.nvim",

	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- dependency for better sorting performance

	{ "nvim-telescope/telescope.nvim", branch = "0.1.x" }, -- fuzzy finder

	"nvim-telescope/telescope-ui-select.nvim",

	"hrsh7th/nvim-cmp", -- completion plugin

	"hrsh7th/cmp-buffer", -- source for text in buffer

	"hrsh7th/cmp-path", -- source for file system paths

	"L3MON4D3/LuaSnip", -- snippet engine

	"saadparwaiz1/cmp_luasnip", -- for autocompletion

	"rafamadriz/friendly-snippets", -- ful snippets

	"williamboman/mason.nvim",

	"williamboman/mason-lspconfig.nvim",

	"neovim/nvim-lspconfig", -- easily configure language servers

	"hrsh7th/cmp-nvim-lsp", -- for autocompletion

	"jose-elias-alvarez/typescript.nvim", -- additional functionality for typescript server (e.g. rename file & update imports)

	"onsails/lspkind.nvim", -- vs-code like icons for autocompletion

	"jose-elias-alvarez/null-ls.nvim", -- configure formatters & linters

	"jayp0521/mason-null-ls.nvim", -- bridges gap b/w mason & null-ls

	"nvim-treesitter/nvim-treesitter",

	"nvim-treesitter/playground",

	"windwp/nvim-autopairs", -- autoclose parens, brackets, quotes, etc...

	{ "windwp/nvim-ts-autotag", dependencies = "nvim-treesitter" }, -- autoclose tags

	"lewis6991/gitsigns.nvim",

	"norcalli/nvim-colorizer.lua",

	"simrat39/rust-tools.nvim",

	"mfussenegger/nvim-dap",

	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },

	"lukas-reineke/indent-blankline.nvim",
}

require("lazy").setup(plugins, {})
