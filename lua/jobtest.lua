local Job = require "plenary.job"

local job1 = function()
  local results = {}

  -- A Job has
  -- - a command to run
  -- - a callback to receive the stdout data.
  -- - the callback will just append to a result variable
  -- In this case it writes to a variable in the
  local job = Job:new {
    command = "cat",

    on_stdout = function(_, data)
      table.insert(results, data)
    end,
  }

  job:start()
  job:send "hello\n"
  job:send "\n"
  job:send "world\n"
  job:send "\n"
  job:shutdown()
  -- job:sync()

  -- put( results )
  -- put( job:result() )
  return results

  -- assert.are.same(job:result(), { "hello", "world" })
  -- assert.are.same(job:result(), results)
end

local job2 = function()
  local results = {}

  local job = Job:new {
    command = "env",
    env = { "A=100", "B=test" },
    on_stdout = function(_, data)
      table.insert(results, data)
    end,
  }

  job:sync()
  return job:result()
end

local job3 = function()
  local ls_results = vim.fn.systemlist "ls -l"

  local job = Job:new {
    command = "ls",
    args = { "-l" },
  }

  job:sync()
  return job:result()
end

local job4 = function()
  local results = vim.fn.systemlist "fd job"
  local stdout_results = {}

  local job = Job:new {
    command = "fd job",

    on_stdout = function(_, line)
      table.insert(stdout_results, line)
    end,
  }

  job:sync()
  return job:result()
end

-- This can search for a string with FD and FZF!
local job5 = function()
  local stdout_results = {}

  local fzf = Job:new {
    writer = Job:new {
      command = "fd",
      cwd = vim.fn.expand "~/.config/nvim/plugged/plenary.nvim/",
    },

    command = "fzf",
    -- args = { "--filter", "job.lua" },
    args = { "--filter", "util" },

    cwd = vim.fn.expand "~/.config/nvim/plugged/plenary.nvim/",

    on_stdout = function(_, line)
      table.insert(stdout_results, line)
    end,
  }


  fzf:sync()
  return fzf:result()
end


local job6 = function()
  local rg = Job:new({
    command = 'rg',
    args = { '--files' },
    cwd = '~/Documents/Temp/py',
    -- env = { ['a'] = 'b' },
    on_exit = function(j, return_val)
      -- print(return_val)
      -- print(j:result())
    end,
  })
  rg:sync()
  return rg:result()
end


-- local Job = require'plenary.job'
-- Job:new({
--   command = 'rg',
--   args = { '--files' },
--   cwd = '/usr/bin',
--   env = { ['a'] = 'b' },
--   on_exit = function(j, return_val)
--     print(return_val)
--     print(j:result())
--   end,
-- }):sync() -- or start()

-- put( job6() )


-- put( vim.fn.systemlist "fd job" )

for _, e in ipairs( job1() ) do
  print( 'hey 11 ' .. e )
end

for _, e in ipairs( job6() ) do
  print( e )
end








