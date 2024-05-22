return {
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            ".idea",
          },
        },
      })
    end,
  },
}
