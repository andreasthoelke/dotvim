
local M = {}
local loop = vim.loop
local api = vim.api

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

M.curlTest = function(query)
  -- local query = { name = "john Doe", key = "123456" }
  local response = curl.get("https://postman-echo.com/get", {
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













