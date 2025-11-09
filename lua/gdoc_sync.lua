-- Google Docs sync integration for Neovim
-- Requires: gdoc script in PATH

local M = {}

-- Extract gdoc_id from frontmatter
local function extract_gdoc_id()
    local lines = vim.api.nvim_buf_get_lines(0, 0, 20, false)
    for _, line in ipairs(lines) do
        local id = line:match("^gdoc_id:%s*(%S+)")
        if id then
            return id
        end
    end
    return nil
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

-- Setup function to register keymaps
function M.setup(opts)
    opts = opts or {}

    -- Default keymaps (can be customized)
    local push_key = opts.push_key or '<leader>gp'
    local pull_key = opts.pull_key or '<leader>gl'
    local list_key = opts.list_key or '<leader>gL'

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
end

return M
