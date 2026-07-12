-- This only runs when you are actively inside the vim-harbor directory!

local function run_compiler_choice()
  local options = {
    { label = "1. build and run", args = ""},
    { label = "2. build and run", args = ""},
  }

  vim.ui.select(options, {
    prompt = 'Select Compiler Option for Vim Harbor:',
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end

    local cmd = string.format("split | terminal cargo run -- %s", choice.args)
    vim.cmd(cmd)
  end)
end

vim.keymap.set('n', '<leader>cc', run_compiler_choice, { desc = '[C]ompiler [C]hoice' })
