
function _G.ShowParrotChatsView()
  local folder_path = "~/.local/share/nvim/parrot/chats"
  -- File paths example: /Users/at/.local/share/nvim/parrot/chats/2025-03-02.08-58-38.406.md
  -- Topics examples:
  -- # topic: TypeScript: Types, Tools, Innovation
  -- # topic: Git branch divergence

  local bufnr = vim.api.nvim_create_buf(false, true)
  local posOpts = FloatOpts_inOtherWinColumn()
  local floating_winId = vim.api.nvim_open_win( bufnr, false, posOpts )
  vim.g['floating_win'] = floating_winId
  vim.api.nvim_set_current_win(floating_winId)
  vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')

  -- Expand the path and get files
  local expanded_path = vim.fn.expand(folder_path)
  local files = vim.fn.glob(expanded_path .. "/*.md", false, true)

  -- Sort files by name (which includes timestamp)
  table.sort(files, function(a, b) return a > b end)

  -- Set the file paths in the buffer
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, files)


end



