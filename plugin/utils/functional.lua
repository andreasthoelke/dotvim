
local List = require 'plenary.collections.py_list'
local fun = require 'utils.fun'
-- require 'utils.fun'()
for k, v in pairs(require "utils.fun") do _G[k] = v end -- import fun.*


-- ─   Documentation luafun, plenary, vim.list/tbl      ──

-- -- luafun:
-- ~/.config/nvim/lua/utils/fun.lua
-- https://luafun.github.io/
-- https://github.com/luafun/luafun/tree/master/tests

-- plenary:
-- ~/.config/nvim/plugged/plenary.nvim/lua/plenary/collections/py_list.lua‖
-- ~/.config/nvim/plugged/plenary.nvim/tests/plenary/py_list_spec.lua‖

-- vim.tbl/list:
-- /opt/homebrew/Cellar/neovim/0.9.0/share/nvim/runtime/doc/‖
-- /opt/homebrew/Cellar/neovim/0.9.0/share/nvim/runtime/doc/lua.txt‖/Filterˍaˍta
-- /opt/homebrew/Cellar/neovim/0.9.0/share/nvim/runtime/doc/lua.txt‖/Createsˍaˍcopyˍofˍaˍt


function _G.Func1()
  local myList = List { 9, 14, 32, 5 }
  return myList:is_list()
end

-- Func1()


-- vim.api.nvim_echo( { { "hi"}, {"ab"} }, false, {} )

function _G.Func2()
  -- local hist = List( require( 'notify' ).history() )
  local hist = require 'notify'.history()
  -- return hist
  -- return vim.tbl_map( function(el) return table.concat( el.message, "\n" ) end , hist )
  return vim.tbl_flatten( vim.tbl_map( function(el) return el.message end , hist ) )
end

-- vim.tbl_flatten( Func2() )

-- lua vim.fn.FloatingSmallNew( Func2() )
-- require 'notify'._print_history()

-- local filteredList = myList:filter(function(value)
--   return value > 10
-- end)

-- putt( filteredList )

-- ~/.config/nvim/plugged/nvim-navic/lua/nvim-navic/init.lua‖/M.format_data(data,ˍopts)
-- lua vim.print( require('nvim-navic').get_location() )
-- lua putt( require('nvim-navic').get_data() )

-- local ab = { { -- ■
--   icon = " ",
--   kind = 4,
--   name = "tradex.domain",
--   scope = {
--     ["end"] = {
--       character = 5,
--       line = 53
--     },
--     start = {
--       character = 0,
--       line = 1
--     }
--   },
--   type = "Package"
-- }, {
--     icon = " ",
--     kind = 4,
--     name = "api",
--     scope = {
--       ["end"] = {
--         character = 5,
--         line = 53
--       },
--       start = {
--         character = 0,
--         line = 2
--       }
--     },
--     type = "Package"
--   }, {
--     icon = " ",
--     kind = 4,
--     name = "common",
--     scope = {
--       ["end"] = {
--         character = 5,
--         line = 53
--       },
--       start = {
--         character = 0,
--         line = 3
--       }
--     },
--     type = "Package"
--   }, {
--     icon = "󰌗 ",
--     kind = 5,
--     name = "CustomDecodeFailureHandler",
--     scope = {
--       ["end"] = {
--         character = 3,
--         line = 44
--       },
--       start = {
--         character = 0,
--         line = 18
--       }
--     },
--     type = "Class"
--   }, {
--     icon = "󰆧 ",
--     kind = 6,
--     name = "apply",
--     scope = {
--       ["end"] = {
--         character = 3,
--         line = 31
--       },
--       start = {
--         character = 2,
--         line = 24
--       }
--     },
--     type = "Method"
--   } }

 -- ▲
function _G.abb()
  -- return vim.list_slice( ab, 0, 1 )
  -- return take_while( function( el ) return el.type == "Package" end, ab )
  return take_while( function( el ) return el.type == "Package" end, ab ):length()
  -- local idx, els = take_while( function( idx, el ) return el.type == "Package" end, enumerate( ab ) )
  -- return els
  -- return take_until( function( el ) return el.a > 2 end, {{a=3}, {a=2}, {a=2}} )
  -- return take_while( function( el ) return true end, range(4) )
