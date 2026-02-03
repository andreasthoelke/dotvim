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

-- Remove common leading whitespace from all lines
local function dedent(text)
  local lines = vim.split(text, '\n')
  if #lines == 0 then return text end

  -- Find minimum indentation (ignoring empty lines)
  local minIndent = math.huge
  for _, line in ipairs(lines) do
    if line:match('%S') then
      local indent = #(line:match('^%s*') or '')
      minIndent = math.min(minIndent, indent)
    end
  end

  if minIndent == math.huge or minIndent == 0 then
    return text
  end

  -- Remove common indentation
  local result = {}
  for _, line in ipairs(lines) do
    if line:match('%S') then
      table.insert(result, line:sub(minIndent + 1))
    else
      table.insert(result, '')
    end
  end

  return table.concat(result, '\n')
end

-- Join soft-wrapped lines (heuristic-based)
local function joinSoftWraps(text)
  local lines = vim.split(text, '\n')
  if #lines <= 1 then return text end

  local result = {}
  local i = 1

  while i <= #lines do
    local line = lines[i]

    while i < #lines do
      local nextLine = lines[i + 1]

      -- Keep separate if any break condition matches
      if line == '' or nextLine == '' then break end
      if line:match('[.!?:;]%s*$') then break end
      if line:match('```') or nextLine:match('^```') then break end
      if nextLine:match('^%s*[-*+]%s') then break end
      if nextLine:match('^%s*%d+[.)]%s') then break end
      if nextLine:match('^#') then break end
      if nextLine:match('^%s%s+%S') then break end

      -- Join lines
      line = line .. ' ' .. nextLine:gsub('^%s+', '')
      i = i + 1
    end

    table.insert(result, line)
    i = i + 1
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
