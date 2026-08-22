-- Dependencies:
-- * tree-sitter-cli
-- * luarocks

local opt = vim.opt
local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

opt.termguicolors = true

vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })
opt.background = "dark"
vim.cmd.colorscheme("tokyonight")

opt.clipboard:append("unnamedplus")
opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.hlsearch = false
opt.incsearch = true
opt.smartcase = true
opt.smartindent = true
opt.autoindent = true
opt.ignorecase = true
opt.mouse = "nvi"
opt.cursorline = true
opt.wrap = false
opt.swapfile = false
opt.signcolumn = "yes" -- Reserve a space in the gutter
opt.colorcolumn = "+1"
opt.splitbelow = true
opt.splitright = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.scrolloff = 10
opt.sidescrolloff = 10
opt.hlsearch = true
opt.incsearch = true
opt.showmatch = true
opt.hidden = true
opt.errorbells = false
-- opt.winborder = "rounded"

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99

opt.undofile = true
local undodir = vim.fn.expand("~/.nvim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end
opt.undodir = undodir

vim.opt.completeopt = "menuone,noinsert,noselect"

-- keymaps
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "j", "gj")
map("n", "k", "gk")
map("n", "gj", "j")
map("n", "gk", "k")
map("n", "<leader>ev", "<cmd>edit ~/.config/nvim/init.lua<CR>")
map("n", "<leader>sv", "<cmd>source ~/.config/nvim/init.lua<CR>")
map("n", "<C-h>", "<C-w>h", { noremap = true })
map("n", "<C-j>", "<C-w>j", { noremap = true })
map("n", "<C-k>", "<C-w>k", { noremap = true })
map("n", "<C-l>", "<C-w>l", { noremap = true })
map("n", "<leader>nh", ":nohl<CR>")

-- ## AUTOCMDS

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = {
		"*.lua",
		"*.py",
		"*.go",
		"*.js",
		"*.jsx",
		"*.ts",
		"*.tsx",
		"*.json",
		"*.css",
		"*.scss",
		"*.html",
		"*.sh",
		"*.bash",
		"*.zsh",
		"*.c",
		"*.cpp",
		"*.h",
		"*.hpp",
	},
	callback = function(args)
		-- avoid formatting non-file buffers (helps prevent weird write prompts)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end
		if not vim.bo[args.buf].modifiable then
			return
		end
		if vim.api.nvim_buf_get_name(args.buf) == "" then
			return
		end
		-- TODO here do organizeImports, etc. if possible
		local has_efm = false
		for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
			if c.name == "efm" then
				has_efm = true
				break
			end
		end
		if not has_efm then
			return
		end
		pcall(vim.lsp.buf.format, {
			bufnr = args.buf,
			timeout_ms = 2000,
			filter = function(c)
				return c.name == "efm"
			end,
		})
	end,
})

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function()
		if vim.o.diff then
			return
		end
		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)
		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end
		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

-- TODO move this up!!!
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	group = augroup,
--   pattern = "*.go",
--   callback = function()
--     local params = vim.lsp.util.make_range_params()
--     params.context = { only = { "source.organizeImports" } }
--     -- buf_request_sync defaults to a 1000ms timeout. Depending on your
--     -- machine and codebase, you may want longer. Add an additional
--     -- argument after params if you find that you have to write the file
--     -- twice for changes to be saved.
--     -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
--     local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
--     for cid, res in pairs(result or {}) do
--       for _, r in pairs(res.result or {}) do
--         if r.edit then
--           local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
--           vim.lsp.util.apply_workspace_edit(r.edit, enc)
--         end
--       end
--     end
--     vim.lsp.buf.format({async = false})
--   end
-- })

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- install plugins
vim.pack.add({
	"https://www.github.com/echasnovski/mini.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	{
		-- NOTE: blink.cmp v2 is now the actively developed branch (breaking
		-- changes vs v1). Staying pinned to v1 here deliberately for stability.
		-- Revisit this pin when ready to migrate — v2 requires installing
		-- blink.lib as a native dependency outside vim.pack.
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	"https://github.com/mrcjkb/rustaceanvim",
})

-- ## CONFIGURE PLUGINS

