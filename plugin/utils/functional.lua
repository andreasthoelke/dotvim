local List = require 'plenary.collections.py_list'
local fun = require 'utils.fun'

function _G.Func1()
  local myList = List { 9, 14, 32, 5 }
  return myList:is_list()
end

-- Func1()

function _G.Func2()
  local hist = List( require( 'notify' ).history() )
  return hist
end

-- Func2()


-- local filteredList = myList:filter(function(value)
--   return value > 10
-- end)

-- putt( filteredList )

-- ~/.config/nvim/plugged/nvim-navic/lua/nvim-navic/init.lua‖/M.format_data(data,ˍopts)


local function map(sequence, transformation)
  local newlist = { }
  for i, v in pairs(sequence) do
    newlist[i] = transformation( v )
  end
  return newlist
end

--example usages:
--map every player to their team
-- map (game.Players:GetPlayers(), function(player) return player.Team end)
--map a list of numbers to their square

--pair together parts with their color
-- map (workspace.Model:GetChildren(), function(part) return {part, part.BrickColor} end)


local function filter(sequence, predicate)
  local newlist = { }
  for i, v in ipairs(sequence) do
    if predicate(v) then
      table.insert(newlist, v)
    end
  end
  return newlist
end

--Example use cases:
--Get all the players who are on teams Red and Blue
--filter(
--  game.Players:GetPlayers(),
--  function(player) return player.Team == RED or player.Team == BLUE end
--)
----Get all players who are spawned
--filter(game.Players:GetPlayers(), function(player) return player.Character ~= nil end)
----Get all the green parts in Workspace
--filter(workspace:GetDescendants(), function(part) return part:IsA("BasePart") and part.BrickColor = GREEN end)
----Get all the odd numbers in the list
--filter({1,2,3,4,5,6,7,8}, function(x) return x%2==1 end)

function _G.Func3()
  -- return map ({1,2,3,4,5,6,7,8}, function(x) return x^2 end)
  -- return filter({1,2,3,4,5,6,7,8}, function(x) return x%2==1 end)
  -- return fun.rands(4, 10)
  local a = vim.defaulttable()
  a.b.c = 1
  -- return a
  -- local res = vim.endswith( 'abc', 'bc' )
  local res = vim.gsplit("ab|cd", "|", {plain=true})
  -- for s in res do put( s ) end
  -- put( iteratorToSting( res ) )
  return res
end

-- Func3()

-- vim table map
-- vim.list_slice

-- documentation!
-- ~/.config/nvim/lua/utils/fun.lua‖
-- ~/.config/nvim/plugged/plenary.nvim/lua/plenary/collections/py_list.lua‖
-- ~/.config/nvim/plugged/plenary.nvim/tests/plenary/py_list_spec.lua‖

-- vim.print( vim.gsplit(':aa::b:', ':', {plain=true}) )

-- /opt/homebrew/Cellar/neovim/0.9.0/share/nvim/runtime/doc/lua.txt‖/gsplit({s},



