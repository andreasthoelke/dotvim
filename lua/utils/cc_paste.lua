-- Cleanup utility for text copied from Claude Code terminal output
-- Fixes: hard-wrapped lines, leading indentation, trailing whitespace

local M = {}

-- Remove trailing whitespace from each line
local function stripTrailing(text)
  local lines = vim.split(text, '\n')
  local result = {}
  for _, line in ipairs(lines) do
    table.insert(result, (line:gsub('%s+$', '')))
  end
  return table.concat(result, '\n')
end

-- Remove CC terminal indentation
-- Prompt line (⏺ at start): 1 space, content lines: 2 spaces
local function dedent(text)
  local lines = vim.split(text, '\n')
  local result = {}
  for _, line in ipairs(lines) do
    if line:match('^%s*⏺') then
      table.insert(result, (line:gsub('^ ', '')))
    else
      table.insert(result, (line:gsub('^  ', '')))
    end
  end
  return table.concat(result, '\n')
end

-- Check if line looks like code
local function looksLikeCode(line)
  if not line or line == '' then return false end
  -- Common code patterns
  if line:match('^%s*local%s') then return true end
  if line:match('^%s*return%s') then return true end
  if line:match('^%s*function%s') then return true end
  if line:match('^%s*if%s') then return true end
  if line:match('^%s*for%s') then return true end
  if line:match('^%s*while%s') then return true end
  if line:match('^%s*end%s*$') then return true end
  if line:match('^%s*require%s*%(') then return true end
  if line:match('^%s*vim%.') then return true end
  if line:match('^%s*[%w_]+%s*=%s*') then return true end
  if line:match('[;{}]%s*$') then return true end
  if line:match('^%s*[%w_]+%([^)]*%)%s*$') then return true end
  return false
end

-- Join soft-wrapped lines (heuristic-based)
local function joinSoftWraps(text)
  local lines = vim.split(text, '\n')
  if #lines <= 1 then return text end

  local result = {}
  local inCodeBlock = false

  for _, line in ipairs(lines) do
    -- Track code fence state (allow leading whitespace)
    if line:match('^%s*```') then
      inCodeBlock = not inCodeBlock
      table.insert(result, line)
    elseif inCodeBlock then
      -- Inside code block: never join, preserve as-is
      table.insert(result, line)
    elseif looksLikeCode(line) then
      -- Line looks like code: don't join
      table.insert(result, line)
    else
      -- Outside code block: check if we should join with previous line
      local prev = result[#result]
      local shouldJoin = prev
        and prev ~= ''
        and line ~= ''
        and not looksLikeCode(prev)
        and not prev:match('[.!?:;]%s*$')
        and not line:match('^%s*[-*+]%s')
        and not line:match('^%s*%d+[.)]%s')
        and not line:match('^#')

      if shouldJoin then
        result[#result] = prev .. ' ' .. line:gsub('^%s+', '')
      else
        table.insert(result, line)
      end
    end
  end

  return table.concat(result, '\n')
end

-- Full cleanup pipeline
function M.cleanup(text)
  text = stripTrailing(text)
  text = dedent(text)
  text = joinSoftWraps(text)
  return text
end

-- Cleanup register contents and paste
function M.pasteClean(register)
  register = register or '+'
  local text = vim.fn.getreg(register)
  -- print(text)
  local cleaned = M.cleanup(text)
  vim.api.nvim_put(vim.split(cleaned, '\n'), 'c', true, true)
end

-- Setup keymapping
function M.setup(opts)
  opts = opts or {}
  local key = opts.key or '<leader>P'
  vim.keymap.set('n', key, function()
    M.pasteClean()
  end, { desc = 'Paste cleaned CC output' })
end

return M
