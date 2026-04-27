-- nvim-treesitter.configs
-- require('nvim-ts-autotag').setup()

-- require('nvim-ts-autotag').setup({
--   opts = {
--     enable_close = true,     -- Auto close tags
--     enable_rename = true,    -- Auto rename pairs of tags
--     enable_close_on_slash = false  -- Auto close on trailing </>
--   }
-- })

-- ts-autotag.nvim's InsertLeavePre callback can be triggered in transient
-- buffers like Telescope, where get_parser() succeeds with nil in Nvim 0.12.
local rename_tag = require('ts-autotag.rename_tag')
local maybe_rename_tag = rename_tag.maybe_rename_tag
rename_tag.maybe_rename_tag = function(bufnr)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then
    return
  end

  return maybe_rename_tag(bufnr)
end

require('ts-autotag').setup({
  opening_node_types = {
    -- templ
    "tag_start",

    -- xml,
    "STag",

    -- html
    "start_tag",

    -- jsx
    "jsx_opening_element",
  },
  identifier_node_types = {
    -- html
    "tag_name",
    "erroneous_end_tag_name",

    -- xml,
    "Name",

    -- jsx
    "member_expression",
    "identifier",

    -- templ
    "element_identifier",
  },

  disable_in_macro = true,

  auto_close = {
    enabled = true,
  },
  auto_rename = {
    enabled = true,
    closing_node_types = {
      -- jsx
      "jsx_closing_element",

      -- xml,
      "Etag",

      -- html
      "end_tag",
      "erroneous_end_tag",

      -- templ
      "tag_end",
    },
  },
})


