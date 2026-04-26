-- Image-gen chat buffer commands and winbar status.
-- Engine:  ~/.config/nvim/plugin/utils/image-gen.sh
-- Wrapper: lua/utils/image_gen.lua
-- Buffer:  lua/utils/image_chat.lua

local image_chat = require("utils.image_chat")

vim.api.nvim_create_user_command("PrtImgChatNew", function(args)
  local layout = args.args ~= "" and args.args or "vsplit"
  image_chat.new(layout)
end, {
  nargs = "?",
  complete = function() return { "vsplit", "split", "edit" } end,
  desc = "Open a new image-gen chat buffer",
})

vim.api.nvim_create_user_command("PrtImgSubmit", function()
  image_chat.submit()
end, { desc = "Submit current image-gen chat buffer" })

vim.api.nvim_create_user_command("PrtImgNextPreset", function()
  image_chat.next_preset()
end, { desc = "Cycle to next image-gen preset" })

vim.api.nvim_create_user_command("PrtImgPrevPreset", function()
  image_chat.prev_preset()
end, { desc = "Cycle to previous image-gen preset" })

-- Winbar status label: shown by lualine when buffer is an image-gen chat.
function _G.Parrot_image_status_label()
  return image_chat.current_preset_label()
end

-- Helper used as a lualine `cond`.
function _G.Is_image_chat_buffer()
  return image_chat.is_image_chat_path(vim.fn.expand("%:p"))
end

-- Buffer-local submit binding: <c-i><cr> in image-chat buffers.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.md",
  callback = function(ev)
    local path = vim.api.nvim_buf_get_name(ev.buf)
    if image_chat.is_image_chat_path(path) then
      vim.keymap.set({ "n", "i" }, "<c-i><cr>", "<cmd>PrtImgSubmit<cr>",
        { buffer = ev.buf, silent = true, desc = "Submit image-gen chat" })
    end
  end,
})
