
-- This was previously the aider.lua config

-- Note there are two aider plugins:
-- 1. the code below (copied from github) which allows to only focus aider on the visually selected text
-- 2. aider.nvim: ~/.config/nvim/plugged/aider.nvim/lua/aider.lua
-- This is modified! 
-- ~/.config/nvim/plugged/aider.nvim/lua/aider.lua‖/functionˍM.AiderOpen(
-- WriteLspWarnings  ~/.config/nvim/plugged/aider.nvim/lua/aider.lua‖/functionˍ_G
-- ~/Documents/Notes/Mindmap_app.md‖/##ˍaider.nv
-- - adds the current file to running chat
-- - i'll have to delete files or reset chat
-- - allows to close aider window and re-open it in different tabs
-- - always write lsp warnings of the current buffer to /tmp/nvim_lsp_warnings.txt and includes this file on aider start.

-- Define a cmd that calls lua _G.WriteLspWarnings()
vim.api.nvim_create_user_command('LspWarnFileUpdate', function()
    _G.WriteLspWarnings()
end, {
    desc = "Write LSP warnings to the local .lsp_warn file"
})

-- require('claude_code').aider_buf


-- note: help aider
require('claude_code').setup({
  auto_manage_context = false,
  default_bindings = false,
  -- NOTE this works and is useful!
  debug = false,
  -- test this. this was to double make sure that its not loaded. but still written.
  restore_history = false,
  vim = true, --

  -- only necessary if you want to change the default keybindings. <Leader>C is not a particularly good choice. It's just shown as an example.
  -- vim.api.nvim_set_keymap('n', '<c-g>v', ':AiderOpen<CR>', {noremap = true, silent = true})
})


-- Note there's also an autocmd here: ~/.config/nvim/plugged/aider.nvim/lua/helpers.lua‖/localˍfunctionˍsetup_
-- but this only updates on term focus, not on open aider term?
function _G.Aider_open()
  Aider_updateAiderIgnore()
  -- run vim cmd :AiderOpen
  vim.cmd('AiderOpen')
end

-- function _G.ClaudeCode_open()
--   vim.cmd('ClaudeCodeOpen')
-- end


-- vim.keymap.set( 'n', '<c-g>v', Aider_open )
-- vim.keymap.set( 'n', '<c-g>v', ClaudeCode_open )

-- write a function _G.Aider_updateAiderIgnore() using _G.Ntree_getOpenFolders()
-- this is an example output: { "/Users/at/.config/nvim", "lua", "lua/utils", "plugin/config" }
-- where "/Users/at/.config/nvim" is the cwd and repo root (note this is the only absolute path). the other items are relative folder paths.
-- the function should update .aiderignore as follows:
-- the cwd (e.i. the absolute path matching the cwd) should be turned into this line:
-- !/*.*
-- the other normal folder paths (relative paths) of the example above would translate to the following lines:
-- !lua/*.*
-- !lua/config/*.*
-- !plugin/config/*.*
-- the lines need to be inserted into .aiderignore after the following comment:
-- # AUTOUPDATED by _G.Aider_updateAiderIgnore()
-- actually you can replace all lines until the end of the file with the new lines.

local aiderignore_default_lines = { '# Ignore everything', '/*', '# manually allow specific files and directories', '# AUTOUPDATED by _G.Aider_updateAiderIgnore()' }

function _G.Aider_updateAiderIgnore()

    -- Read existing .aiderignore content or create it
    local f = io.open(".aiderignore", "r")
    local content
    if not f then
        -- Create new file with default content
        f = io.open(".aiderignore", "w")
        if not f then return end
        content = table.concat(aiderignore_default_lines, '\n')
        f:write(content)
        f:close()
    else
        content = f:read("*all")
        f:close()
    end

    -- Get open folders
    local folders = _G.Ntree_getOpenFolders()

    -- Generate ignore patterns
    local patterns = {}
    local cwd = vim.fn.getcwd()
    
    for _, path in ipairs(folders) do
        if path == cwd then
            -- Handle the root/cwd path
            table.insert(patterns, "!/*.*")
        else
            -- Handle relative paths
            table.insert(patterns, "!" .. path .. "/*.*")
        end
    end
    -- 
    local openFiles = _G.OpenBuffersInTab()
    local filePatterns = {}
    for _, path in ipairs(openFiles) do
      table.insert(filePatterns, "!" .. path)
    end
    table.insert(filePatterns, "!" .. ".lsp_warn")

    -- Find the auto-update marker
    local marker = "# AUTOUPDATED by _G.Aider_updateAiderIgnore()"
    local before_marker = content:match("^(.-)%" .. marker)
    
    -- If marker not found, use whole content and append marker
    if not before_marker then
        before_marker = content
        if before_marker:sub(-1) ~= "\n" then
            before_marker = before_marker .. "\n"
        end
    end

    -- Write updated content
    f = io.open(".aiderignore", "w")
    if not f then return end
    f:write(before_marker)
    f:write(marker .. "\n")
    f:write(table.concat(patterns, "\n"))
    f:write("\n")
    f:write(table.concat(filePatterns, "\n"))
    f:close()
end

-- vim.keymap.set( 'n', '<leader>fu', Aider_updateAiderIgnore )

    -- if no folders are returned, set AUTOUPDATED section to empty 
    -- if not folders then return end


local function is_valid_buffer(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

  -- Ignore special buffers and directories
  if
      buftype ~= ""
      or filetype == "NvimTree"
      or filetype == "neo-tree"
      or bufname:match("^term://")
      or not vim.fn.filereadable(bufname)
      or vim.fn.isdirectory(bufname) == 1
  then
    return false
  end

  return true
end

function _G.OpenBuffersInTab()
  -- Get list of windows in current tab and add their buffers
  local current_tab = vim.api.nvim_get_current_tabpage()
  local windows = vim.api.nvim_tabpage_list_wins(current_tab)

  -- Create a function that checks if a buffer is in the current tab's windows
  local function is_buffer_in_current_tab(bufnr)
    if not is_valid_buffer(bufnr) then
      return false
    end
    for _, win in ipairs(windows) do
      if vim.api.nvim_win_get_buf(win) == bufnr then
        return true
      end
    end
    return false
  end

  -- Get list of buffers and add them to the aider session
  local buffers = vim.api.nvim_list_bufs()
  local files_to_add = {}
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) and is_buffer_in_current_tab(buf) then
      local bufname = vim.api.nvim_buf_get_name(buf)
      if vim.fn.filereadable(bufname) == 1 then
        local relative_filename = vim.fn.fnamemodify(bufname, ":~:.")
        table.insert(files_to_add, relative_filename)
      end
    end
  end
  -- putt( files_to_add )
  return files_to_add
end

vim.keymap.set( 'n', '<leader>fu', OpenBuffersInTab )

-- From https://github.com/ddzero2c/aider.nvim/blob/main/lua/aider/init.lua
local M = {}

-- Model name to flag mapping
local model_flags = {
    ["opus"] = "--opus",
    ["sonnet"] = "--sonnet",
    ["gpt-4"] = "--4",
    ["gpt-4o"] = "--4o",
    ["gpt-4o-mini"] = "--mini",
    ["gpt-4-turbo"] = "--4-turbo",
    ["gpt-3.5-turbo"] = "--35turbo",
    ["deepseek"] = "--deepseek",
    ["o1-mini"] = "--o1-mini",
    ["o1-preview"] = "--o1-preview"
}

-- Default configuration
local default_config = {
    dark_mode = true,
    command = 'aider',
    -- Main options
    model = 'sonnet', -- Default model
    mode = 'diff',    -- 'diff' or 'inline'
    -- Float window options
    float_opts = {
        relative = 'editor',
        width = 0.8,  -- As fraction of editor width
        height = 0.8, -- As fraction of editor height
        style = 'minimal',
        border = 'rounded',
        title = ' Aider ',
        title_pos = 'center',
    },
}

local function config_to_args(config)
    local args = {}

    table.insert(args, '--chat-mode=code')
    table.insert(args, '--no-auto-commits')
    table.insert(args, '--subtree-only')
    table.insert(args, '--cache-prompts')
    table.insert(args, '--no-stream')
    if config.dark_mode then
        table.insert(args, '--dark-mode')
    end
    if config.model then
        local flag = model_flags[config.model]
        if flag then
            table.insert(args, flag)
        else
            table.insert(args, '--model')
            table.insert(args, config.model)
        end
    end

    return args
end

local function build_aider_command(config, file_path, message)
    local args = config_to_args(config)
    local cmd = config.command

    table.insert(args, '--file')
    table.insert(args, file_path)

    if message then
        table.insert(args, '--message')
        -- Escape special characters and wrap in single quotes
        local escaped_message = message:gsub("'", "'\\''") -- Escape single quotes
        table.insert(args, "'" .. escaped_message .. "'")
    end

    for _, arg in ipairs(args) do
        cmd = cmd .. ' ' .. arg
    end

    return cmd
end

-- Check if aider is installed
local function check_aider_installed()
    local handle = io.popen("which aider")
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
end

-- 獲取文字內容
local function get_visual_selection(is_visual)
    if not is_visual then
        return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    end

    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.fn.getline(start_pos[2], end_pos[2])

    if #lines == 1 then
        lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
    else
        lines[1] = string.sub(lines[1], start_pos[3])
        lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
    end
    return table.concat(lines, "\n")
end


local function diff_buf(left, right)
    if not vim.api.nvim_buf_is_valid(left) or not vim.api.nvim_buf_is_valid(right) then
        vim.notify('invalid buffer', vim.log.levels.ERROR)
        return
    end

    vim.cmd('windo diffoff')
    local current_tab = vim.api.nvim_get_current_tabpage()
    local wins = vim.api.nvim_tabpage_list_wins(current_tab)
    if #wins < 2 then
        vim.cmd('vsplit')
    end

    wins = vim.api.nvim_tabpage_list_wins(current_tab)
    local left_win = wins[1]
    local right_win = wins[2]

    vim.api.nvim_win_call(left_win, function()
        vim.api.nvim_win_set_buf(left_win, left)
        vim.cmd('diffthis')
    end)

    vim.api.nvim_win_call(right_win, function()
        vim.api.nvim_win_set_buf(right_win, right)
        vim.cmd('diffthis')
    end)
    vim.api.nvim_set_current_win(right_win)
    vim.cmd('normal! gg')
    vim.cmd('normal! ]c')
end


local function handle_diff_mode(current_buf, content_before)
    vim.cmd('checktime')
    local content_after = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)
    vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, content_before)
    vim.cmd('write')

    local right_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(right_buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(right_buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(right_buf, 'swapfile', false)

    vim.api.nvim_buf_set_name(right_buf, ' [Aider Modified]')
    vim.api.nvim_buf_set_lines(right_buf, 0, -1, false, content_after)
    vim.api.nvim_buf_set_option(right_buf, 'readonly', true)
    vim.api.nvim_buf_set_option(right_buf, 'modifiable', false)
    diff_buf(current_buf, right_buf)
end

function M.aider_edit(opts)
    vim.cmd('write')
    local is_visual = opts and opts.range == true

    local current_file = vim.fn.expand('%:p')
    local current_buf = vim.api.nvim_get_current_buf()
    local content_before = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)
    local selected_text = get_visual_selection(is_visual)

    vim.ui.input({
        prompt = "> ",
        default = "",
    }, function(input)
        if input then
            local message = selected_text
            if input ~= "" then
                message = message .. "\n\nPrompt: " .. input
            end

            local cmd = build_aider_command(M.config, current_file, message)
            local width = math.floor(vim.o.columns * M.config.float_opts.width)
            local height = math.floor(vim.o.lines * M.config.float_opts.height)
            local row = math.floor((vim.o.lines - height) / 2)
            local col = math.floor((vim.o.columns - width) / 2)
            local float_opts = vim.tbl_extend("force", M.config.float_opts, {
                row = row,
                col = col,
                width = width,
                height = height,
            })
            local term_buf = vim.api.nvim_create_buf(false, true)
            local term_win = vim.api.nvim_open_win(term_buf, true, float_opts)

            local term_job_id = vim.fn.termopen(cmd, {
                on_exit = function(_, code)
                    vim.schedule(function()
                        if code == 0 then
                            vim.api.nvim_win_close(term_win, true)

                            vim.cmd('checktime')
                            if M.config.mode == 'diff' then
                                handle_diff_mode(current_buf, content_before)
                            end
                            vim.notify("Aider completed successfully", vim.log.levels.INFO)
                        else
                            vim.api.nvim_win_close(term_win, true)
                            vim.notify("Aider failed with code: " .. code, vim.log.levels.ERROR)
                        end
                    end)
                end
            })
            vim.cmd('startinsert')
        end
    end)
end

function M.setup(cfg)
    if not check_aider_installed() then
        vim.notify("Aider not found in PATH. Please install aider first.", vim.log.levels.ERROR)
        return
    end

    -- Merge user config with defaults
    M.config = vim.tbl_deep_extend("force", default_config, cfg or {})

    vim.api.nvim_create_user_command('AiderEdit', function(opts)
        M.aider_edit(opts)
    end, { range = true })
end

-- M.setup({})

-- vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew split<cr>", keymapOptions("Visual Chat New"))
-- AiderEdit
vim.keymap.set({'v', 'n'}, '<C-g>o', ':AiderEdit<CR>', { noremap = true, silent = true })

M.setup({
    command = 'aider',           -- Path to aider command
    model = 'sonnet',            -- model to use
    mode = 'diff',               -- Edit mode: 'diff' or 'inline'
    -- Floating window options
    float_opts = {
        relative = 'editor',
        width = 0.8,            -- 80% of editor width
        height = 0.8,           -- 80% of editor height
        style = 'minimal',
        border = 'rounded',
        title = ' Aider ',
        title_pos = 'center',
    },
})

return M