require("mini.icons").setup({})
require("mini.notify").setup({})
require("mini.trailspace").setup({})
require("mini.clue").setup({
	triggers = {
		{ mode = "n", keys = "<leader>" },
		{ mode = "x", keys = "<leader>" },
		{ mode = "n", keys = "g" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
	},
	clues = {
		require("mini.clue").gen_clues.builtin_completion(),
	},
})

local setup_treesitter = function()
	local treesitter = require("nvim-treesitter")
	treesitter.setup({})
	local ensure_installed = {
		"bash",
		"c",
		"c_sharp",
		"cpp",
		"css",
		"go",
		"html",
		"javascript",
		"json",
		"lua",
		"markdown",
		"python",
		"rust",
		"svelte",
		"typescript",
		"vim",
		"vimdoc",
		"vue",
	}
	local config = require("nvim-treesitter.config")
	local already_installed = config.get_installed()
	local parsers_to_install = {}
	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end
	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end
	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			if vim.list_contains(config.get_installed(), vim.treesitter.language.get_lang(args.match)) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end
setup_treesitter()

local fzf = require("fzf-lua")
fzf.setup({
	keymap = {
		fzf = {
			["ctrl-y"] = "accept",
		},
	},
})
map("n", "<leader>ff", fzf.files, { desc = "Find files" })
map("n", "<leader>fg", fzf.live_grep, { desc = "Live Grep" })
-- open fzf right away if opening a directory
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local first_arg = vim.fn.argv(0)
		if
			vim.fn.argc() == 0
			or type(first_arg) == "table"
			or type(first_arg) == ""
			or vim.fn.isdirectory(vim.fn.expand(first_arg)) == 1
		then
			-- Wipe the directory buffer so it doesn't stay open in the background
			vim.cmd("bwipeout!")
			vim.cmd("FzfLua files")
		end
	end,
})

local diagnostic_signs = {
	Error = "\u{f057} ",
	Warn = "\u{f071} ",
	Hint = "\u{ea61}",
	Info = "\u{f05a}",
}
vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})
map("n", "<leader>q", function()
	vim.diagnostic.setloclist({ open = true })
end)

require("mason").setup({})
require("mason-lspconfig").setup({})
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end

		local bufnr = ev.buf
		local opts = { noremap = true, silent = true, buffer = bufnr }

		map("n", "gd", function()
			fzf.lsp_definitions({ jump1 = true })
		end, opts)

		map("n", "gD", vim.lsp.buf.definition, opts)

		map("n", "gS", function()
			vim.cmd("vsplit")
			vim.lsp.buf.definition()
		end, opts)

		map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		map("n", "<leader>rn", vim.lsp.buf.rename, opts)

		-- XXX remove this one?
		map("n", "<leader>dK", vim.diagnostic.open_float)
		map("n", "<leader>D", function()
			vim.diagnostic.open_float({ scope = "line" })
		end, opts)
		map("n", "<leader>d", function()
			vim.diagnostic.open_float({ scope = "cursor" })
		end, opts)
		map("n", "<leader>nd", function()
			vim.diagnostic.jump({ count = 1 })
		end, opts)

		map("n", "<leader>pd", function()
			vim.diagnostic.jump({ count = -1 })
		end, opts)

		map("n", "K", vim.lsp.buf.hover, opts)

		map("n", "<leader>fr", function()
			fzf.lsp_references()
		end, opts)
		map("n", "<leader>ft", function()
			fzf.lsp_typedefs()
		end, opts)
		map("n", "<leader>fs", function()
			fzf.lsp_document_symbols()
		end, opts)
		map("n", "<leader>fw", function()
			fzf.lsp_workspace_symbols()
		end, opts)
		map("n", "<leader>fi", function()
			fzf.lsp_implementations()
		end, opts)

		if client:supports_method("textDocument/codeAction", bufnr) then
			map("n", "<leader>oi", function()
				vim.lsp.buf.code_action({
					context = { only = { "source.organizeImports" }, diagnostics = {} },
					apply = true,
					bufnr = bufnr,
				})
				vim.defer_fn(function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end, 50)
			end, opts)
		end
	end,
})

