


-- from https://github.com/matsui54/denite-nvim-lsp/blob/bee2eb082f54f4a77ecf34c624afa363902f2c73/lua/lsp_denite.lua
-- also maybe https://github.com/amirrezaask/fuzzy.nvim/blob/d98135c8a30c517f085eede5810b73a62060b016/lua/fuzzy/lsp.lua
local M = {}

local vim = vim
local util = require 'vim.lsp.util'
local utilsg = require 'utils.general'

-- vim.api.nvim_win_get_config(0)
-- vim.api.nvim_win_get_config(0).relative
-- lua vim.print(vim.api.nvim_win_get_config(0))

-- require('toggle_lsp_diagnostics').init { underline = false, virtual_text = { prefix = 'XXX', spacing = 5 } }
-- require'toggle_lsp_diagnostics'.init({ start_on = false }})
-- require'toggle_lsp_diagnostics'.init()



vim.keymap.set( 'n', '<leader>lds', function()
  putt( vim.lsp.diagnostic.get_line_diagnostics() )
end)


local function get_available_client(method)
  for id, client in pairs(vim.lsp.buf_get_clients()) do
    if client['resolved_capabilities'][method] == true then
      return id
    end
  end
  return 0
end

function M.hover()
  local params = util.make_position_params()
  -- todo: set these params: see ~/.config/nvim/plugin/tools_js.vim#/Workaround.%20The%20type
  -- return params
  return vim.lsp.buf_request_sync(0, "textDocument/hover", params, 2000)
end
-- put( require'utils_lsp'.hover() )

-- not supported for scala
-- function M.type()
--   local params = util.make_position_params()
--   -- todo: set these params: see ~/.config/nvim/plugin/tools_js.vim#/Workaround.%20The%20type
--   -- return params
--   local results_lsp = vim.lsp.buf_request_sync(0, "textDocument/type", params, 2000)
--   return results_lsp
-- end
-- -- put( require'utils_lsp'.hover() )

function M.LspType()
  local typeString = ""
  local results_lsp, err = M.hover()
  if results_lsp == nil then
    vim.print( err )
    return err
  end
  for _, server_results in pairs(results_lsp) do
    if server_results.result then
      typeString = server_results.result.contents.value
    end
  end
  local split = vim.split(typeString, "\n")
  -- put( split )
  -- put( utilsg.Tablelength( split ) )
  local slen = utilsg.Tablelength( split )
  -- local retval = vim.api.nvim_call_function( "matchstr", { typeString, [[\v:\s\zs.*\ze\n]] } )
  local retval = vim.api.nvim_call_function( "matchstr", { split[2], [[\v:\s\zs.*]] } )

  if retval == "" then
    retval = vim.api.nvim_call_function( "matchstr", { split[slen-1], [[\v:\s\zs.*]] } )
  end
  -- local retval = vim.api.nvim_call_function( "matchstr", { retval, [[\v:\s\zs.*\ze\n]] } )
  -- local retval = vim.api.nvim_call_function( "matchstr", { typeString, [[\v:\s\zs.*\ze\]\n]] } )
  -- local retval = vim.api.nvim_call_function( "matchstr", { typeString, ":\\s\\zs.*\\ze`" } )
  return retval
end
-- put( require'utils_lsp'.LspType() )
-- vim.api.nvim_call_function( "matchstr", { "abcdef eins ", [[\v(def|val)\s\zseins]] } )
-- vim.api.nvim_call_function( "matchstr", { "lazy val e1_sql: HeadZ\n", [[\v:\s\zs\w*]] } )


function M.references()
  local params = util.make_position_params()
  params.context = { includeDeclaration = true }

  local results_lsp = vim.lsp.buf_request_sync(0, "textDocument/references", params, 10000)
  local locations = {}
  for _, server_results in pairs(results_lsp) do
    if server_results.result then
      vim.list_extend(locations, vim.lsp.util.locations_to_items(server_results.result) or {})
    end
  end

  if vim.tbl_isempty(locations) then
    return nil
  end

  return locations
end

-- function M.document_symbol()
--   local params = { textDocument = util.make_text_document_params() }
--   local raw_result = vim.lsp.buf_request_sync(0, 'textDocument/documentSymbol', params, 1000)
--   local client_id = get_available_client('document_symbol')
--   if client_id == 0  or raw_result == nil then
--     return nil
--   end
--   local result = util.symbols_to_items(raw_result[client_id].result, 0)
--   return result
-- end

function M.workspace_symbol(query)
  local raw_result = vim.lsp.buf_request_sync(0, 'workspace/symbol', {query=query}, 1000)
  local client_id = get_available_client('workspace_symbol')
  if client_id == 0  or raw_result == nil then
    return nil
  end
  local result = util.symbols_to_items(raw_result[client_id].result, 0)
  return result
end

function M.diagnostic_buffer()
  local res = vim.lsp.diagnostic.get(0)
  if res == nil then
    return nil
  end
  return res
end

function M.diagnosticsShow()
  vim.lsp.util.open_floating_preview( {M.diagnostic_buffer()} )
end
-- require'utils_lsp'.diagnostic_buffer()

-- require'utils_lsp'.diagnosticsShow()

-- vim.lsp.util.open_floating_preview( {"eins"} )


function M.diagnostic_all()
  local raw_result = vim.lsp.diagnostic.get_all()
  if raw_result == nil then
    return nil
  end
  local res = {}
  for key, var in pairs(raw_result) do
    for _, item in ipairs(var) do
      item["bufnr"] = key
      table.insert(res, item)
    end
  end
  return res
end

function PrintDiagnostics(opts, bufnr, line_nr, client_id)
  bufnr = bufnr or 0
  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
  opts = opts or {['lnum'] = line_nr}

  local line_diagnostics = vim.diagnostic.get(bufnr, opts)
  if vim.tbl_isempty(line_diagnostics) then return end

  local diagnostic_message = ""
  for i, diagnostic in ipairs(line_diagnostics) do
    diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
    print(diagnostic_message)
    if i ~= #line_diagnostics then
      diagnostic_message = diagnostic_message .. "\n"
    end
  end
  vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})

end


return M