end

-- abb()

-- totable( take_while( function(el) return el.xx ~= 'c' end, { {xx='a'}, {xx='b'}, {xx='c'}, {xx='d'} } ) )
-- take_while( function(el) return el.xx ~= 'c' end, { {xx='a'}, {xx='b'}, {xx='c'}, {xx='d'} } ) 


function _G.Test2()
  local a, b = table.unpack( vim.fn.split( 'eins.lua', '\\.' ) )
  return b .. a
end

-- Test2()

-- local array = {1, 2, 3, 4}
-- local a, b, c, d = table.unpack(arr)

-- require("nvim-web-devicons").get_icon_by_filetype( 'scala', {})




-- local function map(sequence, transformation)
--   local newlist = { }
--   for i, v in pairs(sequence) do
--     newlist[i] = transformation( v )
--   end
--   return newlist
-- end

--example usages:
--map every player to their team
-- map (game.Players:GetPlayers(), function(player) return player.Team end)
--map a list of numbers to their square

--pair together parts with their color
-- map (workspace.Model:GetChildren(), function(part) return {part, part.BrickColor} end)


-- local function filter(sequence, predicate)
--   local newlist = { }
--   for i, v in ipairs(sequence) do
--     if predicate(v) then
--       table.insert(newlist, v)
--     end
--   end
--   return newlist
-- end

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
  -- local res = ('foo111bar222'):gmatch('([^0-9]*)(d*)')
  return res
end

-- Func3()

-- vim table map
-- vim.list_slice


-- vim.print( vim.gsplit(':aa::b:', ':', {plain=true}) )

-- /opt/homebrew/Cellar/neovim/0.9.0/share/nvim/runtime/doc/lua.txt‖/gsplit({s},

-- vim.tbl_count({ a=1, b=2 })  --> 2

-- vim.tbl_filter(function(v) return v>3 end, { 3, 4, 5 }) 

-- vim.tbl_get({ key = { nested_key = true }}, 'key', 'nested_key')
-- vim.tbl_get( range(3), 'key')
-- vim.tbl_get( range(4), 'param')
-- vim.tbl_get({ key = { nested_key = { nestmore = 33 } }}, 'key', 'nested_key')
-- vim.tbl_get({ key = { nested_key = { nestmore = 33 } }}, 'key', 'nested_key', 'nestmore')

function _G.Func4()
  vim.ui.select({ 'tabs', 'spaces' }, {
    prompt = 'Select tabs or spaces:',
    format_item = function(item)
      return "I'd like to choose " .. item
    end,
  }, function(choice)
      if choice == 'spaces' then
        -- vim.o.expandtab = true
      else
        -- vim.o.expandtab = false
      end
    end)
end

-- Func4()

function _G.Func5()
  fun.each( print, fun.filter(function(x) return x % 3 == 0 end, fun.range(10)) )
  vim.print( fun.filter(function(x) return x % 3 == 0 end, fun.range(10)) )
end

-- Func5()


-- each( print, range(5) )

-- range(4)

-- foldl( function( acc, el ) return acc .. el end, "", range(4) )

-- vim.regex('ab'):match_str( 'zxabcd' )
-- vim.regex('ab'):match_str( 'z_xabcd' )

-- vim.defer_fn( function() vim.print( "hi there" ) end, 2000 )

function _G.Test1()
  return
  vim.iter({ 1, 2, 3, 4, 5 })
    :rev()
    :totable()
end
-- Test1()

function _G.Test3()
  local aa =
  vim.iter({ 1, 2, 3, 4, 5 })
    :rev()
    :totable()
  return aa
end
-- Test3()


-- vim.iter({ 1, 2, 4, 4, 5 })
--   :rev()
--   :totable()

vim.iter({ 2, 2, 4, 4, 5 })
  :rev()
  :totable()







