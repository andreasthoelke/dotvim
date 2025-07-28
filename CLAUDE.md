# Neovim Configuration Guide

## Commands
- Build/Install: `vim-plug` for plugin management, run `:PlugInstall` to install plugins
- Lint: 
  - Lua: `stylua` for formatting
  - Python: `flake8`, `isort`, `black` for linting/formatting
  - JS/TS: `eslint_d` for linting, `prettier` for formatting
  - Shell: `shellcheck` for linting, `shfmt` for formatting
- Format: `:LspFormat` for current buffer formatting with LSP

## Code Style
- **Indentation**: 2 spaces
- **Modules**: Use module pattern with local `M` table returned at end
- **Functions**:
  - Module: `function M.functionName(args)`
  - Local: `local function functionName(args)`
  - Global: `function _G.functionName(args)`
- **Variables**: 
  - camelCase for variables and functions
  - Clear error handling with conditional checks and early returns
- **Comments**:
  - Section headers: `-- ─   Section Name ──`
  - Section footers: `-- ─^  Section Name ▲`
- **Imports**: `local moduleName = require('module.path')`

## Project Structure
- Core config in `init.vim`
- Plugin configs in `plugin/config/`
- Utilities in `lua/utils/`
- Language settings in `plugin/ftype/`

## Tool Usage Optimizations
- **Always use BatchTool** for multiple operations to improve efficiency and avoid file modification errors
- **Limit file reads** with offset/limit parameters when only portions of files are needed
- **Use GrepTool/GlobTool** for searching instead of reading entire files
- **Include expected_replacements** when editing files with potential multiple matches
- **Use dispatch_agent** for complex search patterns across multiple files
- **Prefer concise responses** with minimal preamble or explanation unless explicitly requested

# Custom instructions

- Don't unnecessarily restrict buffer properties unless there's a specific requirement

