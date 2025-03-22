
local M = {}
local loop = vim.loop
local api = vim.api


-- ─   Json                                              ■

-- Function to update a key in a JSON file
-- file_path: Path to the JSON file
-- host_key: First-level object key that contains the value to update
-- key: Key to be updated within the host_key object
-- value: New value to set (as a JSON string)
function M.JsonFileUpdateKey(file_path, host_key, key, value)
    -- Expand tilde to home directory if present
    if file_path:sub(1,1) == "~" then
        local home = os.getenv("HOME")
        file_path = home .. file_path:sub(2)
    end
    
    -- Use jq to handle the JSON manipulation
    -- This approach is robust for any JSON structure
    
    -- Parse the value string to ensure it's valid JSON
    local parsed_value = value
    
    -- Build the jq filter:
    -- 1. If the host_key doesn't exist, create it as an empty object
    -- 2. Set the specific key within the host_key to the provided value
    local jq_filter = string.format(
        'if .%s | type != "object" then . + {"%s": {}} else . end | .%s.%s = %s', 
        host_key, host_key, host_key, key, parsed_value
    )
    
    -- Create file with an empty JSON object if it doesn't exist
    local file = io.open(file_path, "r")
    if not file then
        file = io.open(file_path, "w")
        if file then
            file:write("{}")
            file:close()
        else
            error("Failed to create file: " .. file_path)
            return
        end
    else
        file:close()
    end
    
    -- Execute jq to update the JSON file
    local cmd = string.format('jq \'%s\' %s > %s.tmp && mv %s.tmp %s', 
        jq_filter, file_path, file_path, file_path, file_path)
    
    local result = os.execute(cmd)
    
    if not result then
        error("Failed to update JSON file: " .. file_path)
    end
end


-- Function to remove a key from a JSON file
-- file_path: Path to the JSON file
-- host_key: First-level object key that contains the key to remove
-- key: Key to be removed within the host_key object
function M.JsonFileRemoveKey(file_path, host_key, key)
    -- Expand tilde to home directory if present
    if file_path:sub(1,1) == "~" then
        local home = os.getenv("HOME")
        file_path = home .. file_path:sub(2)
    end
    
    -- Check if the file exists
    local file = io.open(file_path, "r")
    if not file then
        error("File does not exist: " .. file_path)
        return
    end
    file:close()
    
    -- Use jq to handle the JSON manipulation
    -- Build the jq filter:
    -- 1. Check if the host_key exists and is an object
    -- 2. If it exists, delete the specified key from it
    local jq_filter = string.format(
        'if .%s | type == "object" then .%s |= del(.%s) else . end', 
        host_key, host_key, key
    )
    
    -- Execute jq to update the JSON file
    local cmd = string.format('jq \'%s\' %s > %s.tmp && mv %s.tmp %s', 
        jq_filter, file_path, file_path, file_path, file_path)
    
    local result = os.execute(cmd)
    
    if not result then
        error("Failed to update JSON file: " .. file_path)
    end
end


-- require'tools_external'.JsonFileUpdateKey( '~/.config/claude-desktop/test.json', 'mcpServers', 'abc', '{ "ab": 123, "cd": [2, 3]}')
-- require'tools_external'.JsonFileRemoveKey( '~/.config/claude-desktop/test.json', 'mcpServers', 'abc' )


-- Function to read and pretty-print JSON file content
function M.get_json_content(file_path)
    -- Expand tilde to home directory if present
    if file_path:sub(1,1) == "~" then
        local home = os.getenv("HOME")
        file_path = home .. file_path:sub(2)
    end
    
    -- Use jq to format the JSON nicely
    local cmd = string.format('jq . %s', file_path)
    local handle = io.popen(cmd)
    if not handle then
        return {"Error: Could not read JSON file"}
    end
    
    local json_content = handle:read("*a")
    handle:close()
    
    return json_content
end


-- ─^  Json                                              ▲



-- ─   Pandoc                                           ──
-- from https://teukka.tech/posts/2020-01-07-vimloop/

-- lua require'tools_external'.pandocMarkdownToHtml()

function M.pandocMarkdownToHtml()
  local shortname = vim.fn.expand('%:t:r')
  local fullname = api.nvim_buf_get_name(0)
  handle = vim.loop.spawn('pandoc', {
    args = {
      fullname,
      '--to=html5',
      '-o', string.format('%s.html', shortname),
      '-s',
      '--highlight-style', 'tango',
      '-c', '--css=pandoc.css',
    },
  },
  function()
    print('DOCUMENT CONVERSION COMPLETE')
    handle:close()
  end
  )
end

-- ─   Grep                                             ──
local results = {}

local function onread(err, data)
  if err then
    print('ERROR: ', err)
    -- TODO handle err
  end
  if data then
    -- 3. The handler appends each item it receives (from the ripgrep process) to a list (a shared global var)
    table.insert(results, data)
  end
end

