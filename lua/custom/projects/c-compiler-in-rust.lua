-- This only runs when you are actively inside the c-compiler-in-rust directory!

local function run_compiler_stage()
  local current_file = vim.fn.expand('%:p')

  if not current_file:match('%.c$') then
    current_file = "./c-programs/return_2.c" 
  else
    current_file = vim.fn.fnamemodify(current_file, ':.')
  end

  local stages = {
    { label = "1. Lexer Stage    (--lex)",    args = "-S --lex" },
    { label = "2. Parser Stage  (--parse)",    args = "-S --parse" },
    { label = "3. Tacky Stage   (--tacky)",    args = "-S --tacky" },
    { label = "4. Codegen Stage (--codegen)",  args = "-S --codegen" },
    { label = "5. Validate Stage(--validate)", args = "-S --validate" },
    { label = "6. Run Full Compiler",          args = "-S" },
    { label = "7. Execute Binary directly",    args = "" },
  }

  vim.ui.select(stages, {
    prompt = 'Select Compiler Stage for ' .. vim.fn.fnamemodify(current_file, ':t') .. ':',
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end

    local cmd = string.format("split | terminal cargo run -- %s %s", choice.args, current_file)
    vim.cmd(cmd)
  end)
end

vim.keymap.set('n', '<leader>cc', run_compiler_stage, { desc = '[C]ompiler [C]hoice' })