require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "show_documentation", "hide_documentation", "hide" },
		["<C-y>"] = { "select_and_accept" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback" },
		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = {
		menu = {
			auto_show = function()
				return vim.bo.filetype ~= "markdown"
			end,
		},
	},
	-- signature help while typing function calls (was previously unset)
	signature = { enabled = true },
	sources = { default = { "lsp", "path", "buffer", "snippets" } },
	-- snippets now use blink's native engine — LuaSnip dependency removed
	fuzzy = {
		implementation = "prefer_rust",
		prebuilt_binaries = { download = true },
	},
})

-- lsps
do
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
	local capabilities = require("blink.cmp").get_lsp_capabilities()
	vim.lsp.config["*"] = {
		capabilities = capabilities,
	}
	local ensure_installed = {}
	local lsp_enable = function(name, config_opts, tool_names)
		for _, tool_name in ipairs(tool_names or {}) do
			table.insert(ensure_installed, tool_name)
		end
		vim.lsp.config(name, config_opts or {})
		vim.lsp.enable(name)
	end
	lsp_enable("bashls")
	lsp_enable("clangd")
	do
		local luacheck = require("efmls-configs.linters.luacheck")
		table.insert(ensure_installed, "luacheck")
		local stylua = require("efmls-configs.formatters.stylua")
		table.insert(ensure_installed, "stylua")
		local ruff_lint = require("efmls-configs.linters.ruff")
		local ruff_format = require("efmls-configs.formatters.ruff")
		table.insert(ensure_installed, "ruff")
		-- XXX can we use oxlint, etc. here instead maybe?
		local prettier_d = require("efmls-configs.formatters.prettier_d")
		table.insert(ensure_installed, "prettierd")
		local eslint_d = require("efmls-configs.linters.eslint_d")
		table.insert(ensure_installed, "eslint_d")
		local fixjson = require("efmls-configs.formatters.fixjson")
		table.insert(ensure_installed, "fixjson")
		local shellcheck = require("efmls-configs.linters.shellcheck")
		local shfmt = require("efmls-configs.formatters.shfmt")
		table.insert(ensure_installed, "shfmt")
		local cpplint = require("efmls-configs.linters.cpplint")
		table.insert(ensure_installed, "cpplint")
		local clangfmt = require("efmls-configs.formatters.clang_format")
		table.insert(ensure_installed, "clang-format")
		local go_revive = require("efmls-configs.linters.go_revive")
		table.insert(ensure_installed, "revive")
		local gofumpt = require("efmls-configs.formatters.gofumpt")
		table.insert(ensure_installed, "gofumpt")
		lsp_enable("efm", {
			filetypes = {
				"c",
				"cpp",
				"css",
				"go",
				"html",
				"javascript",
				"javascriptreact",
				"json",
				"jsonc",
				"lua",
				"markdown",
				"python",
				"sh",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
			},
			init_options = { documentFormatting = true },
			settings = {
				languages = {
					c = { clangfmt },
					go = { gofumpt, go_revive },
					cpp = { clangfmt, cpplint },
					css = { prettier_d },
					html = { prettier_d },
					javascript = { eslint_d, prettier_d },
					javascriptreact = { eslint_d, prettier_d },
					json = { eslint_d, fixjson },
					jsonc = { eslint_d, fixjson },
					lua = { luacheck, stylua },
					markdown = { prettier_d },
					python = { ruff_lint, ruff_format },
					sh = { shellcheck, shfmt },
					typescript = { eslint_d, prettier_d },
					typescriptreact = { eslint_d, prettier_d },
					vue = { eslint_d, prettier_d },
					svelte = { eslint_d, prettier_d },
				},
			},
		})
	end
	lsp_enable("gopls")
	lsp_enable("lua_ls", {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				diagnostics = { globals = { "vim" } },
				telemetry = { enable = false },
			},
		},
	})
	lsp_enable("pyright")
	lsp_enable("ts_ls")
	vim.g.rustaceanvim = {
		server = {
			capabilities = capabilities,
		},
	}

	require("mason-tool-installer").setup({
		ensure_installed = ensure_installed,
		integrations = {
			["mason-lspconfig"] = true,
		},
	})
end
