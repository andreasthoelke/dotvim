
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

  -- Store file paths as buffer variable for later use
  vim.api.nvim_buf_set_var(bufnr, 'file_paths', files)

  -- Create empty lines for each file
  local empty_lines = {}
  for i = 1, #files do
    table.insert(empty_lines, "")
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, empty_lines)

  -- Create namespace for virtual text
  local ns_id = vim.api.nvim_create_namespace('parrot_chats_dates')

  -- Extract dates and add virtual text
  for i, filepath in ipairs(files) do
    local filename = vim.fn.fnamemodify(filepath, ':t')
    local display_text = ""
    
    -- Try to extract date from filename (YYYY-MM-DD)
    local date = filename:match("^(%d%d%d%d%-%d%d%-%d%d)")
    
    if date then
      display_text = date
    else
      -- For files like claude_code_9790.md, show the filename without extension
      display_text = filename:match("^(.+)%.md$") or filename
    end
    
    -- Add virtual text at the beginning of the line
    vim.api.nvim_buf_set_extmark(bufnr, ns_id, i-1, 0, {
      virt_text = {{display_text, 'Normal'}},
      virt_text_pos = 'overlay',
    })
  end

  -- Make buffer non-modifiable
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)

end



