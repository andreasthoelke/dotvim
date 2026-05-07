local M = {
  name = 'mdx',
}

local utils = require('outline.utils')

local function trim(value)
  return value:gsub('^%s*(.-)%s*$', '%1')
end

local function make_symbol(kind, name, line, character)
  return {
    kind = kind,
    name = name,
    selectionRange = {
      start = { character = character, line = line },
      ['end'] = { character = character, line = line },
    },
    range = {
      start = { character = character, line = line },
      ['end'] = { character = character, line = line },
    },
    children = {},
  }
end

function M.supports_buffer(bufnr, config)
  local ft = utils.buf_get_option(bufnr, 'ft')
  if config and config.filetypes then
    for _, ft_check in ipairs(config.filetypes) do
      if ft_check == ft then
        return true
      end
    end
  end

  return ft == 'markdown.mdx' or ft == 'mdx'
end

function M.handle_mdx()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local root = { children = {} }
  local heading_stack = { root }
  local tag_stack = {}
  local is_inside_code_block = false

  for line, value in ipairs(lines) do
    if value:find('^```') then
      is_inside_code_block = not is_inside_code_block
    end
    if is_inside_code_block then
      goto nextline
    end

    local line_index = line - 1
    local next_value = lines[line + 1]
    local is_empty_line = #trim(value) == 0
    local header, title = value:match('^(#+)%s+(.+)$')

    if not header and next_value and not is_empty_line then
      if next_value:match('^=+%s*$') then
        header = '#'
        title = value
      elseif next_value:match('^-+%s*$') then
        header = '##'
        title = value
      end
    end

    if header and title then
      local depth = #header + 1

      for i = depth, #heading_stack do
        if heading_stack[i] then
          heading_stack[i].selectionRange['end'].line = math.max(line_index - 1, heading_stack[i].selectionRange.start.line)
          heading_stack[i].range['end'].line = math.max(line_index - 1, heading_stack[i].range.start.line)
          heading_stack[i] = nil
        end
      end

      local parent = heading_stack[depth - 1] or root
      local entry = make_symbol('String', trim(title), line_index, 0)
      table.insert(parent.children, entry)
      heading_stack[depth] = entry
    end

    local close_tag = value:match('^%s*</([%a][%w_.:-]*)%s*>')
    if close_tag then
      for i = #tag_stack, 1, -1 do
        local entry = tag_stack[i]
        entry.selectionRange['end'].line = line_index
        entry.range['end'].line = line_index
        table.remove(tag_stack, i)

        if entry.name == '<' .. close_tag .. '>' then
          break
        end
      end
      goto nextline
    end

    local indent, open_tag = value:match('^(%s*)<([%a][%w_.:-]*)%f[%s/>]')
    if not open_tag then
      indent, open_tag = value:match('^(%s*)<([%a][%w_.:-]*)%s*$')
    end
    if open_tag then
      local current_heading = heading_stack[#heading_stack] or root
      local parent = tag_stack[#tag_stack] or current_heading
      local entry = make_symbol('Component', '<' .. open_tag .. '>', line_index, #indent)

      table.insert(parent.children, entry)

      if value:find('/>%s*$') then
        entry.selectionRange['end'].line = line_index
        entry.range['end'].line = line_index
      else
        table.insert(tag_stack, entry)
      end
    end

    ::nextline::
  end

  for _, entry in ipairs(tag_stack) do
    entry.selectionRange['end'].line = #lines
    entry.range['end'].line = #lines
  end

  for i = 2, #heading_stack do
    if heading_stack[i] then
      heading_stack[i].selectionRange['end'].line = #lines
      heading_stack[i].range['end'].line = #lines
    end
  end

  return root.children
end

function M.request_symbols(on_symbols, opts)
  on_symbols(M.handle_mdx(), opts)
end

return M
