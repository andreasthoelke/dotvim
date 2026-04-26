local M = {}

-- True if `token` ends in .jpg/.jpeg/.png (case-insensitive).
function M.looks_like_image(token)
  if type(token) ~= "string" then
    return false
  end
  local lower = token:lower()
  return lower:match("%.jpe?g$") ~= nil or lower:match("%.png$") ~= nil
end

-- Strip common surrounding punctuation from a token (parens, brackets,
-- markdown link syntax, trailing commas/periods).
function M.strip_token_punct(token)
  return token:gsub("^[%(%[<\"'`!]+", ""):gsub("[%)%]>\"'`,.;:!?]+$", "")
end

-- Resolve a candidate image path token. Tries: ~ expansion, absolute, relative
-- to cwd, relative to buffer's parent dir. Returns absolute readable path or nil.
function M.resolve_image_path(token, buffer_dir)
  local expanded = vim.fn.expand(token)
  local candidates = {}
  if expanded:sub(1, 1) == "/" then
    table.insert(candidates, expanded)
  else
    table.insert(candidates, vim.fn.fnamemodify(expanded, ":p"))
    if buffer_dir and buffer_dir ~= "" then
      table.insert(candidates, vim.fn.fnamemodify(buffer_dir .. "/" .. expanded, ":p"))
    end
  end
  for _, c in ipairs(candidates) do
    if vim.fn.filereadable(c) == 1 then
      return c
    end
  end
  return nil
end

-- Scan prompt for image-path tokens. Returns (cleaned_prompt, resolved_paths).
-- Resolved tokens are removed from the prompt; unresolved tokens stay as text.
function M.extract_image_paths(prompt, buffer_dir)
  local resolved = {}
  local seen = {}

  local function attach(candidate, original)
    local stripped = M.strip_token_punct(candidate)
    if M.looks_like_image(stripped) then
      local abs = M.resolve_image_path(stripped, buffer_dir)
      if abs and not seen[abs] then
        table.insert(resolved, abs)
        seen[abs] = true
        prompt = prompt:gsub(vim.pesc(original), "", 1)
      end
    end
  end

  for _, quote in ipairs({ '"', "'", "`" }) do
    local pattern = quote .. "([^" .. quote .. "]+)" .. quote
    for candidate in prompt:gmatch(pattern) do
      attach(candidate, quote .. candidate .. quote)
    end
  end

  for token in prompt:gmatch("%S+") do
    attach(token, token)
  end
  -- Collapse whitespace left behind by removed tokens.
  prompt = prompt:gsub("[ \t]+", " "):gsub(" ?\n ?", "\n")
  prompt = vim.trim(prompt)
  return prompt, resolved
end

function M.mime_type(path)
  if type(path) ~= "string" then
    return nil
  end
  local lower = path:lower()
  if lower:match("%.jpe?g$") then
    return "image/jpeg"
  elseif lower:match("%.png$") then
    return "image/png"
  end
  return nil
end

function M.data_url(path)
  local mime = M.mime_type(path)
  if not mime then
    return nil, "unsupported image type: " .. tostring(path)
  end
  local fd = vim.uv.fs_open(path, "r", 438)
  if not fd then
    return nil, "could not read image: " .. tostring(path)
  end
  local stat = vim.uv.fs_fstat(fd)
  if not stat or not stat.size then
    vim.uv.fs_close(fd)
    return nil, "could not stat image: " .. tostring(path)
  end
  local bytes = vim.uv.fs_read(fd, stat.size, 0)
  vim.uv.fs_close(fd)
  if not bytes then
    return nil, "could not read image: " .. tostring(path)
  end
  return "data:" .. mime .. ";base64," .. vim.base64.encode(bytes), nil
end

return M
