-- This only runs when you are actively inside the c-compiler-in-rust directory!

local function run_compiler_choice()
  local current_file = vim.fn.expand('%:p')

  if not current_file:match('%.c$') then
    current_file = "./c-programs/return_2.c"
  else
    current_file = vim.fn.fnamemodify(current_file, ':.')
  end

  local options = {
    { label = "1. Compile only: Lexer Stage    (--lex)",    args = "-S --lex" },
    { label = "2. Compile only: Parser Stage  (--parse)",    args = "-S --parse" },
    { label = "3. Compile only: Tacky Stage   (--tacky)",    args = "-S --tacky" },
    { label = "4. Compile only: Codegen Stage (--codegen)",  args = "-S --codegen" },
    { label = "5. Compile only: Validate Stage(--validate)", args = "-S --validate" },
    { label = "6. Compile only: All Stages", args = "-S" },
    { label = "7. Compile, Assemble, Link", args = "" },
  }

  vim.ui.select(options, {
    prompt = 'Select Compiler Option for ' .. vim.fn.fnamemodify(current_file, ':t') .. ':',
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end

    local cmd = string.format("split | terminal cargo run -- %s %s", choice.args, current_file)
    vim.cmd(cmd)
  end)
end

vim.keymap.set('n', '<leader>cc', run_compiler_choice, { desc = '[C]ompiler [C]hoice' })
