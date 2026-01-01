vim.o.incsearch = true
vim.o.undofile = true
vim.g.indentLine_fileTypeExclude = { "dashboard" }
vim.opt.clipboard = "unnamedplus"
vim.wo.colorcolumn = "146"
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.number = true
vim.wo.relativenumber = true
vim.o.scrolloff = 15
vim.wo.cursorline = true
vim.wo.signcolumn = "yes"
vim.o.hlsearch = false
vim.opt.swapfile = false
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.g.navic_silence = true
if vim.g.neovide then
	vim.o.guifont = "Iosevka Nerd Font:h10"
	vim.g.neovide_hide_mouse_when_typing = false
	vim.g.neovide_confirm_quit = true
	vim.g.neovide_cursor_vfx_mode = "ripple"
	vim.neovide_confirm_quit = true
end
--包管理器---------------------------------------------------------------------------------------------------------------------------------------
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
require("lazy").setup({
	{
		"RRethy/vim-illuminate",
	},
	{
		"L3MON4D3/LuaSnip",
		build = vim.fn.has("win32") ~= 0 and "make install_jsregexp" or nil,
		dependencies = {
			"rafamadriz/friendly-snippets",
			"benfowler/telescope-luasnip.nvim",
		},
		config = function(_, opts)
			if opts then
				require("luasnip").config.setup(opts)
			end
			vim.tbl_map(function(type)
				require("luasnip.loaders.from_" .. type).lazy_load()
			end, { "vscode", "snipmate", "lua" })
			-- friendly-snippets - enable standardized comments snippets
			require("luasnip").filetype_extend("typescript", { "tsdoc" })
			require("luasnip").filetype_extend("javascript", { "jsdoc" })
			require("luasnip").filetype_extend("lua", { "luadoc" })
			require("luasnip").filetype_extend("python", { "pydoc", "django", "flask" })
			require("luasnip").filetype_extend("rust", { "rustdoc" })
			require("luasnip").filetype_extend("cs", { "csharpdoc" })
			-- require("luasnip").filetype_extend("java", { "javadoc" })
			require("luasnip").filetype_extend("c", { "cdoc" })
			require("luasnip").filetype_extend("cpp", { "cppdoc" })
			require("luasnip").filetype_extend("php", { "phpdoc" })
			require("luasnip").filetype_extend("kotlin", { "kdoc" })
			require("luasnip").filetype_extend("ruby", { "rdoc" })
			require("luasnip").filetype_extend("sh", { "shelldoc" })
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		requires = "kevinhwang91/promise-async",
	},
	{
		"VidocqH/lsp-lens.nvim",
		config = function()
			require("lsp-lens").setup({
				enable = true,
				LspLens = { link = "Comment" },
				include_declaration = false, -- Reference include declaration
				ignore_filetype = {
					"prisma",
				},
				sections = {
					definition = function(count)
						return "函数: " .. count
					end,
					references = function(count)
						return "传参: " .. count -- References
					end,
					implements = function(count)
						return "实施: " .. count -- Implements
					end,
					git_authors = function(latest_author, count)
						return " " .. latest_author .. (count - 1 == 0 and "" or (" + " .. count - 1))
					end,
				},
			})
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
	},
	{
		"xiyaowong/transparent.nvim",
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
		dependencies = { "arkav/lualine-lsp-progress" },
		config = function()
			require("lualine").setup()
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				view = { width = 30 },
				renderer = { group_empty = true },
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			integrations = {
				telescope = true,
				harpoon = true,
				mason = true,
				neotest = true,
			},
		},
		config = function()
			 require("catppuccin").setup({
				 transparent_background = true,
			 })
			 vim.cmd.colorscheme 'catppuccin-mocha'
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {},
				rainbow = { enable = true, extended_mode = true, max_file_lines = nil },
			})
		end,
	},
	{
		"folke/lsp-colors.nvim",
		config = function()
			require("lsp-colors").setup({
				Error = "#db4b4b",
				Warning = "#e0af68",
				Information = "#0db9d7",
				Hint = "#10B981",
			})
		end,
	},
	{
		"mhartington/formatter.nvim",
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				padding = true,
				sticky = true,
				ignore = nil,
				toggler = {
					line = "zz",
					block = "lz",
				},
				opleader = {
					line = "gc",
					block = "gb",
				},
				extra = {
					above = "gcO",
					below = "gco",
					eol = "gcA",
				},
				mappings = {
					basic = true,
					extra = true,
				},
				pre_hook = nil,
				post_hook = nil,
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			{ "neovim/nvim-lspconfig" }, -- Required
			{ -- Optional
				"williamboman/mason.nvim",
				build = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "onsails/lspkind-nvim" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-path" },
			{ "rafamadriz/friendly-snippets" },
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			require("ibl").setup({ indent = { highlight = highlight } })
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod" },
		},
	},
	{
		"kristijanhusak/vim-dadbod-completion",
	},
	{
		"rcarriga/nvim-notify",
		config = function(_, opts)
			vim.notify = require("notify")
			require("notify")("自由万岁!葛墨林万岁!")
			require("notify").setup(vim.tbl_extend("keep", {
				background_colour = "#000000",
			}, opts))
		end,
	},
	{
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = false,
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.config
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod" },
	},
	{
		"SmiteshP/nvim-navic",
		requires = "neovim/nvim-lspconfig",
		config = function()
			require("nvim-navic").setup()
			on_attach = on_attach
		end,
	},
	{
		"SmiteshP/nvim-navbuddy",
		requires = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
			"numToStr/Comment.nvim", -- Optional
			"nvim-telescope/telescope.nvim", -- Optional
		},
	},
	{
		"kosayoda/nvim-lightbulb",
		config = function()
			require("nvim-lightbulb").setup({
				autocmd = { enabled = true },
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
	},
	{
		"simrat39/symbols-outline.nvim",
		config = function()
			require("symbols-outline").setup()
		end,
	},
	{ "saadparwaiz1/cmp_luasnip" },
})
---按键映射--------------------------------------------------------------------------------------------------------------------------------------
--映射jk作为Esc
vim.api.nvim_set_keymap("i", "jk", "<esc>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w-h>", { silent = true, noremap = true })

