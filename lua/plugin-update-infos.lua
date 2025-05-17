local M = {}

-- Get the installed plugins directory path
local plugged_dir = vim.fn.expand('~/.config/nvim/plugged')

-- Function to format relative time
function M.format_relative_time(timestamp)
  if not timestamp then return nil end
  
  -- Parse the timestamp (format: YYYY-MM-DD HH:MM:SS)
  local year, month, day, hour, min, sec = timestamp:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
  if not year then return timestamp end -- Return original if parsing fails
  
  local time_table = {
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day),
    hour = tonumber(hour),
    min = tonumber(min),
    sec = tonumber(sec)
  }
  
  local time_then = os.time(time_table)
  local time_now = os.time()
  local diff_seconds = os.difftime(time_now, time_then)
  
  -- Convert to appropriate time unit
  if diff_seconds < 60 then
    return "just now"
  elseif diff_seconds < 3600 then
    local mins = math.floor(diff_seconds / 60)
    return mins .. " minute" .. (mins > 1 and "s" or "") .. " ago"
  elseif diff_seconds < 86400 then
    local hours = math.floor(diff_seconds / 3600)
    return hours .. " hour" .. (hours > 1 and "s" or "") .. " ago"
  elseif diff_seconds < 2592000 then
    local days = math.floor(diff_seconds / 86400)
    return days .. " day" .. (days > 1 and "s" or "") .. " ago"
  elseif diff_seconds < 31536000 then
    local months = math.floor(diff_seconds / 2592000)
    return months .. " month" .. (months > 1 and "s" or "") .. " ago"
  else
    local years = math.floor(diff_seconds / 31536000)
    return years .. " year" .. (years > 1 and "s" or "") .. " ago"
  end
end

-- Function to get a list of all plugin directories
function M.get_plugin_dirs()
  local plugin_dirs = {}
  local handle = vim.loop.fs_scandir(plugged_dir)
  
  if handle then
    while true do
      local name, type = vim.loop.fs_scandir_next(handle)
      if not name then break end
      
      if type == 'directory' then
        table.insert(plugin_dirs, name)
      end
    end
  end
  
  return plugin_dirs
end

-- Function to get the last update time for a plugin
function M.get_last_update_time(plugin_name)
  local plugin_path = plugged_dir .. '/' .. plugin_name
  
  -- Check if the plugin directory is a git repository
  local is_git_repo = vim.fn.isdirectory(plugin_path .. '/.git')
  if is_git_repo == 0 then
    return nil
  end
  
  -- Get the commit date of the current local HEAD
  local cmd_head_date = "cd " .. vim.fn.shellescape(plugin_path) .. 
                        " && git log -1 --format=%cd --date=format:'%Y-%m-%d %H:%M:%S'"
  local head_date = vim.fn.system(cmd_head_date):gsub("%s+$", "")
  
  if vim.v.shell_error ~= 0 or head_date == "" then
    return nil
  end
  
  return head_date
end

