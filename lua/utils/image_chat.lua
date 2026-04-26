-- Image-gen chat buffer: parrot-inspired markdown layout, but for OpenAI image gen.
--
-- Buffer layout (matches parrot's chat conventions):
--   # topic: <summary or "?">
--   ---
--   ☼:
--   <user prompt>
--
--   ⌘:[<model>:<quality>@<size>]
--   ![alt](/path/to/img.jpg)
--   ## response_id
--   resp_...
--   ## revised
--   <revised prompt>
--
--   ☼:
--   <next prompt>
--
-- Submission is parsed from the last `☼:` block; response_id for iteration is
-- the most recent `## response_id` value above that block.

local image_gen = require("utils.image_gen")

local M = {}

local CHAT_DIR = vim.fn.expand("~/.local/share/nvim/parrot/img-chats")
local INPUT_MARKER = "☼:"
local OUTPUT_MARKER_PREFIX = "⌘:["

-- API_MODEL is what the shell script sends to OpenAI (defaults to gpt-5.5
-- via OPENAI_MODEL env). DISPLAY_MODEL is the user-facing name shown in the
-- buffer marker and winbar.
local DISPLAY_MODEL = "image-2"
local FORMAT = "jpeg"

-- Tracks an in-flight request so the winbar label can show an elapsed counter.
local pending_start = nil

local PRESETS = {
  { quality = "auto",   size = "1024x1024" },
  { quality = "low",    size = "1024x1024" },
  { quality = "medium", size = "1024x1024" },
  { quality = "high",   size = "1024x1024" },
  { quality = "auto",   size = "auto" },
  { quality = "low",    size = "auto" },
  { quality = "medium", size = "auto" },
  { quality = "high",   size = "auto" },
}
local current_preset_index = 1

local function refresh_winbar()
  vim.schedule(function()
    local ok, lualine = pcall(require, "lualine")
    if ok and type(lualine.refresh) == "function" then
      pcall(lualine.refresh, { place = { "winbar" } })
    end
  end)
end

local function preset_label(p)
  return string.format("%s:%s@%s", DISPLAY_MODEL, p.quality, p.size)
end

function M.current_preset()
  return PRESETS[current_preset_index]
end

function M.current_preset_label()
  local label = preset_label(M.current_preset())
  if pending_start then
    local elapsed = math.floor(vim.uv.hrtime() / 1e9 - pending_start)
    return string.format("%s ... %ds", label, elapsed)
  end
  return label
end

function M.next_preset()
  current_preset_index = current_preset_index + 1
  if current_preset_index > #PRESETS then current_preset_index = 1 end
  vim.notify("image-gen preset: " .. M.current_preset_label(), vim.log.levels.INFO)
  refresh_winbar()
end

function M.prev_preset()
  current_preset_index = current_preset_index - 1
  if current_preset_index < 1 then current_preset_index = #PRESETS end
  vim.notify("image-gen preset: " .. M.current_preset_label(), vim.log.levels.INFO)
  refresh_winbar()
end

local function ensure_chat_dir()
  if vim.fn.isdirectory(CHAT_DIR) == 0 then
    vim.fn.mkdir(CHAT_DIR, "p")
  end
end

local function random_id(n)
  local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
  local out = {}
  math.randomseed(os.time() + os.clock() * 1000000)
  for _ = 1, n do
    local i = math.random(1, #chars)
    out[#out + 1] = chars:sub(i, i)
  end
  return table.concat(out)
end

local function new_chat_path()
  ensure_chat_dir()
  local date = os.date("%Y-%m-%d")
  for _ = 1, 10 do
    local path = string.format("%s/%s.%s.md", CHAT_DIR, date, random_id(4))
    if vim.fn.filereadable(path) == 0 then
      return path
    end
  end
  return string.format("%s/%s.%s.md", CHAT_DIR, date, random_id(8))
end

-- Returns the line index (1-based) of the last `☼:` line, or nil.
local function find_last_input_marker(lines)
  for i = #lines, 1, -1 do
    if lines[i]:match("^%s*" .. INPUT_MARKER .. "%s*$") then
      return i
    end
  end
  return nil
end

-- Returns the response_id from the most recent `## response_id` heading at or
-- before line `up_to`, or nil. The id is the next non-empty line after the
-- heading.
local function find_previous_response_id(lines, up_to)
  for i = up_to, 1, -1 do
    if lines[i]:match("^##%s+response_id%s*$") then
      for j = i + 1, math.min(#lines, i + 4) do
        local t = vim.trim(lines[j])
        if t ~= "" then return t end
      end
    end
  end
  return nil
end

-- Pull the user prompt: lines after the last `☼:`, up to end of buffer.
-- Strips trailing empty lines.
local function read_pending_prompt(lines, marker_line)
  local out = {}
  for i = marker_line + 1, #lines do
    table.insert(out, lines[i])
  end
  while #out > 0 and out[#out]:match("^%s*$") do
    table.remove(out)
  end
  return vim.trim(table.concat(out, "\n"))
end

-- Update the `# topic:` line (first line) if it's still the placeholder "?".
local function maybe_update_topic(bufnr, prompt)
  local first = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
  if not first:match("^#%s*topic:%s*%??%s*$") then
    return
  end
  local short = prompt:gsub("%s+", " "):sub(1, 60)
  if #prompt > 60 then short = short .. "..." end
  vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { "# topic: " .. short })
end

-- Build the new buffer skeleton.
local function initial_skeleton()
  return {
    "# topic: ?",
    "",
    "---",
    INPUT_MARKER,
    "",
  }
end

-- Open a new image chat buffer. layout = "vsplit" | "split" | nil (current win).
function M.new(layout)
  local path = new_chat_path()
  if layout == "vsplit" then
    vim.cmd("vsplit " .. vim.fn.fnameescape(path))
  elseif layout == "split" then
    vim.cmd("split " .. vim.fn.fnameescape(path))
  else
    vim.cmd("edit " .. vim.fn.fnameescape(path))
  end
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, initial_skeleton())
  vim.bo[bufnr].filetype = "markdown"
  vim.cmd("write")
  -- Park cursor on the empty line under ☼: ready for typing.
  vim.api.nvim_win_set_cursor(0, { #initial_skeleton(), 0 })
  refresh_winbar()
end

-- Submit: parse current buffer, call image-gen, append output + next ☼: marker.
function M.submit()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local marker_line = find_last_input_marker(lines)
  if not marker_line then
    vim.notify("image-gen: no ☼: marker in buffer", vim.log.levels.ERROR)
    return
  end

  local prompt = read_pending_prompt(lines, marker_line)
  if prompt == "" then
    vim.notify("image-gen: prompt is empty", vim.log.levels.ERROR)
    return
  end

  local previous_id = find_previous_response_id(lines, marker_line - 1)
  local preset = M.current_preset()
  local label = preset_label(preset)

  vim.notify(
    string.format("image-gen: %s (%s)...", previous_id and "iterating" or "generating", label),
    vim.log.levels.INFO
  )
  maybe_update_topic(bufnr, prompt)

  pending_start = math.floor(vim.uv.hrtime() / 1e9)
  refresh_winbar()

  image_gen.run_async({
    prompt = prompt,
    quality = preset.quality,
    size = preset.size,
    format = FORMAT,
    previous_id = previous_id,
  }, function(parsed, err)
    pending_start = nil
    refresh_winbar()
    if err then
      vim.notify("image-gen failed: " .. err, vim.log.levels.ERROR)
      return
    end
    if not vim.api.nvim_buf_is_valid(bufnr) then return end
    local alt = prompt:gsub("\n", " "):sub(1, 80)
    local revised = (parsed.revised_prompt or ""):gsub("\n", " ")
    local out = {
      "",
      OUTPUT_MARKER_PREFIX .. label .. "]",
      string.format("![%s](%s)", alt, parsed.path),
      "",
      "## response_id",
      parsed.response_id or "",
    }
    if revised ~= "" then
      vim.list_extend(out, { "", "## revised", revised })
    end
    vim.list_extend(out, { "", INPUT_MARKER, "" })
    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, out)
    -- Save and park cursor on the new empty line under the trailing ☼:.
    vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent! write") end)
    local new_total = vim.api.nvim_buf_line_count(bufnr)
    pcall(vim.api.nvim_win_set_cursor, 0, { new_total, 0 })
    vim.notify("image-gen: " .. parsed.path, vim.log.levels.INFO)
  end)
end

-- Detect whether `path` is one of our image chats (used by the winbar cond).
function M.is_image_chat_path(path)
  if not path or path == "" then return false end
  return path:match("/parrot/img%-chats/") ~= nil
end

return M
