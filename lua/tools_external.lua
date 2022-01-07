
local M = {}
local loop = vim.loop
local api = vim.api

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


local results = {}

local function onread(err, data)
  if err then
    print('ERROR: ', err)
    -- TODO handle err
  end
  if data then
    table.insert(results, data)
  end
end

-- command! -nargs=+ -complete=dir -bar Grep lua require'tools'.asyncGrep(<q-args>)

function M.asyncGrep(term)
  print('hi there')
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local function setQF()
    vim.fn.setqflist({}, 'r', {title = 'Search Results', lines = results})
    api.nvim_command('cwindow')
    local count = #results
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
    setQF()
  end
  )
  )
  vim.loop.read_start(stdout, onread)
  vim.loop.read_start(stderr, onread)
end


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

print('hi from ext')

local mypath = '/Users/at/.config/nvim/rg-fzf-vim.sh'
-- a.run(function() put( M.read_file(mypath) ) end)

-- `read` is an async function
M.readFile = function(path)
  local err, fd = a.uv.fs_open(path, "r", 438)
  assert(not err, err)
end

a.run(function() M.readFile("mypath") end)

return M













