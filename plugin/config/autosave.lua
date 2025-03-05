
-- :ASToggle
-- https://github.com/0x00-ketsu/autosave.nvim

require('autosave').setup(
  {
    enable = true,
    prompt = {
      enable = false,
      style = 'stdout',
      message = function()
        return 'Autosave: saved at ' .. vim.fn.strftime('%H:%M:%S')
      end,
    },
    events = {'InsertLeave', 'TextChanged'},
    -- I need TextChanged as things like ]e fire no insertLeave!
    -- events = {'InsertLeave'},
    conditions = {
      exists = true,
      modifiable = true,
      filename_is_not = {},
      filetype_is_not = {}
    },
    write_all_buffers = false,
    debounce_delay = 135
  }
)

-- ─   Insert start mark FiX                            ──

-- NOTE: this always sets the `[ mark (see :marks) to 0,1,1,0.
-- local autosave = require('autosave')
-- autosave.hook_before_saving = function ()
  -- print( vim.inspect( vim.fn.getpos("`[") ) )
-- end

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    -- Store the cursor position at the start of insert mode
    vim.g.insert_start_pos = vim.fn.getpos('.')
  end
})

-- vim.g.insert_start_pos
vim.keymap.set('n', '[g', function() vim.fn.setpos(".", vim.g.insert_start_pos) end )







