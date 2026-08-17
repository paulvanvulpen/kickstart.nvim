local telescope_config = require('telescope.config')

vim.list_extend(
  telescope_config.values.file_ignore_patterns,
  {
	"^%.github\\",
	"^%.idea\\",
	"^%.vs\\",
	"^%.vscode\\",
	"^%azure-pipelines\\",
	"Binaries\\",
	"^Build\\",
	"^BuildTools\\",
	"Content\\",
	"^DerivedDataCache\\",
	"Intermediate\\",
	"^Project\\",
	"^Saved\\",
	"^SourceDeps\\",
	"^[^%-]+%-Audio\\",
	"^Test\\",
	"^Tools\\",
	"^Plugins\\3rdparty\\",
  }
)

local function gh(repo) return 'https://github.com/' .. repo end

vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Build plugins after install or update',
  callback = function(ev)
    local is_install_or_update = (ev.data.kind == 'install' or ev.data.kind == 'update')
    
    -- Build UNL.nvim
    if ev.data.spec.name == 'UNL.nvim' and is_install_or_update then
      vim.system(
        { 'cargo', 'build', '--release', '--manifest-path', 'scanner/Cargo.toml' },
        { cwd = ev.data.path, text = true },
        function(obj)
          if obj.code ~= 0 then
            vim.schedule(function() vim.notify('UNL.nvim build failed: ' .. (obj.stderr or ''), vim.log.levels.ERROR) end)
          else
            vim.schedule(function() vim.notify('UNL.nvim scanner built successfully!', vim.log.levels.INFO) end)
          end
        end
      )
    end

    -- Build blink.cmp
    if ev.data.spec.name == 'blink.cmp' and is_install_or_update then
      vim.system(
        { 'cargo', 'build', '--release' },
        { cwd = ev.data.path, text = true },
        function(obj)
          if obj.code ~= 0 then
            vim.schedule(function() vim.notify('blink.cmp build failed: ' .. (obj.stderr or ''), vim.log.levels.ERROR) end)
          else
            vim.schedule(function() vim.notify('blink.cmp built successfully!', vim.log.levels.INFO) end)
          end
        end
      )
    end
  end,
})

vim.pack.add({
  -- Base Dependencies & UI
  gh 'MunifTanjim/nui.nvim',
  gh 'nvim-tree/nvim-web-devicons',
  gh 'nvim-telescope/telescope.nvim',
  gh 'j-hui/fidget.nvim',
  gh 'nvim-lualine/lualine.nvim',
  gh 'rafamadriz/friendly-snippets',

  -- Core UnrealDev Suite
  gh 'taku25/UNL.nvim',
  gh 'taku25/UEP.nvim',
  gh 'taku25/UEA.nvim',
  gh 'taku25/UBT.nvim',
  gh 'taku25/UCM.nvim',
  gh 'taku25/ULG.nvim',
  gh 'taku25/USH.nvim',
  gh 'taku25/UNX.nvim',
  gh 'taku25/USX.nvim',
  gh 'taku25/UDB.nvim',
  gh 'taku25/UnrealDev.nvim',

  -- Parsers & Autocompletion
  gh 'romus204/tree-sitter-manager.nvim',
  gh 'L3MON4D3/LuaSnip',
  gh 'folke/lazydev.nvim',
  gh 'saghen/blink.cmp',
  gh 'taku25/blink-cmp-unreal',
})

vim.filetype.add({
    extension = {
      verse = "verse",
      usf   = "ushader",
      ush   = "ushader",
    },
  })

-- 4. Tree-Sitter Manager & Highlighting Autocmd
local ts_opts = {
  ensure_installed = { 'cpp', 'ushader', 'verse' },
  highlight = { 'cpp', 'ushader', 'verse' },
  border = 'rounded',
  languages = {
    cpp = {
      install_info = {
        url = 'https://github.com/taku25/tree-sitter-cpp',
        use_repo_queries = true,
      },
    },
    ushader = {
      install_info = {
        url = 'https://github.com/taku25/tree-sitter-unreal-shader',
        use_repo_queries = true,
      },
    },
    verse = {
      install_info = {
        url = 'https://github.com/taku25/tree-sitter-verse',
        use_repo_queries = true,
      },
    },
  },
}

require('tree-sitter-manager').setup(ts_opts)

local ts_group = vim.api.nvim_create_augroup('MyTreesitter', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = ts_group,
  pattern = ts_opts.highlight,
  callback = function(args)
    vim.treesitter.start(args.buf)
  end,
})

-- 5. UNL Setup
require('UNL').setup({
  ui = {
    picker = {
      mode = 'auto',
      prefer = { 'telescope', 'fzf_lua', 'native' },
      behaviour = {
        single = 'native',
        multiselect = 'native',
        multiselect_empty = 'confirm_item',
      },
    },
    filer = {
      mode = 'auto',
      prefer = { 'nvim-tree', 'neo-tree', 'native' },
    },
    progress = {
      enable = true,
      mode = 'auto',
      prefer = { 'fidget', 'window', 'notify' },
    },
  },
  logging = {
    level = 'info',
    echo = { level = 'warn' },
    notify = { level = 'error', prefix = '[UNL]' },
    file = { enable = true, max_kb = 512, rotate = 3, filename = 'unl.log' },
  },
  cache = { dirname = 'UNL_cache' },
  project = {
    localrc_filename = '.unlrc.json',
    search_stop_at_home = true,
  },
})

-- 6. UEP Setup
require('UEP').setup({
  uep = {
    server = {
      enable = true,
      name = 'UEP_nvim',
    },
    ide = {
      open_command = 'rider --line {line} "{file}"',
    },
  },
  include_directory = { 'Source', 'Plugins', 'Config' },
  excludes_directory = { 'Intermediate', 'Binaries', 'Saved' },
  files_extensions = { 'cpp', 'h', 'hpp', 'inl', 'ini', 'cs' },
  engine_path = nil,
  ui = {
    picker = {
      mode = 'auto',
      prefer = { 'telescope', 'fzf_lua', 'native' },
    },
    grep_picker = {
      mode = 'auto',
      prefer = { 'telescope', 'fzf-lua' },
    },
    progress = {
      enable = true,
      mode = 'auto',
      prefer = { 'fidget', 'window', 'notify' },
    },
  },
})

-- 7. Main UnrealDev Suite Setup (Controls UBT, UEP, ULG, USH, UCM, UEA, UNX)
require('UnrealDev').setup({
  setup_modules = {
    UBT = true,
    UEP = true,
    ULG = true,
    USH = true,
    UCM = true,
    UEA = true,
    UNX = true,
  },
})

-- 8. Supporting UI & Completion Configurations
require('fidget').setup({})
require('lualine').setup({})
require('lazydev').setup({})
require('luasnip').setup({})
require('luasnip.loaders.from_vscode').lazy_load()

-- 9. Autocompletion Setup (blink.cmp)
require("blink.cmp").setup({
  keymap = {
    preset = "super-tab",
  },
  completion = {
    trigger = {
      show_in_snippet = false,
    },
    list = {
      selection = {
        preselect = false
      },
    },
    documentation = {
      auto_show = true
    }
  },
  sources = {
    default = {
      "snippets", "lsp", "path", "buffer", "lazydev", "unreal",
    },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
      unreal = {
        module = 'blink-cmp-unreal',
        name = 'unreal',
        score_offset = 10,
      },
    },
  },
  snippets = { preset = "luasnip" },
})
