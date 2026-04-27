

-- Note maps: ~/.config/nvim/plugin/completion.vim‖/Issue:ˍTogg

local toggle_lsp_diagnostics = require('toggle_lsp_diagnostics')

local current_settings = toggle_lsp_diagnostics.current_settings
toggle_lsp_diagnostics.configure_diagnostics = function(settings)
  local conf = current_settings(settings or {})
  if conf.jump == true then
    conf.jump = { wrap = true }
  end
  vim.diagnostic.config(conf)
end

toggle_lsp_diagnostics.init {
  start_on = true,
  underline = false,
  signs = false,
  virtual_text = { prefix = '', spacing = 4 },
}


