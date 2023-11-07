

-- local f = require "utils.functional"
local List = require 'plenary.collections.py_list'
local fun = require 'utils.fun'
-- require 'utils.fun'()
-- for k, v in pairs(require "utils.fun") do _G[k] = v end -- import fun.*


-- ─   Documentation luafun, plenary, vim.list/tbl      ──

-- vim.iter:
-- ~/apps_bin/nvim-macos_v0.10.0/share/nvim/runtime/doc/lua.txt‖/Luaˍmodule:ˍvim.iterˍ

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


local f = {}


function _G.uniqueVals1( acc, v )
  return vim.tbl_contains(acc, v)
    and acc
    or vim.list_extend(acc, {v})
end

-- vim.iter { {11}, {22}, {33}, {33}, {44}, {44} }
--  :fold( {}, uniqueVals1 )


-- vim.tbl_isempty( vim.tbl_filter( f.eq({11}), {{11}, {22}} ) )
-- vim.tbl_isempty( vim.tbl_filter( f.eq({12}), {{11}, {22}} ) )


-- vim.deep_equal(
-- {
--     bufid = 28,
--     fname = "/Users/at/.config/nvim/plugin/config/lualine_comps.lua"
--   },
-- {
--     bufid = 28,
--     fname = "/Users/at/.config/nvim/plugin/config/lualine_comps.lua"
--   }
-- )



-- vim.defer_fn( function() vim.print( "hi there" ) end, 2000 )
-- vim.system({'echo', 'hello'}, { text = true }):wait()


-- From https://github.com/cviejo/mPD/blob/main/bin/data/app/utils/functional.lua
-- local f = {}

f.noop = function()
end

-- not pretty, but fast. after receiving the first argument
-- performance is similar to non-curried form
f.curry2 = function(fn)
  local function handler(a, b)
  if a == nil then
      return handler
    elseif b ~= nil then
      return fn(a, b)
    else
      local function last(_b)
        if _b ~= nil then
          return fn(a, _b)
        else
          return last
        end
      end
      return last
    end
  end
  return handler
end

-- see curry2 comment
f.curry3 = function(fn)
  local function handler(a, b, c)
  if a == nil then -- no args
      return handler
    elseif b ~= nil and c ~= nil then -- all args
      return fn(a, b, c)
    elseif b == nil then -- one arg
      local function lastTwo(_b, _c)
      if _b ~= nil and _c ~= nil then
          return fn(a, _b, _c)
        elseif _b ~= nil then
          return handler(a, _b)
        else
          return lastTwo
        end
      end
      return lastTwo
    else -- two args
      local function last(_c)
        if _c ~= nil then
          return fn(a, b, _c)
        else
          return last
        end
      end
      return last
    end
  end
  return handler()
end

f.curry = function(fn)
  local nparams = debug.getinfo(fn).nparams

  if nparams == 2 then
    return f.curry2(fn)
  else
    return f.curry3(fn)
  end
end

f.negate = function(x)
  return not x
end

f.unapply = function(fn)
  return function(...)
    return fn({ ... })
  end
end


f.equals = f.curry2(function(a, b)
  return a == b
end)
-- f.equals 'hi' 'hi'

f.eq = f.curry2(function(a, b)
  return vim.deep_equal( a, b )
end)
-- f.eq {11} {11}
-- f.eq {11} {12}

function f.uniqueVals( acc, v )
  return vim.tbl_isempty( vim.tbl_filter( f.eq(v), acc ) )
    and vim.list_extend(acc, {v})
    or acc
end

-- vim.iter { {11}, {22}, {33}, {33}, {44}, {44} }
--  :fold( {}, f.uniqueVals )

function f.itToSet( it )
  return it:fold( {}, f.uniqueVals )
end
-- f.itToSet( vim.iter { {11}, {22}, {33}, {33}, {44}, {44} } )

f.isNil = function(x)
  return x == nil
end

f.unless = f.curry(function(cond, success, x)
  if (not cond(x)) then
    return success(x)
  end
  return x
end)

f.safe = function(fn)
  return function(x)
  if x == nil then
      return x
    else
      return fn(x)
    end
  end
end

f.includes = f.curry(function(x, xs)
  for i = 1, #xs do
  if xs[i] == x then
      return true
    end
  end
  return false
end)

f.intersects = function(a, b)
  for ia = 1, #a do
    for ib = 1, #b do
    if a[ia] == b[ib] then
        return true
      end
    end
  end

  return false
end

f.prop = f.curry(function(name, x)
if x then
    return x[name]
  end
end)