vim.api.nvim_set_keymap("n", "<c-p>", "<cmd>!python %<CR>", { silent = true, noremap = true })

-- lspsaga
vim.api.nvim_set_keymap("n", "gr", "<cmd>lua require('lspsaga.rename').rename()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "bc", "<cmd>Lspsaga code_action<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "dj", "<cmd>Lspsaga hover_doc<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "sl", "<cmd>Lspsaga show_line_diagnostics<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "lf", "<cmd>Lspsaga lsp_finder<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<C-y>", "<cmd>lua vim.lsp.buf.declaration()<CR>", { silent = true, noremap = true })

-- 打开大纲
vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>SymbolsOutline<CR>", { silent = true, noremap = true })
-- vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>TagbarToggle<CR>", { noremap = true, silent = true })
-- 打开文件树
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
-- 顶部文件左右移动 --
vim.api.nvim_set_keymap("n", "<C-h>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>bc", ":bdelete %<CR>", { noremap = true, silent = true })
-- 打开一个浮动终端 --
-- vim.api.nvim_set_keymap("n", "<C-t>", ":FloatermToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
-- 文件查找 --
vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { noremap = true, silent = true })
-- nvim 代码调试
-- 开始调试
vim.keymap.set("n", "<leader>de", function()
	require("dap").continue()
end, { noremap = true, silent = true })
-- 打断点
vim.keymap.set("n", "<leader>dn", function()
	require("dap").toggle_breakpoint()
end, { noremap = true, silent = true })
-- 通过此步
vim.keymap.set("n", "<leader>dr", function()
	require("dap").step_over()
end, { noremap = true, silent = true })
-- 单独运行此代码
vim.keymap.set("n", "<leader>di", function()
	require("dap").step_into()
end, { noremap = true, silent = true })
-- 输出？
vim.keymap.set("n", "<leader>do", function()
	require("dap").step_out()
end, { noremap = true, silent = true })
-- 直接退出dap
vim.keymap.set("n", "<leader>dt", function()
	require("dap").disconnect()
end, { noremap = true, silent = true })
-- nvim 格式化代码
vim.keymap.set("n", "fr", "<cmd>Format<CR>")
vim.keymap.set("n", "fw", "<cmd>FormatWrite<CR>")

