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
-- Submission is parsed from the last `☼:` block. For follow-up turns, the most
-- recent generated image above the prompt is sent as an edit input.

local image_gen = require("utils.image_gen")
local image_paths = require("utils.image_paths")

local M = {}

local CHAT_DIR = vim.fn.expand("~/.local/share/nvim/parrot/img-chats")
local INPUT_MARKER = "☼:"
local OUTPUT_MARKER_PREFIX = "⌘:["

-- The shell script sends requests to the Images API with IMAGE_GEN_MODEL
-- defaulting to gpt-image-2. DISPLAY_MODEL keeps the compact chat label.
local DISPLAY_MODEL = "image-2"
local FORMAT = "png"

-- Tracks in-flight requests per buffer so each winbar can show its own timer.
local pending_by_buf = {}

local PRESETS = {
  { quality = "high",   size = "1024x1024" },
  { quality = "medium", size = "1024x1024" },
  { quality = "low",    size = "1024x1024" },
  { quality = "auto",   size = "1024x1024" },
  { quality = "high",   size = "auto" },
  { quality = "medium", size = "auto" },
  { quality = "low",    size = "auto" },
  { quality = "auto",   size = "auto" },
}
local current_preset_index = 1

local function image_count()
  local n = tonumber(vim.env.IMAGE_GEN_N or "1") or 1
  if n < 1 then return 1 end
  if n > 10 then return 10 end
  return math.floor(n)
end

local function refresh_winbar()
  vim.schedule(function()
    local ok, lualine = pcall(require, "lualine")
    if ok and type(lualine.refresh) == "function" then
      pcall(lualine.refresh, { place = { "winbar" } })
    end
  end)
end

local function preset_label(p)
  local label = string.format("%s:%s@%s", DISPLAY_MODEL, p.quality, p.size)
  local n = image_count()
  if n > 1 then
    label = string.format("%s x%d", label, n)
  end
  return label
end

function M.current_preset()
  return PRESETS[current_preset_index]
end

function M.current_preset_label(bufnr)
  local label = preset_label(M.current_preset())
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local pending = pending_by_buf[bufnr]
  if pending then
    local elapsed = math.floor(vim.uv.hrtime() / 1e9 - pending.started_at)
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

function M.set_count(n)
  n = tonumber(n) or 1
  n = math.floor(n)
  if n < 1 then n = 1 end
  if n > 10 then n = 10 end
  vim.env.IMAGE_GEN_N = tostring(n)
  vim.notify("image-gen count: " .. n, vim.log.levels.INFO)
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

local function find_previous_image_path(lines, up_to)
  for i = up_to, 1, -1 do
    local path = lines[i]:match("^%s*!%[[^%]]*%]%(([^)]+)%)%s*$")
    if path and vim.fn.filereadable(path) == 1 then
      return path
    end
  end
  return nil
end

local function append_unique(list, value)
  if not value or value == "" then return end
  for _, existing in ipairs(list) do
    if existing == value then return end
  end
  table.insert(list, value)
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
  if pending_by_buf[bufnr] then
    vim.notify("image-gen: request already running for this buffer", vim.log.levels.WARN)
    return
  end
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local marker_line = find_last_input_marker(lines)
  if not marker_line then
    vim.notify("image-gen: no ☼: marker in buffer", vim.log.levels.ERROR)
    return
  end

  local raw_prompt = read_pending_prompt(lines, marker_line)
  if raw_prompt == "" then
    vim.notify("image-gen: prompt is empty", vim.log.levels.ERROR)
    return
  end

  -- Detect and resolve any .jpg/.jpeg/.png paths in the prompt; resolved tokens
  -- are stripped out of the text and uploaded as input_images.
  local buffer_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:h")
  local prompt, input_images = image_paths.extract_image_paths(raw_prompt, buffer_dir)
  if prompt == "" and #input_images > 0 then
    -- All text was paths. Provide a sensible fallback so the model has something.
    prompt = "edit"
  end

  local previous_image = find_previous_image_path(lines, marker_line - 1)
  if #input_images == 0 then
    append_unique(input_images, previous_image)
  end
  local preset = M.current_preset()
  local label = preset_label(preset)

  local mode = previous_image and #input_images > 0 and "editing" or "generating"
  if #input_images > 0 then mode = mode .. "+" .. #input_images .. "img" end
  vim.notify(string.format("image-gen: %s (%s)...", mode, label), vim.log.levels.INFO)
  maybe_update_topic(bufnr, prompt)

  pending_by_buf[bufnr] = {
    started_at = math.floor(vim.uv.hrtime() / 1e9),
  }
  refresh_winbar()

  image_gen.run_async({
    prompt = prompt,
    quality = preset.quality,
    size = preset.size,
    format = FORMAT,
    n = image_count(),
    input_images = input_images,
  }, function(parsed, err)
    pending_by_buf[bufnr] = nil
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
    }
    for _, path in ipairs(parsed.paths or { parsed.path }) do
      table.insert(out, string.format("![%s](%s)", alt, path))
    end
    if #input_images > 0 then
      vim.list_extend(out, { "", "## inputs" })
      for _, p in ipairs(input_images) do
        table.insert(out, p)
      end
    end
    if revised ~= "" then
      vim.list_extend(out, { "", "## revised", revised })
    end
    vim.list_extend(out, { "", INPUT_MARKER, "" })
    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, out)
    -- Save and park cursor on the new empty line under the trailing ☼:.
    vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent! write") end)
    local new_total = vim.api.nvim_buf_line_count(bufnr)
    pcall(vim.api.nvim_win_set_cursor, 0, { new_total, 0 })
    if parsed.paths and #parsed.paths > 1 then
      vim.notify(string.format("image-gen: %d images", #parsed.paths), vim.log.levels.INFO)
    else
      vim.notify("image-gen: " .. parsed.path, vim.log.levels.INFO)
    end
  end)
end

-- Detect whether `path` is one of our image chats (used by the winbar cond).
function M.is_image_chat_path(path)
  if not path or path == "" then return false end
  return path:match("/parrot/img%-chats/") ~= nil
end

return M
