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
