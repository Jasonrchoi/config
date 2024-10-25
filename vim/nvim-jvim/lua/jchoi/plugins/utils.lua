return {
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
		lazy = false,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").create_default_mappings()
			vim.keymap.set("n", "s", function()
				require("leap").leap({ target_windows = { vim.api.nvim_get_current_win() } })
			end)
		end,
	},
}
