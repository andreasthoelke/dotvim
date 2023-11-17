
function _G.Show_buffer_in_floating_window(bufnr, opts)
  -- Set default values for opts.width and opts.anchor
  opts.width = opts.width or 80
  opts.anchor = opts.anchor or 'W'

  -- Get the height and width of the Neovim window
  local nvim_height = vim.api.nvim_get_option('lines')
  local nvim_width = vim.api.nvim_get_option('columns')

  -- Set the width and height of the floating window
  local config = {
    relative = 'editor',
    width = opts.width,
    height = math.floor(nvim_height / 2),
  }

  -- Calculate the row and col properties of the center of the Neovim window
  if opts.anchor == 'W' then
    config.row = math.floor(nvim_height / 2) - math.floor(config.height / 2)
    config.col = 0
  elseif opts.anchor == 'E' then
    config.row = math.floor(nvim_height / 2) - math.floor(config.height / 2)
    config.col = nvim_width - config.width
  end

  -- Create the floating window
  local floating_win = vim.api.nvim_open_win(bufnr, false, config)

  -- Set the focus to the floating window
  vim.api.nvim_set_current_win(floating_win)
end


-- Show_buffer_in_floating_window( 6, Telesc_dynPosOpts( {} ))
-- Telesc_dynPosOpts( {} )