-- command! -nargs=+ -complete=dir -bar Grep lua require'tools'.asyncGrep(<q-args>)

-- Summary:
-- - i spawn a cmd-line process and pass file-out handles
-- - i read line-wise into a shared variable using 'read_start on the file-handle (using a read handler/callback)
-- - the cmd-process has an end-handler. it triggers a helper that uses the returned data in the shared-variable.
function M.asyncGrep(term)
  -- print('hi there')
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local function setQF()
    -- 5. This helper has access to the 'results' shared var.
--     6. Items are just lines.
    vim.fn.setqflist({}, 'r', {title = 'Search Results', lines = results})
    api.nvim_command('cwindow')
    local count = #results
    -- 7. Also, for the next search the *results* list/table needs to be cleared.
    for i=0, count do results[i]=nil end -- clear the table for the next search
  end
  handle = vim.loop.spawn('rg', {
    args = {term, '--vimgrep', '--smart-case'},
    stdio = {nil,stdout,stderr}
  },
  vim.schedule_wrap(function()
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    handle:close()
    -- 4. After the process is done and everything is closed another helper function is called.
    setQF()
  end
  )
  )
  -- 1. Ripgrep is writing into the stdout file descriptor
  -- 2. We attach a handler to the same stdout file descriptor
  vim.loop.read_start(stdout, onread)
  vim.loop.read_start(stderr, onread)
end


-- ─   Read file                                        ──

local a = require "plenary.async"

function M.read_file(path)
  local err, fd = a.uv.fs_open(path, "r", 438)
  assert(not err, err)

  local err, stat = a.uv.fs_fstat(fd)
  assert(not err, err)

  local err, data = a.uv.fs_read(fd, stat.size, 0)
  assert(not err, err)

  local err = a.uv.fs_close(fd)
  assert(not err, err)

  return( data )
end

-- print('hi from ext')

-- local mypath = '/Users/at/.config/nvim/rg-fzf-vim.sh'
-- a.run(function() put( M.read_file(mypath) ) end)

-- `read` is an async function
M.readFile = function(path)
  local err, fd = a.uv.fs_open(path, "r", 438)
  assert(not err, err)
end

-- ─   Curl                                             ──
-- https://github.com/nvim-lua/plenary.nvim/blob/master/tests/plenary/curl_spec.lua
local curl = require "plenary.curl"

M.curl = function(url, query)
  -- local query = { name = "john Doe", key = "123456" }
  -- local response = curl.get("https://postman-echo.com/get", {
  local response = curl.get( url, {
    query = query,
  })
  -- eq(200, response.status)
  -- eq(query, vim.fn.json_decode(response.body).args)
  -- print('done')
  return( vim.fn.json_decode(response.body) )
end

M.curlTestFile = function()
  local file = "https://media2.giphy.com/media/bEMcuOG3hXVnihvB7x/giphy.gif"
  local loc = "/tmp/giphy2.gif"
  local res = curl.get(file, { output = loc })
  -- eq(1, vim.fn.filereadable(loc), "should exists")
  -- eq(200, res.status, "should return 200")
  -- eq(0, res.exit, "should have exit code of 0")
  -- vim.fn.delete(loc)
end


-- ─   Popup                                            ──
-- vim.cmd [[highlight PopupColor1 ctermbg=lightblue guibg=lightblue]]
-- vim.cmd [[highlight PopupColor2 ctermbg=lightcyan guibg=lightcyan]]

local popup = require "popup"

M.popup = function( message )
  popup.create(message, {
    line = "cursor+2",
    col = "cursor+2",
    -- border = {},
    padding = { 0, 3, 0, 3 },
    border = { 0, 1, 0, 1 },
    -- borderchars = {'-'},
    pos = "botleft",
    time = 2000,
    -- padding = {},
    -- minwidth = 20,
    -- highlight = 'PopupColor1'
  })
end

M.popup2 = function()
  local bufnr = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {'pass bufnr 1', 'pass bufnr 2'})
  popup.create(bufnr, {
    line = "cursor+2",
    col = "cursor+2",
    minwidth = 20,
  })
end


M.popup1 = function()
  popup.create({ "option 3", "option 1", "option 2" }, {
    line = "cursor+1",
    col = "cursor+1",
    border = {},
    -- border = { 1, 1, 1, 1},
    enter = true,
    cursorline = true,
    callback = function(win_id, sel) vim.fn.confirm(sel) end,
  })
end


-- local a = require "plenary.async.control"
-- local bb = a.channel.counter

-- ─   Jobs                                             ──

M.job1 = function()
  local results = {}
  local job = Job:new {
    command = "cat",

    on_stdout = function(_, data)
      table.insert(results, data)
    end,
  }

  job:start()
  job:send "hello\n"
  job:send "world\n"
  job:shutdown()

  assert.are.same(job:result(), { "hello", "world" })
  assert.are.same(job:result(), results)
end




return M