f.map = f.curry(function(fn, xs)
  local result = {}
  for i = 1, #xs do
    result[#result + 1] = fn(xs[i], i)
  end
  return result
end)

f.forEach = f.curry(function(fn, xs)
  for i = 1, #xs do
    fn(xs[i], i)
  end
end)

f.filter = f.curry(function(fn, xs)
  local result = {}
  for i = 1, #xs do
    local x = xs[i]
    if fn(x) then
      result[#result + 1] = x
    end
  end
  return result
end)
-- f.filter( function(e) return e>3 end, {1, 3} ) 
-- fun.range(1, 10)

f.reject = f.curry(function(fn, xs)
  return f.filter(function(x)
    return not fn(x)
  end, xs)
end)

f.forEachReverse = f.curry(function(fn, xs)
  for i = #xs, 1, -1 do
    fn(xs[i], i)
  end
end)

f.each = f.forEach

f.reduce = f.curry3(function(fn, init, xs)
  local acc = init
  for i = 1, #xs do
    acc = fn(acc, xs[i])
  end
  return acc
end)

-- avoid inlining / creating functions dynamically in potentially hot paths
-- in this case means declaring the reducer only once
f.pipe = function(...)
  local fns = { ... }
  local run = f.reduce(function(acc, fn)
    return fn(acc)
  end)
  return function(x)
    return run(x, fns)
  end
end

f.tryCatch = f.curry(function(tryer, catcher)
  print 'tryCatch is expensive, remove for production'

  return function(x)
    local error
    local success, result = xpcall(function()
      return tryer(x)
      end, function(err)
        error = err
    end)
    if not success then
      result = catcher(error, x)
    end
    return result
  end
end)

f.clamp = f.curry(function(min, max, x)
  if x > max then
    return max
  elseif x < min then
    return min
  else
    return x
  end
end)

f.pick = f.curry2(function(fields, obj)
  local result = {}
  f.forEach(function(field)
    local value = obj[field]
  if (value) then
      result[field] = value
    end
    end, fields)
  return result
end)

f.keys = function(x)
  local result = {}
  for key, _ in pairs(x) do
    result[#result + 1] = key
  end
  return result
end

-- not pure, but for convenience let's keep them here
f.assign = f.curry2(function(target, source)
  for key, value in pairs(source) do
    target[key] = value
  end
end)

f.push = function(x, xs)
  xs[#xs + 1] = x
end
-- not pure, but for convenience let's keep them here

-- f.merge = f.curry2(function(a, b)
--   local result = {}
--   f.assign(result, a)
--   f.assign(result, b)
--   return result
-- end)

f.merge = f.curry2(function(a, b)
  return vim.tbl_extend( 'keep', a, b )
end)

-- f.merge( {a=11}, {b=22} )


f.complement = function(fn)
  return function(...)
    return not fn(...)
  end
end

f.times = f.curry2(function(fn, n)
  local result = {}
  for i = 1, n do
    f.push(fn(i), result)
  end
  return result
end)


f.thunkify = function(fn)
  return function(...)
    local args = { ... }
    return function()
    return fn(unpack(args))
    end
  end
end

f.reverse = function(xs)
  local result = {}
  f.forEachReverse(function(x)
    result[#result + 1] = x
  end, xs)
  return result
end

f.find = f.curry2(function(fn, xs)
  for i = 1, #xs do
    local item = xs[i]
  if fn(item) then
      return item
    end
  end
end)

f.range = function( start, fin )
  return fun.range( start, fin ):totable()
end

-- f.find( function(x) return x>5 end )( {1, 2, 3, 4, 5, 6, 7} )
-- f.find( function(x) return x>5 end, {1, 2, 3, 4, 5, 6, 7} )
-- f.find( function(x) return x>5 end, fun.range( 3, 10 ):totable() )
-- f.find( function(x) return x>5 end, f.range( 3, 10 ) )
-- f.range( 3, 10 )

f.add = f.curry2(function(a, b)
  return a + b
end)
-- f.add( 31, 11 )

f.max = f.curry2(function(a, b)
  return a > b and a or b
end)
-- f.max( 11 )( 22 )


f.path = f.curry2(function(parts, x)
  local current = x
  for i = 1, #parts do
    current = current[ parts[i] ]
    if current == nil then
      return nil
    end
  end
  return current
end)
-- f.path({'a', 'b'}, {a = {b = 2}})

f.pathEq = f.curry3(function(parts, value, x)
  return f.path(parts, x) == value
end)

f.concat = f.curry2(function(a, b)
  local result = {}
  for i = 1, #a do
    result[#result + 1] = a[i]
  end
  for i = 1, #b do
    result[#result + 1] = b[i]
  end
  return result
end)
-- f.concat( {1, 2, 3} )( {10, 11} )
-- f.concat {1, 2, 3} {10, 11}


f.last = function( tbl )
  return tbl[ #tbl ]
end
-- f.last( vim.fn.split( [[^(#|function|m|f\.|local\sfunc|-- ─ |local.*curry).*someStr]], [[\*]] ) )


return f




