
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
    conditions = {
      exists = true,
      modifiable = true,
      filename_is_not = {},
      filetype_is_not = {'harpoon'}
    },
    write_all_buffers = false,
    debounce_delay = 135
  }
)












