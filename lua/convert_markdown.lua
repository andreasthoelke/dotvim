
local M = {}
local loop = vim.loop
local api = vim.api

function M.convertFile()
  local shortname = vim.fn.expand('%:t:r')
  local fullname = api.nvim_buf_get_name(0)
 -- loop logic goes here
end

return M
