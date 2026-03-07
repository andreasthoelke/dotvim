-- Clipboard debugging utilities
-- Logs yank/paste events to /tmp/nvim_clipboard.log and provides diagnostics

local M = {}

local log_file = '/tmp/nvim_clipboard.log'
local max_content_len = 120

local function timestamp()
  return os.date('%H:%M:%S') .. '.' .. string.format('%03d', (vim.uv or vim.loop).hrtime() / 1e6 % 1000)
end

local function log(msg)
  local f = io.open(log_file, 'a')
  if f then
    f:write(string.format('[%s] %s\n', timestamp(), msg))
    f:close()
  end
end

local function truncate(s)
  if not s then return '<nil>' end
  s = s:gsub('\n', '\\n')
  if #s > max_content_len then
    return s:sub(1, max_content_len) .. '...(+' .. (#s - max_content_len) .. ')'
  end
  return s
end

local function pbpaste_raw()
  local handle = io.popen('pbpaste')
  if not handle then return nil end
  local content = handle:read('*a')
  handle:close()
  return content
end

function M.setup()
  -- Log every yank
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('ClipboardDebug', { clear = true }),
    callback = function()
      local event = vim.v.event
      local reg = event.regname == '' and '"' or event.regname
      local regtype = event.regtype
      local content = table.concat(event.regcontents or {}, '\n')
      log(string.format('YANK reg=%s type=%s len=%d content=%q', reg, regtype, #content, truncate(content)))

      -- For unnamed/unnamedplus yanks, verify pbpaste agrees
      if reg == '"' or reg == '*' or reg == '+' then
        vim.defer_fn(function()
          local pb = pbpaste_raw()
          if pb and pb ~= content and pb ~= content .. '\n' then
            log(string.format('MISMATCH pbpaste=%q nvim_reg=%q', truncate(pb), truncate(content)))
          else
            log('pbpaste OK')
          end
        end, 50)
      end
    end,
  })

  log('--- clipboard_debug loaded (pid=' .. vim.fn.getpid() .. ') clipboard=' .. vim.o.clipboard .. ' ---')
end

-- Diagnostic: compare nvim's * register with raw pbpaste
function M.check()
  local nvim_star = vim.fn.getreg('*')
  local nvim_plus = vim.fn.getreg('+')
  local nvim_unnamed = vim.fn.getreg('"')
  local pb = pbpaste_raw() or ''

  local lines = {
    'clipboard option : ' .. vim.o.clipboard,
    'nvim  * register : ' .. truncate(nvim_star),
    'nvim  + register : ' .. truncate(nvim_plus),
    'nvim  " register : ' .. truncate(nvim_unnamed),
    'pbpaste output   : ' .. truncate(pb),
    '',
    '* matches pbpaste: ' .. tostring(nvim_star == pb or nvim_star == pb:gsub('\n$', '')),
    '"" matches pbpaste: ' .. tostring(nvim_unnamed == pb or nvim_unnamed == pb:gsub('\n$', '')),
    '',
    'Log file: ' .. log_file,
  }

  vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO, { title = 'Clipboard Debug' })
end

-- Force-sync: read pbpaste and put it into nvim's unnamed+star+plus registers
function M.sync()
  local pb = pbpaste_raw()
  if not pb or pb == '' then
    vim.notify('pbpaste returned empty - clipboard may be empty or pbpaste failed', vim.log.levels.WARN)
    log('SYNC failed - pbpaste empty')
    return
  end
  -- strip trailing newline that pbpaste adds
  local content = pb:gsub('\n$', '')
  vim.fn.setreg('*', content)
  vim.fn.setreg('+', content)
  vim.fn.setreg('"', content)
  log('SYNC forced content from pbpaste: ' .. truncate(content))
  vim.notify('Clipboard synced: ' .. truncate(content), vim.log.levels.INFO)
end

return M