vim.keymap.set("n", "<C-o>", "<cmd>TransparentToggle<CR>")
---配置区----------------------------------------------------------------------------------------------------------------------------------------


-- If you want insert `(` after select function or method item
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
local lspkind = require("lspkind")
local lsp = require("lsp-zero").preset({})
lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
end)
lsp.setup()
local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
cmp.setup({
	mapping = {
		-- 补全的一些设置，具体不清楚
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-l>"] = cmp.mapping.complete(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
	},
	--让nvim根据name里面的参数进行补全
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}),
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				ultisnips = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
})
local cmp = require("cmp")
--------------------------------------------文件类型进行补全，作用未知 -----------------------------------------------------
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "buffer" },
	}),
})
------------------------------------------------ nvim命令补全--------------------------------------------------------------
--nvim命令行补全
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

--文件内容搜索补全

cmp.setup.cmdline({ "/" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- ----------------------------- 这个小插件为neovim内置的lsp添加了类似vscode的象形图------------------------------
local lspkind = require("lspkind")
cmp.setup({
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol", -- show only symbol annotations
			maxwidth = 80, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
			before = function(entry, vim_item)
				return vim_item
			end,
		}),
	},
})
---打开lazygit-----------------------------------------------------------------------------------------------------------------------------------

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	dir = "git_dir",
	direction = "float",
	float_opts = {
		border = "double",
	},
	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	on_close = function(term)
		vim.cmd("startinsert!")
	end,
})
function _lazygit_toggle()
	lazygit:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

local util = require("formatter.util")

require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {
		html = {
			require("formatter.filetypes.html").htmlbeautifier,
			function()
				if util.get_current_buffer_file_name() == "special.lua" then
					return nil
				end
				return {
					exe = "standardjs",
				}
			end,
		},
		javascript = {
			require("formatter.filetypes.javascript").standardjs,
			function()
				if util.get_current_buffer_file_name() == "special.lua" then
					return nil
				end
				return {
					exe = "standardjs",
				}
			end,
		},
		java = {
			require("formatter.filetypes.java").clangformat,
			function()
				if util.get_current_buffer_file_name() == "special.lua" then
					return nil
				end
				return {
					exe = "clangformat",
				}
			end,
		},
		python = {
			require("formatter.filetypes.python").black,
			function()
				if util.get_current_buffer_file_name() == "special.lua" then
					return nil
				end
				return {
					exe = "black",
				}
			end,
		},
		lua = {
			require("formatter.filetypes.lua").stylua,
			function()
				if util.get_current_buffer_file_name() == "special.lua" then
					return nil
				end
				return {
					exe = "stylua",
					args = {
						"--search-parent-directories",
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--",
						"-",
					},
					stdin = true,
				}
			end,
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
local lspsaga = require("lspsaga")
lspsaga.setup({
	debug = false,
	use_saga_diagnostic_sign = true,
	-- diagnostic sign
	error_sign = "",
	warn_sign = "",
	hint_sign = "",
	infor_sign = "",
	diagnostic_header_icon = "   ",
	-- code action title icon
	code_action_icon = " ",
	code_action_prompt = {
		enable = true,
		sign = true,
		sign_priority = 40,
		virtual_text = true,
	},
	finder_definition_icon = "  ",
	finder_reference_icon = "  ",
	max_preview_lines = 10,
	finder_action_keys = {
		open = "o",
		vsplit = "s",
		split = "i",
		quit = "q",
		scroll_down = "<C-f>",
		scroll_up = "<C-b>",
	},
	code_action_keys = {
		quit = "q",
		exec = "<CR>",
	},
	rename_action_keys = {
		quit = "<C-c>",
		exec = "<CR>",
	},
	definition_preview_icon = "  ",
	border_style = "single",
	rename_prompt_prefix = "➤",
	rename_output_qflist = {
		enable = false,
		auto_open_qflist = false,
	},
	server_filetype_map = {},
	diagnostic_prefix_format = "%d. ",
	diagnostic_message_format = "%m %c",
	highlight_prefix = false,
})
