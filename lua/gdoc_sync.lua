-- Google Docs sync integration for Neovim
-- Requires: gdoc script in PATH
-- ~/.config/utils_global/gdoc
-- Setup README (note this involves Google Auth via rclone): ~/.config/utils_global/gdoc_README.md

-- Keymaps:
--   plugin/config/maps.lua‖*GoogleˍDocsˍsyncˍwithˍmarkdown

-- This uses: "frontmatter" or "YAML frontmatter".
--   It's a standard markdown convention where metadata is placed at the top of the file between
--    triple dashes:

--   ---
--   gdoc_id: 1ABC...XYZ
--   title: My Document
--   author: Jane Doe
--   date: 2025-01-01
--   ---

--   # Your actual content starts here



local M = {}

-- Strip ANSI escape codes from string
local function strip_ansi(str)
    -- Remove ANSI color codes like ^[[1;33m and ^[[0m
    return str:gsub("\27%[%d+;%d+m", ""):gsub("\27%[%d+m", "")
end

-- Extract gdoc_id from frontmatter
-- Handles both plain ID format and full URL format
local function extract_gdoc_id()
    local lines = vim.api.nvim_buf_get_lines(0, 0, 20, false)
    for _, line in ipairs(lines) do
        -- Try plain ID format first
        local id = line:match("^gdoc_id:%s*(%S+)")
        if id then
            -- If it's a full URL, extract just the ID
            local url_id = id:match("/d/([^/]+)")
            if url_id then
                return url_id
            end
            return id
        end
    end
    return nil
end

-- Generate Google Docs URL from ID
local function generate_gdoc_url(doc_id)
    return string.format("https://docs.google.com/document/d/%s/edit", doc_id)
end

-- Ensure styled HTML link exists below frontmatter
-- Returns true if link was added/updated, false if already present
local function ensure_gdoc_link()
    local doc_id = extract_gdoc_id()
    if not doc_id then
        return false
    end

    local lines = vim.api.nvim_buf_get_lines(0, 0, 30, false)
    local frontmatter_end = nil
    local link_line = nil
    local in_frontmatter = false

    -- Find frontmatter end and existing link
    for i, line in ipairs(lines) do
        if i == 1 and line == "---" then
            in_frontmatter = true
        elseif in_frontmatter and line == "---" then
            frontmatter_end = i - 1  -- 0-indexed
            in_frontmatter = false
        elseif not in_frontmatter and line:match("📄 Google Doc") then
            link_line = i - 1  -- 0-indexed
            break
        end
    end

    if not frontmatter_end then
        return false
    end

    local url = generate_gdoc_url(doc_id)
    local styled_link = string.format('<small><a href="%s">📄 Google Doc</a></small>', url)

    -- If link exists, update it
    if link_line then
        vim.api.nvim_buf_set_lines(0, link_line, link_line + 1, false, {styled_link})
        return true
    end

    -- Otherwise, insert it after frontmatter
    -- Check if there's already a blank line after frontmatter
    local insert_pos = frontmatter_end + 1
    local next_line = lines[insert_pos + 1]

    if next_line == "" then
        -- Insert link and keep blank line
        vim.api.nvim_buf_set_lines(0, insert_pos, insert_pos, false, {"", styled_link})
    else
        -- Insert blank line, link, and another blank line
        vim.api.nvim_buf_set_lines(0, insert_pos, insert_pos, false, {"", styled_link, ""})
    end

    return true
end

-- Check if gdoc command is available
local function check_gdoc_available()
    local handle = io.popen("which gdoc 2>/dev/null")
    if not handle then
        return false
    end
    local result = handle:read("*a")
    handle:close()
    return result and result ~= ""
end

-- Push current buffer to Google Docs
function M.push()
    if not check_gdoc_available() then
        vim.notify("gdoc command not found. Make sure ~/.local/bin is in your PATH", vim.log.levels.ERROR)
        return
    end

    -- Update existing link if gdoc_id already exists
    local has_id = extract_gdoc_id() ~= nil
    if has_id then
        ensure_gdoc_link()
    end

    -- Save first
    vim.cmd('write')

    local file = vim.fn.expand('%:p')

    vim.notify("Pushing to Google Docs...", vim.log.levels.INFO)

    -- Run gdoc push
    vim.fn.jobstart({'gdoc', 'push', file}, {
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                -- Schedule reload to happen after job completes
                vim.schedule(function()
                    -- Safely reload buffer to get updated frontmatter
                    local bufnr = vim.fn.bufnr('%')
                    if bufnr ~= -1 and vim.fn.bufname(bufnr) ~= '' then
                        vim.cmd('edit!')
                        -- Ensure link is present after reload (now gdoc_id should exist)
                        ensure_gdoc_link()
                    end
                end)
                vim.notify("✓ Pushed to Google Docs", vim.log.levels.INFO)
            else
                vim.notify("✗ Failed to push to Google Docs", vim.log.levels.ERROR)
            end
        end,
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        print(strip_ansi(line))
                    end
                end
            end
        end,
        on_stderr = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        vim.notify(strip_ansi(line), vim.log.levels.WARN)
                    end
                end
            end
        end,
    })
end

-- Pull from Google Docs to current buffer
function M.pull()
    if not check_gdoc_available() then
        vim.notify("gdoc command not found. Make sure ~/.local/bin is in your PATH", vim.log.levels.ERROR)
        return
    end

    local doc_id = extract_gdoc_id()

    if not doc_id then
        vim.notify("No gdoc_id found in frontmatter", vim.log.levels.ERROR)
        return
    end

    local file = vim.fn.expand('%:p')

    vim.notify("Pulling from Google Docs...", vim.log.levels.INFO)

    -- Run gdoc pull
    vim.fn.jobstart({'gdoc', 'pull', doc_id, file}, {
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                -- Schedule reload to happen after job completes
                vim.schedule(function()
                    -- Safely reload buffer
                    local bufnr = vim.fn.bufnr('%')
                    if bufnr ~= -1 and vim.fn.bufname(bufnr) ~= '' then
                        vim.cmd('edit!')
                        -- Ensure link is present after reload
                        ensure_gdoc_link()
                    end
                end)
                vim.notify("✓ Pulled from Google Docs", vim.log.levels.INFO)
            else
                vim.notify("✗ Failed to pull from Google Docs", vim.log.levels.ERROR)
            end
        end,
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        print(strip_ansi(line))
                    end
                end
            end
        end,
        on_stderr = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        vim.notify(strip_ansi(line), vim.log.levels.WARN)
                    end
                end
            end
        end,
    })
end

-- List recent Google Docs
function M.list()
    if not check_gdoc_available() then
        vim.notify("gdoc command not found. Make sure ~/.local/bin is in your PATH", vim.log.levels.ERROR)
        return
    end

    -- Store the source directory from the current window before creating the list buffer
    local source_dir = vim.fn.expand('%:p:h')
    if source_dir == '' then
        source_dir = vim.fn.getcwd()
    end

    vim.notify("Fetching recent Google Docs...", vim.log.levels.INFO)

    local raw_output = {}

    vim.fn.jobstart({'gdoc', 'list'}, {
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        table.insert(raw_output, line)
                    end
                end
            end
        end,
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                -- Parse output and convert to markdown links
                local formatted_output = {"# Recent Google Docs", ""}
                for _, line in ipairs(raw_output) do
                    local clean_line = strip_ansi(line)
                    -- Parse format: "title    doc_id"
                    local title, doc_id = clean_line:match("^(.-)%s%s+([%w_-]+)$")
                    if title and doc_id then
                        local url = generate_gdoc_url(doc_id)
                        -- Create markdown link
                        table.insert(formatted_output, string.format("- [%s](%s)", title, url))
                    end
                end

                -- Display in a floating window or split
                local buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted_output)
                vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
                vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')

                -- Store source directory as buffer variable
                vim.api.nvim_buf_set_var(buf, 'gdoc_source_dir', source_dir)

                -- Set up buffer-local keymaps
                -- dd: Remove integration
                vim.api.nvim_buf_set_keymap(buf, 'n', 'dd', '', {
                    noremap = true,
                    silent = true,
                    callback = function()
                        -- Get the current line
                        local line = vim.api.nvim_get_current_line()
                        -- Extract doc_id from markdown link: [title](url/d/ID/edit)
                        local doc_id = line:match("/d/([^/]+)/")
                        if doc_id then
                            -- Ask user what to do
                            local choice = vim.fn.confirm(
                                "Remove Google Docs integration for this doc?",
                                "&Remove from local files\n&Open in browser\n&Cancel",
                                3
                            )
                            if choice == 1 then
                                M.remove(false, doc_id)
                            elseif choice == 2 then
                                M.remove(true, doc_id)
                            end
                        end
                    end
                })

                -- <CR>: Create/download markdown file from Google Doc
                vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '', {
                    noremap = true,
                    silent = true,
                    callback = function()
                        local line = vim.api.nvim_get_current_line()
                        -- Extract title and doc_id from markdown link: - [title](url/d/ID/edit)
                        local title = line:match("%[([^%]]+)%]")
                        local doc_id = line:match("/d/([^/]+)/")
                        if title and doc_id then
                            local target_dir = vim.b.gdoc_source_dir or vim.fn.getcwd()
                            M.create_from_gdoc(doc_id, title, target_dir)
                        else
                            vim.notify("No Google Doc link found on this line", vim.log.levels.WARN)
                        end
                    end
                })

                -- gd: Show diff for existing file (if any)
                vim.api.nvim_buf_set_keymap(buf, 'n', 'gd', '', {
                    noremap = true,
                    silent = true,
                    callback = function()
                        local line = vim.api.nvim_get_current_line()
                        local doc_id = line:match("/d/([^/]+)/")
                        if doc_id then
                            local target_dir = vim.b.gdoc_source_dir or vim.fn.getcwd()
                            local existing_file = find_existing_file_for_gdoc(doc_id, target_dir)
                            if existing_file then
                                M.show_diff(doc_id, existing_file)
                            else
                                vim.notify("No local file found for this Google Doc", vim.log.levels.WARN)
                            end
                        end
                    end
                })

                vim.api.nvim_buf_set_option(buf, 'modifiable', false)

                -- Open in split
                vim.cmd('split')
                vim.api.nvim_win_set_buf(0, buf)

                -- Show help message
                vim.notify("Keys: <CR> create/update file | gd show diff | dd remove integration", vim.log.levels.INFO)
            else
                vim.notify("✗ Failed to list Google Docs", vim.log.levels.ERROR)
            end
        end,
    })
end

-- Remove frontmatter and link from a file
local function remove_gdoc_from_file(filepath)
    -- Read file
    local file = io.open(filepath, "r")
    if not file then
        return false
    end
    local content = file:read("*all")
    file:close()

    local lines = vim.split(content, "\n")
    local new_lines = {}
    local in_frontmatter = false
    local frontmatter_end = false
    local skip_next_blank = false

    for i, line in ipairs(lines) do
        if i == 1 and line == "---" then
            in_frontmatter = true
        elseif in_frontmatter and line == "---" then
            in_frontmatter = false
            frontmatter_end = true
            skip_next_blank = true
        elseif frontmatter_end and line:match("📄 Google Doc") then
            skip_next_blank = true
        elseif skip_next_blank and line == "" then
            skip_next_blank = false
        elseif not in_frontmatter and not frontmatter_end then
            table.insert(new_lines, line)
        elseif frontmatter_end and not line:match("📄 Google Doc") then
            frontmatter_end = false
            table.insert(new_lines, line)
        end
    end

    -- Write back
    file = io.open(filepath, "w")
    if not file then
        return false
    end
    file:write(table.concat(new_lines, "\n"))
    file:close()

    return true
end

-- Find markdown files containing a specific gdoc_id
local function find_files_with_gdoc_id(doc_id, search_path)
    search_path = search_path or vim.fn.getcwd()
    local cmd = string.format('grep -r "gdoc_id: %s" %s --include="*.md" -l 2>/dev/null', doc_id, search_path)
    local handle = io.popen(cmd)
    if not handle then
        return {}
    end
    local result = handle:read("*all")
    handle:close()

    local files = {}
    for file in result:gmatch("[^\r\n]+") do
        table.insert(files, file)
    end
    return files
end

-- Generate safe filename from title
local function title_to_filename(title)
    -- Replace spaces with underscores, remove special characters
    local safe = title:gsub("%s+", "_"):gsub("[^%w_-]", ""):lower()
    return safe .. ".md"
end

-- Get unique filepath, adding postfix if file exists
local function get_unique_filepath(dir, filename)
    local base = filename:match("(.+)%.md$")
    local filepath = dir .. "/" .. filename
    local counter = 1

    while vim.fn.filereadable(filepath) == 1 do
        filepath = dir .. "/" .. base .. "_" .. counter .. ".md"
        counter = counter + 1
    end

    return filepath
end

-- Find existing file with same gdoc_id in directory
local function find_existing_file_for_gdoc(doc_id, dir)
    local files = find_files_with_gdoc_id(doc_id, dir)
    if #files > 0 then
        return files[1]
    end
    return nil
end

-- Create a new markdown file from a Google Doc
function M.create_from_gdoc(doc_id, title, target_dir)
    if not check_gdoc_available() then
        vim.notify("gdoc command not found. Make sure ~/.local/bin is in your PATH", vim.log.levels.ERROR)
        return
    end

    target_dir = target_dir or vim.fn.getcwd()

    -- Check if a file with this gdoc_id already exists
    local existing_file = find_existing_file_for_gdoc(doc_id, target_dir)

    if existing_file then
        -- v2: File exists with same gdoc_id - prompt user
        local choice = vim.fn.confirm(
            string.format("File already exists for this doc:\n%s\n\nWhat would you like to do?",
                vim.fn.fnamemodify(existing_file, ":~:.")),
            "&Update from Google Docs\n&Show diff\n&Open existing file\n&Cancel",
            4
        )

        if choice == 1 then
            -- Update existing file
            M.pull_to_file(doc_id, existing_file)
        elseif choice == 2 then
            -- Show diff
            M.show_diff(doc_id, existing_file)
        elseif choice == 3 then
            -- Open existing file
            vim.cmd('edit ' .. vim.fn.fnameescape(existing_file))
        end
        return
    end

    -- Generate filename and get unique path
    local filename = title_to_filename(title)
    local filepath = get_unique_filepath(target_dir, filename)

    vim.notify(string.format("Creating %s from Google Docs...", vim.fn.fnamemodify(filepath, ":t")), vim.log.levels.INFO)

    -- Run gdoc pull to create the file
    vim.fn.jobstart({'gdoc', 'pull', doc_id, filepath}, {
        on_exit = function(_, exit_code)
            vim.schedule(function()
                if exit_code == 0 then
                    -- Open the new file
                    vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
                    -- Ensure link is present
                    ensure_gdoc_link()
                    vim.notify(string.format("✓ Created %s", vim.fn.fnamemodify(filepath, ":~:.")), vim.log.levels.INFO)
                else
                    vim.notify("✗ Failed to create file from Google Docs", vim.log.levels.ERROR)
                end
            end)
        end,
        on_stderr = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        vim.notify(strip_ansi(line), vim.log.levels.WARN)
                    end
                end
            end
        end,
    })
end

-- Pull to a specific file (for updating existing files)
function M.pull_to_file(doc_id, filepath)
    if not check_gdoc_available() then
        vim.notify("gdoc command not found", vim.log.levels.ERROR)
        return
    end

    vim.notify(string.format("Updating %s from Google Docs...", vim.fn.fnamemodify(filepath, ":t")), vim.log.levels.INFO)

    vim.fn.jobstart({'gdoc', 'pull', doc_id, filepath}, {
        on_exit = function(_, exit_code)
            vim.schedule(function()
                if exit_code == 0 then
                    -- Open/reload the file
                    local current_buf = vim.fn.bufnr(filepath)
                    if current_buf ~= -1 then
                        vim.api.nvim_buf_call(current_buf, function()
                            vim.cmd('edit!')
                        end)
                    else
                        vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
                    end
                    ensure_gdoc_link()
                    vim.notify(string.format("✓ Updated %s", vim.fn.fnamemodify(filepath, ":~:.")), vim.log.levels.INFO)
                else
                    vim.notify("✗ Failed to update from Google Docs", vim.log.levels.ERROR)
                end
            end)
        end,
        on_stderr = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        vim.notify(strip_ansi(line), vim.log.levels.WARN)
                    end
                end
            end
        end,
    })
end

-- Show diff between Google Doc and local file
function M.show_diff(doc_id, filepath)
    if not check_gdoc_available() then
        vim.notify("gdoc command not found", vim.log.levels.ERROR)
        return
    end

    -- Create a temp file to pull the Google Doc content
    local tempfile = vim.fn.tempname() .. ".md"

    vim.notify("Fetching Google Doc for diff...", vim.log.levels.INFO)

    vim.fn.jobstart({'gdoc', 'pull', doc_id, tempfile}, {
        on_exit = function(_, exit_code)
            vim.schedule(function()
                if exit_code == 0 then
                    -- Open diff view
                    vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
                    vim.cmd('diffthis')
                    vim.cmd('vsplit ' .. vim.fn.fnameescape(tempfile))
                    vim.cmd('diffthis')
                    -- Set temp buffer name for clarity
                    vim.api.nvim_buf_set_name(0, "[Google Doc: " .. doc_id:sub(1, 8) .. "...]")
                    vim.bo.buftype = 'nofile'
                    vim.bo.bufhidden = 'wipe'
                    vim.notify("Showing diff: local (left) vs Google Doc (right)", vim.log.levels.INFO)
                else
                    vim.notify("✗ Failed to fetch Google Doc for diff", vim.log.levels.ERROR)
                end
            end)
        end,
        on_stderr = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        vim.notify(strip_ansi(line), vim.log.levels.WARN)
                    end
                end
            end
        end,
    })
end

-- Remove Google Docs integration from current file or by doc_id
function M.remove(open_browser, doc_id)
    -- If doc_id is provided, search for files with that ID
    if doc_id then
        local url = generate_gdoc_url(doc_id)

        if open_browser then
            vim.fn.system(string.format('open "%s"', url))
            vim.notify("✓ Opened Google Doc in browser", vim.log.levels.INFO)
            return
        end

        -- Search for files
        local files = find_files_with_gdoc_id(doc_id)

        if #files == 0 then
            vim.notify(string.format("No local files found with gdoc_id\nOpening in browser: %s", url), vim.log.levels.WARN)
            vim.fn.system(string.format('open "%s"', url))
            return
        end

        -- Remove from all found files
        for _, file in ipairs(files) do
            if remove_gdoc_from_file(file) then
                vim.notify(string.format("✓ Removed integration from: %s", vim.fn.fnamemodify(file, ":~:.")), vim.log.levels.INFO)
            end
        end
        return
    end

    -- Otherwise, work with current buffer
    local current_doc_id = extract_gdoc_id()

    if not current_doc_id then
        vim.notify("No gdoc_id found in frontmatter", vim.log.levels.WARN)
        return
    end

    local url = generate_gdoc_url(current_doc_id)

    if open_browser then
        vim.fn.system(string.format('open "%s"', url))
        vim.notify("✓ Opened Google Doc in browser", vim.log.levels.INFO)
        return
    end

    -- Remove frontmatter and link from current buffer
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local new_lines = {}
    local in_frontmatter = false
    local frontmatter_end = false
    local skip_next_blank = false

    for i, line in ipairs(lines) do
        if i == 1 and line == "---" then
            in_frontmatter = true
        elseif in_frontmatter and line == "---" then
            in_frontmatter = false
            frontmatter_end = true
            skip_next_blank = true
        elseif frontmatter_end and line:match("📄 Google Doc") then
            skip_next_blank = true
        elseif skip_next_blank and line == "" then
            skip_next_blank = false
        elseif not in_frontmatter and not frontmatter_end then
            table.insert(new_lines, line)
        elseif frontmatter_end and not line:match("📄 Google Doc") then
            frontmatter_end = false
            table.insert(new_lines, line)
        end
    end

    -- Update buffer
    vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)

    -- Save the file
    vim.cmd('write')

    vim.notify(string.format("✓ Removed Google Docs integration\nRemote doc: %s", url), vim.log.levels.INFO)
end

-- Add or update the styled Google Doc link (public function)
function M.update_link()
    if ensure_gdoc_link() then
        vim.notify("✓ Google Doc link updated", vim.log.levels.INFO)
    else
        vim.notify("No gdoc_id found in frontmatter", vim.log.levels.WARN)
    end
end

-- Create a new file from a Google Doc URL or ID
-- Usage: :GDocCreate <url_or_id> [title]
function M.create(url_or_id, title)
    if not url_or_id or url_or_id == '' then
        vim.notify("Usage: :GDocCreate <url_or_id> [title]", vim.log.levels.ERROR)
        return
    end

    -- Extract doc_id from URL if provided
    local doc_id = url_or_id:match("/d/([^/]+)") or url_or_id

    -- Use provided title or prompt for one
    if not title or title == '' then
        title = vim.fn.input("Document title: ")
        if title == '' then
            title = "untitled_" .. doc_id:sub(1, 8)
        end
    end

    local target_dir = vim.fn.expand('%:p:h')
    if target_dir == '' then
        target_dir = vim.fn.getcwd()
    end

    M.create_from_gdoc(doc_id, title, target_dir)
end

-- Setup function to register keymaps
function M.setup(opts)
  opts = opts or {}

  -- Default keymaps (can be customized)
  local push_key = opts.push_key or '<leader><leader>dp'
  local pull_key = opts.pull_key or '<leader><leader>df'
  local list_key = opts.list_key or '<leader><leader>dl'

  -- Register keymaps for markdown files
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
      vim.keymap.set('n', push_key, M.push, {
        buffer = true,
        desc = 'Push to Google Docs'
      })

      vim.keymap.set('n', pull_key, M.pull, {
        buffer = true,
        desc = 'Pull from Google Docs'
      })

      vim.keymap.set('n', list_key, M.list, {
        buffer = true,
        desc = 'List Google Docs'
      })
    end,
  })

  -- Create user commands
  vim.api.nvim_create_user_command('GDocPush', M.push, {
    desc = 'Push current markdown file to Google Docs'
  })

  vim.api.nvim_create_user_command('GDocPull', M.pull, {
    desc = 'Pull Google Doc to current file'
  })

  vim.api.nvim_create_user_command('GDocList', M.list, {
    desc = 'List recent Google Docs'
  })

  vim.api.nvim_create_user_command('GDocUpdateLink', M.update_link, {
    desc = 'Add/update styled Google Doc link in current file'
  })

  vim.api.nvim_create_user_command('GDocRemove', function(opts)
    M.remove(opts.bang, nil)
  end, {
    bang = true,
    desc = 'Remove Google Docs integration (use ! to open in browser instead)'
  })

  vim.api.nvim_create_user_command('GDocCreate', function(opts)
    local args = vim.split(opts.args, '%s+', { trimempty = true })
    local url_or_id = args[1]
    local title = table.concat(vim.list_slice(args, 2), ' ')
    M.create(url_or_id, title ~= '' and title or nil)
  end, {
    nargs = '+',
    desc = 'Create markdown file from Google Doc URL or ID',
    complete = function()
      return {}
    end,
  })

  vim.api.nvim_create_user_command('GDocDiff', function(opts)
    local doc_id = opts.args:match("/d/([^/]+)") or opts.args
    local filepath = vim.fn.expand('%:p')
    if filepath == '' then
      vim.notify("No file open to diff against", vim.log.levels.ERROR)
      return
    end
    M.show_diff(doc_id, filepath)
  end, {
    nargs = 1,
    desc = 'Show diff between current file and Google Doc',
  })

  return M
end


return M
