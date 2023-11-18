

function _G.FloatBuf_inOtherWinColumn( bufnrOrPath, opts )

  local bufnr
  if type( bufnrOrPath ) == 'number' then
    bufnr = bufnrOrPath
  else
    -- find existing buffer with this name
    bufnr = vim.fn.bufnr( bufnrOrPath )
    if bufnr == -1 then
      bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_name(bufnr, bufnrOrPath)
    end
  end

  local config = FloatOpts_inOtherWinColumn( opts )

  -- Create the floating window
  local floating_win = vim.api.nvim_open_win(bufnr, false, config)

  -- Set the focus to the floating window
  vim.api.nvim_set_current_win(floating_win)
end

function _G.FloatOpts_inOtherWinColumn( opts )
  opts = opts or Telesc_dynPosOpts( {} )
  -- Set default values for opts.width and opts.anchor
  opts.width = opts.width or 80
  opts.anchor = opts.anchor or 'W'

  -- Get the height and width of the Neovim window
  local nvim_height = vim.api.nvim_get_option('lines')
  local nvim_width = vim.api.nvim_get_option('columns')

  -- Set the width and height of the floating window
  local config = {
    relative = 'editor',
    width = opts.width - 1,
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

  -- Set border options
  config.border = opts.border or 'rounded'

  return config
end


-- FloatBuf_inOtherWinColumn( 6, Telesc_dynPosOpts( {} ))
-- FloatBuf_inOtherWinColumn( vim.g["ScalaRepl_bufnr"], Telesc_dynPosOpts( {} ))
-- FloatBuf_inOtherWinColumn( "~/Documents/Notes/Fullstack_app.md", Telesc_dynPosOpts( {} ))
-- Telesc_dynPosOpts( {} )


