local M = {}

local Job = require "plenary.job"

vim.g.ws_received = {}

-- 'websocat -t ws-l:127.0.0.1:1240 broadcast:mirror:'


vim.g.broadcast_server = Job:new {
  command = 'websocat',
  args = { '-t', 'ws-l:127.0.0.1:1240', 'broadcast:mirror:' },

  on_stdout = function(_, data)
    -- print( 'ws server: ' .. data )
    -- print( 'ws server: ' .. vim.inspect.inspect( data ) )
    put( 'ws server: ', data )
  end,
}

vim.g.ws_client = Job:new {
  command = 'websocat',
  args = { 'ws://127.0.0.1:1240' },

  on_stdout = function(_, data)
    table.insert( vim.g.ws_received, data )
    -- table.insert( vim.g.ws_received, vim.fn.json_decode( data ) )
    -- print( 'ws: ' .. data )
    put( 'ws: ', data )
  end,
}

function M.start()
  -- broadcast_server:and_then( ws_client )
  -- broadcast_server:sync()
  -- ws_client:wait()
  broadcast_server:start()
  ws_client:start()
  print( 'ws: ready' )
end

function M.stop()
  broadcast_server:shutdown()
  ws_client:shutdown()
  print( 'ws: shutdown' )
end

function M.post( data )
  -- ws_client:send( data )
  ws_client:send( vim.fn.json_encode( data ) .. '\n' )
end


return M


