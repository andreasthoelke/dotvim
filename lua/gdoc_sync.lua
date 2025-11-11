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

    -- Ensure styled link exists before saving
    ensure_gdoc_link()

    -- Save first
    vim.cmd('write')

    local file = vim.fn.expand('%:p')
    local doc_id = extract_gdoc_id()

    vim.notify("Pushing to Google Docs...", vim.log.levels.INFO)

    -- Run gdoc push
    vim.fn.jobstart({'gdoc', 'push', file}, {
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                -- Reload buffer to get updated frontmatter
                vim.cmd('edit!')
                -- Ensure link is present after reload
                ensure_gdoc_link()
                vim.notify("✓ Pushed to Google Docs", vim.log.levels.INFO)
            else
                vim.notify("✗ Failed to push to Google Docs", vim.log.levels.ERROR)
            end
        end,
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        print(line)
                    end
                end
            end
        end,
        on_stderr = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        vim.notify(line, vim.log.levels.WARN)
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
                -- Reload buffer
                vim.cmd('edit!')
                -- Ensure link is present after reload
                ensure_gdoc_link()
                vim.notify("✓ Pulled from Google Docs", vim.log.levels.INFO)
            else
                vim.notify("✗ Failed to pull from Google Docs", vim.log.levels.ERROR)
            end
        end,
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        print(line)
                    end
                end
            end
        end,
        on_stderr = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        vim.notify(line, vim.log.levels.WARN)
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

    vim.notify("Fetching recent Google Docs...", vim.log.levels.INFO)

    local output = {}

    vim.fn.jobstart({'gdoc', 'list'}, {
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        table.insert(output, line)
                    end
                end
            end
        end,
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                -- Display in a floating window or split
                local buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
                vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
                vim.api.nvim_buf_set_option(buf, 'filetype', 'text')

                -- Open in split
                vim.cmd('split')
                vim.api.nvim_win_set_buf(0, buf)
            else
                vim.notify("✗ Failed to list Google Docs", vim.log.levels.ERROR)
            end
        end,
    })
end

-- Add or update the styled Google Doc link (public function)
function M.update_link()
    if ensure_gdoc_link() then
        vim.notify("✓ Google Doc link updated", vim.log.levels.INFO)
    else
        vim.notify("No gdoc_id found in frontmatter", vim.log.levels.WARN)
    end
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

  return M
end


return M