-- Function to get git commits since last update for a plugin
function M.get_plugin_commits(plugin_name)
  local plugin_path = plugged_dir .. '/' .. plugin_name
  
  -- Check if the plugin directory is a git repository
  local is_git_repo = vim.fn.isdirectory(plugin_path .. '/.git')
  if is_git_repo == 0 then
    return false, plugin_name .. " is not a git repository"
  end
  
  -- Get the current local head commit
  local cmd_local_head = "cd " .. vim.fn.shellescape(plugin_path) .. " && git rev-parse HEAD"
  local local_head = vim.fn.system(cmd_local_head):gsub("%s+", "")
  
  if vim.v.shell_error ~= 0 then
    return false, "Failed to get local HEAD for " .. plugin_name
  end
  
  -- Get the remote repository URL
  local cmd_remote = "cd " .. vim.fn.shellescape(plugin_path) .. " && git remote get-url origin"
  local remote_url = vim.fn.system(cmd_remote):gsub("%s+", "")
  
  if vim.v.shell_error ~= 0 then
    return false, "Failed to get remote URL for " .. plugin_name
  end
  
  -- Fetch the latest changes from remote
  local cmd_fetch = "cd " .. vim.fn.shellescape(plugin_path) .. " && git fetch"
  vim.fn.system(cmd_fetch)
  
  if vim.v.shell_error ~= 0 then
    return false, "Failed to fetch from remote for " .. plugin_name
  end
  
  -- Get the remote head (usually origin/master or origin/main)
  local cmd_remote_branch = "cd " .. vim.fn.shellescape(plugin_path) .. " && git symbolic-ref refs/remotes/origin/HEAD"
  local remote_head = vim.fn.system(cmd_remote_branch):gsub("%s+", "")
  
  -- If refs/remotes/origin/HEAD is not set, try to guess the default branch
  if vim.v.shell_error ~= 0 then
    -- Try common default branch names
    for _, branch in ipairs({"origin/main", "origin/master"}) do
      local cmd_check_branch = "cd " .. vim.fn.shellescape(plugin_path) .. " && git rev-parse --verify " .. branch
      local result = vim.fn.system(cmd_check_branch)
      if vim.v.shell_error == 0 then
        remote_head = branch
        break
      end
    end
    
    -- If we still don't have a remote branch, return an error
    if remote_head == "" then
      return false, "Failed to determine remote HEAD branch for " .. plugin_name
    end
  else
    -- Convert from refs/remotes/origin/HEAD to origin/main or origin/master format
    remote_head = remote_head:gsub("refs/remotes/", "")
  end
  
  -- Get commits that are in remote but not in local
  local cmd_new_commits = "cd " .. vim.fn.shellescape(plugin_path) .. 
                         " && git log --no-merges " .. local_head .. ".." .. remote_head .. 
                         " --pretty=format:'%h %ad (%ar) %s' --date=short"
  local output = vim.fn.system(cmd_new_commits)
  
  if vim.v.shell_error ~= 0 then
    return false, "Failed to get new commits for " .. plugin_name
  end
  
  if output == "" then
    return true, "No new commits available for " .. plugin_name
  end
  
  return true, output
end

-- Function to display the commits in a new buffer
function M.show_plugin_commits(plugin_name)
  local success, result = M.get_plugin_commits(plugin_name)
  local last_update_time = M.get_last_update_time(plugin_name)
  
  -- Create a new scratch buffer
  vim.cmd('new')
  vim.cmd('setlocal buftype=nofile bufhidden=wipe noswapfile')
  vim.cmd('setlocal filetype=git')
  
  -- Set the buffer name
  vim.api.nvim_buf_set_name(0, "Plugin Commits: " .. plugin_name)
  
  -- Add the header
  local lines = {
    "New commits for " .. plugin_name .. " (not in local repo)",
    "-------------------------",
    ""
  }
  
  -- Add last update time if available
  if last_update_time then
    local relative_time = M.format_relative_time(last_update_time)
    table.insert(lines, "Last updated: " .. (relative_time or last_update_time))
    table.insert(lines, "")
  end
  
  -- Add the commit info
  if success then
    if result:match("No new commits") then
      table.insert(lines, result)
    else
      for line in result:gmatch("[^\r\n]+") do
        table.insert(lines, line)
      end
    end
  else
    table.insert(lines, "Error: " .. result)
  end
  
  -- Set the buffer contents
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  
  -- Make the buffer readonly
  vim.cmd('setlocal nomodifiable readonly')
end

-- Command completion function for plugin names
function M.complete_plugin_names(arg_lead, cmd_line, cursor_pos)
  local plugins = M.get_plugin_dirs()
  local matches = {}
  
  for _, plugin in ipairs(plugins) do
    if plugin:lower():match('^' .. arg_lead:lower()) then
      table.insert(matches, plugin)
    end
  end
  
  return matches
end

-- Function to set up the plugin command
function M.setup()
  vim.cmd([[
    command! -nargs=1 -complete=customlist,v:lua.require'plugin-update-infos'.complete_plugin_names PlugPreUpdateInfos lua require'plugin-update-infos'.show_plugin_commits(<q-args>)
  ]])
end

return M
