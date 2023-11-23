

function _G.FloatBuf_inOtherWinColumn( bufnrOrPath )

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

  local config = FloatOpts_inOtherWinColumn()

  -- Create the floating window
  local floating_win = vim.api.nvim_open_win(bufnr, false, config)

  -- Set the focus to the floating window
  vim.api.nvim_set_current_win(floating_win)
end

-- vim.api.nvim_open_win(0, false, {relative='editor', row=3, col=3, width=12, height=12})


function _G.FloatOpts_inOtherWinColumn()
  local posOpts = Float_dynAnchorWidth()

  -- Get the height and width of the Neovim window
  local nvim_height = vim.api.nvim_get_option('lines')
  local nvim_width = vim.api.nvim_get_option('columns')

  -- Build the float win config map
  local config = {
    relative = 'editor',
    -- NOTE: this format doesn't need an anchor
    -- anchor = 'N' .. posOpts.anchor,
    width = posOpts.width - 1,
    height = math.floor(nvim_height / 2),
    border = 'rounded'
  }

  -- Calculate the row and col properties of the center of the Neovim window
  if posOpts.anchor == 'W' then
    config.row = math.floor(nvim_height / 2) - math.floor(config.height / 2)
    config.col = 0
  elseif posOpts.anchor == 'E' then
    config.row = math.floor(nvim_height / 2) - math.floor(config.height / 2)
    config.col = nvim_width - config.width
  else
    vim.print( posOpts.anchor .. " is not supported" )
  end

  return config
end

-- FloatOpts_inOtherWinColumn()

function _G.Float_dynAnchorWidth()
  local neovim_full_client_width = vim.api.nvim_get_option('columns')
  local widthDefault = neovim_full_client_width / 2 - 4
  local anchorDefault = 'E'
  if vim.g['Goyo_active'] == 1 or vim.fn.winwidth(1) < 40 then
    return { anchor = anchorDefault, width = widthDefault }
  end
  local thisWinWidth = vim.api.nvim_win_get_width(0)
  local width
  if thisWinWidth == neovim_full_client_width then
    width = widthDefault
  else
    width = neovim_full_client_width - thisWinWidth - 2
  end
  local cursorWinCol = CursorIsInWinColumn()
  local winAnchor = cursorWinCol == 'L' and 'E' or 'W'
  return { anchor = winAnchor, width = width}
end

-- vim.api.nvim_win_get_width( vim.api.nvim_tabpage_list_wins()[0] )
-- FloatBuf_inOtherWinColumn( 6, Float_dynAnchorWidth( {} ))
-- FloatBuf_inOtherWinColumn( vim.g["ScalaRepl_bufnr"], Float_dynAnchorWidth( {} ))
-- FloatBuf_inOtherWinColumn( "~/Documents/Notes/Fullstack_app.md", Float_dynAnchorWidth( {} ))
-- Float_dynAnchorWidth( {} )

