
local function receive (prod)
  local _, value = coroutine.resume(prod)
  return value
end

local function send (x)
  coroutine.yield(x)
end

-- 1. This producer is an async-step (suspendable) process (a coroutine)
-- 2. It reads from IO and then yields, i.e. it sends to the parent/host process (that 'resumes' it).
local function producer ()
  return coroutine.create(function ()
    while true do
      local x = io.read()     -- produce new value
      send(x)
    end
  end)
end

-- 3. Filter is also a suspendable step process. It's a parent/host process because it holds a reference to Producer.
-- 4. 'receive' just means the producer-coroutine will be re-started and the produced/sent value received
--    so this actually 'awaits' the async value.
local function filter (prod)
  return coroutine.create(function ()
    local line = 1
    while true do
      local x = receive(prod)   -- get new value
      x = string.format("%5d %s", line, x)
      send(x)      -- send it to consumer
      line = line + 1
    end
  end)
end

-- 5. A host process that pulls/resumes values from a child process
local function consumer (prod)
  while true do
    local x = receive(prod)   -- get new value
    io.write(x, "\n")          -- consume new value
  end
end

local p = producer()
local f = filter(p)
consumer(f)


