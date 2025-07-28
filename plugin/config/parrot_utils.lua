
function _G.SaveChatBuffer()
  local folder_path = "~/.local/share/nvim/parrot/chats"
  -- just grab the text from the current buffer. e.g. like:
  local bufnr = vim.api.nvim_get_current_buf()
  local text = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  -- File paths example: /Users/at/.local/share/nvim/parrot/chats/2025-03-02.08-58-38.md
  local filepath = folder_path .. "/" .. os.date("%Y-%m-%d.%H-%M-%S") .. ".md"
  local file = io.open(filepath, "w")
  if file then
    for _, line in ipairs(text) do
      file:write(line .. "\n")
    end
    file:close()
    print("Saved to " .. filepath)
  else
    print("Error saving to " .. filepath)
  end

end


function _G.ShowParrotChatsView()
  local folder_path = "~/.local/share/nvim/parrot/chats"
  -- File paths example: /Users/at/.local/share/nvim/parrot/chats/2025-03-02.08-58-38.406.md
  -- Topics examples (this is the first line of the file):
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

  -- Group files by date
  local groups = {}
  local group_order = {}

  for _, filepath in ipairs(files) do
    local filename = vim.fn.fnamemodify(filepath, ':t')
    local date = filename:match("^(%d%d%d%d%-%d%d%-%d%d)")

    if not date then
      date = "other"  -- Group files without standard date format
    end

    if not groups[date] then
      groups[date] = {}
      table.insert(group_order, date)
    end
    table.insert(groups[date], filepath)
  end

  -- Create buffer lines and store file paths with proper indexing
  local buffer_lines = {}
  local file_paths_with_headers = {}

  for _, date in ipairs(group_order) do
    -- Format date header
    local date_display = date
    if date ~= "other" then
      -- Format date nicely (e.g., "2025-03-02" -> "March 2, 2025")
      local year, month, day = date:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
      if year and month and day then
        local months = {"January", "February", "March", "April", "May", "June",
                       "July", "August", "September", "October", "November", "December"}
        date_display = string.format("%s %d, %s", months[tonumber(month)], tonumber(day), year)
      end
    end

    -- Add date header line
    table.insert(buffer_lines, date_display)
    table.insert(file_paths_with_headers, nil)  -- nil for header lines

    -- Add file lines for this date
    for _, filepath in ipairs(groups[date]) do
      local filename = vim.fn.fnamemodify(filepath, ':t')
      local display_text = ""

      -- Extract time from filename if available
      local time = filename:match("^%d%d%d%d%-%d%d%-%d%d%.(%d%d%-%d%d%-%d%d)")
      if time then
        -- Convert to HH:MM format (without seconds)
        local hour, minute = time:match("^(%d%d)%-(%d%d)")
        display_text = "  " .. hour .. ":" .. minute
      else
        -- For files like claude_code_9790.md, show the filename without extension
        display_text = "  " .. (filename:match("^(.+)%.md$") or filename)
      end

      -- Read the first line to get the topic
      local file = io.open(filepath, "r")
      if file then
        local first_line = file:read("*l")
        file:close()

        -- Extract topic from the first line (format: # topic: ...)
        local topic = first_line and first_line:match("^#%s*topic:%s*(.+)$")
        if topic then
          -- Trim whitespace
          topic = topic:gsub("^%s*(.-)%s*$", "%1")
          display_text = display_text .. " - " .. topic
        end
      end

      -- Append the file path
      display_text = display_text .. " | " .. filepath

      table.insert(buffer_lines, display_text)
      table.insert(file_paths_with_headers, filepath)
    end
  end

  -- Store the modified file paths array
  vim.api.nvim_buf_set_var(bufnr, 'file_paths', file_paths_with_headers)

  -- Set buffer lines
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, buffer_lines)

  -- Set up concealment for file paths
  vim.api.nvim_win_set_option(floating_winId, 'conceallevel', 2)
  vim.api.nvim_win_set_option(floating_winId, 'concealcursor', 'nc')

  -- Create syntax match for the file path portion (after " | ")
  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd([[syntax match ParrotChatFilePath / | .*$/ conceal]])
    -- Add syntax match for date headers (lines that don't start with spaces)
    vim.cmd([[syntax match ParrotChatDateHeader /^[^ ].*$/]])
    -- Link the date header to a highlight group
    vim.cmd([[highlight link ParrotChatDateHeader Title]])
  end)

end



