local M = {}

local uv = vim.uv or vim.loop

local ignored_dirs = {
  [".git"] = true,
  [".next"] = true,
  [".turbo"] = true,
  [".venv"] = true,
  ["build"] = true,
  ["dist"] = true,
  ["node_modules"] = true,
  ["target"] = true,
}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "file nav" })
end

local function normalize(path)
  return vim.fn.fnamemodify(path, ":p"):gsub("[/\\]+$", "")
end

local function path_has_ignored_dir(path)
  for part in normalize(path):gmatch("[^/\\]+") do
    if ignored_dirs[part] then
      return true, part
    end
  end
  return false, nil
end

local function suffixes()
  return vim.tbl_filter(function(suffix)
    return suffix ~= ""
  end, vim.split(vim.o.suffixes or "", ",", { plain = true, trimempty = true }))
end

local function ends_with(str, suffix)
  return suffix == "" or str:sub(-#suffix) == suffix
end

local function has_ignored_suffix(path)
  for _, suffix in ipairs(suffixes()) do
    suffix = suffix:gsub("^%*", "")
    if ends_with(path, suffix) then
      return true
    end
  end
  return false
end

local function sibling_files(dir)
  local scan = uv.fs_scandir(dir)
  if not scan then
    return {}
  end

  local files = {}
  while true do
    local name = uv.fs_scandir_next(scan)
    if not name then
      break
    end

    local path = dir .. "/" .. name
    if vim.fn.filereadable(path) == 1
        and not path_has_ignored_dir(path)
        and not has_ignored_suffix(path)
    then
      files[#files + 1] = normalize(path)
    end
  end

  table.sort(files)
  return files
end

local function find_index(files, current)
  for idx, file in ipairs(files) do
    if file == current then
      return idx
    end
  end
  return nil
end

local function insertion_target(files, current, direction)
  if direction > 0 then
    for idx, file in ipairs(files) do
      if file > current then
        return idx
      end
    end
    return 1
  end

  for idx = #files, 1, -1 do
    if files[idx] < current then
      return idx
    end
  end
  return #files
end

function M.sibling_file(direction)
  direction = direction < 0 and -1 or 1

  local buf_name = vim.api.nvim_buf_get_name(0)
  if buf_name == "" then
    notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  local current = normalize(buf_name)

  local ignored, dir_name = path_has_ignored_dir(current)
  if ignored then
    notify("Refusing to navigate inside " .. dir_name, vim.log.levels.WARN)
    return
  end

  local dir = vim.fs.dirname(current)
  if not dir then
    notify("No parent folder for current file", vim.log.levels.WARN)
    return
  end

  local files = sibling_files(dir)
  if #files == 0 then
    notify("No sibling files found", vim.log.levels.WARN)
    return
  end

  if #files == 1 and files[1] == current then
    notify("No other sibling files", vim.log.levels.INFO)
    return
  end

  local count = vim.v.count1 or 1
  local idx = find_index(files, current)
  if idx then
    idx = ((idx - 1 + direction * count) % #files) + 1
  else
    idx = insertion_target(files, current, direction)
    idx = ((idx - 1 + direction * (count - 1)) % #files) + 1
  end

  vim.cmd.edit(vim.fn.fnameescape(files[idx]))
end

return M
