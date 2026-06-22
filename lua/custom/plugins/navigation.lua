vim.pack.add {
  -- We explicitly point to the harpoon2 branch using the URL anchor
  {
    src = 'https://github.com/ThePrimeagen/harpoon.git',
    version = 'harpoon2'
  },
  'https://github.com/nvim-lua/plenary.nvim', -- dependency
}

-- Basic Harpoon 2 setup
local harpoon = require 'harpoon'
harpoon:setup {
  global_settings = {
    mark_branch = true,
  }
}

-- Keymaps
vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = '[H]arpoon file' })
vim.keymap.set('n', '<leader>hs', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = '[H]arpoon menu [S]earch' })

-- Quick jump keys (e.g., jump to file 1, 2, 3, 4)
vim.keymap.set('n', '<leader>h1', function() harpoon:list():select(1) end, { desc = '[H]arpoon to file [1]' })
vim.keymap.set('n', '<leader>h2', function() harpoon:list():select(2) end, { desc = '[H]arpoon to file [2]' })
vim.keymap.set('n', '<leader>h3', function() harpoon:list():select(3) end, { desc = '[H]arpoon to file [3]' })
vim.keymap.set('n', '<leader>h4', function() harpoon:list():select(4) end, { desc = '[H]arpoon to file [4]' })
vim.keymap.set('n', '<leader>h5', function() harpoon:list():select(5) end, { desc = '[H]arpoon to file [5]' })
vim.keymap.set('n', '<leader>h6', function() harpoon:list():select(6) end, { desc = '[H]arpoon to file [6]' })
vim.keymap.set('n', '<leader>h7', function() harpoon:list():select(7) end, { desc = '[H]arpoon to file [7]' })
vim.keymap.set('n', '<leader>h8', function() harpoon:list():select(8) end, { desc = '[H]arpoon to file [8]' })
vim.keymap.set('n', '<leader>h9', function() harpoon:list():select(9) end, { desc = '[H]arpoon to file [9]' })
