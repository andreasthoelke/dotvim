-- Low-level wrapper around plugin/utils/image-gen.sh.
-- No buffer awareness; just runs the script and parses its JSON.

local M = {}

local SCRIPT = vim.fn.expand("~/.config/nvim/plugin/utils/image-gen.sh")

local function build_args(opts)
  local args = { SCRIPT, "--prompt", opts.prompt, "--quality", opts.quality or "auto" }
  if opts.size and opts.size ~= "" then
    table.insert(args, "--size")
    table.insert(args, opts.size)
  end
  if opts.format and opts.format ~= "" then
    table.insert(args, "--format")
    table.insert(args, opts.format)
  end
  if opts.previous_id and opts.previous_id ~= "" then
    table.insert(args, "--previous-id")
    table.insert(args, opts.previous_id)
  end
  if opts.out_dir and opts.out_dir ~= "" then
    table.insert(args, "--out-dir")
    table.insert(args, opts.out_dir)
  end
  return args
end

local function parse_result(result)
  if result.code ~= 0 then
    local err = result.stderr ~= "" and result.stderr or "image-gen.sh failed"
    return nil, err
  end
  local ok, parsed = pcall(vim.json.decode, result.stdout)
  if not ok or type(parsed) ~= "table" or not parsed.path then
    return nil, "bad JSON: " .. tostring(result.stdout)
  end
  return parsed, nil
end

-- Synchronous run. Returns (parsed, err).
function M.run(opts)
  if not opts or not opts.prompt or opts.prompt == "" then
    return nil, "empty prompt"
  end
  local result = vim.system(build_args(opts), { text = true }):wait()
  return parse_result(result)
end

-- Async run. on_done is invoked on the main loop with (parsed, err).
function M.run_async(opts, on_done)
  if not opts or not opts.prompt or opts.prompt == "" then
    return on_done(nil, "empty prompt")
  end
  vim.system(build_args(opts), { text = true }, function(result)
    local parsed, err = parse_result(result)
    vim.schedule(function() on_done(parsed, err) end)
  end)
end

return M
