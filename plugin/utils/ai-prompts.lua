-- ─   AI Prompt Configuration                            ──
-- Customize and extend your LLM prompts here

local ai = require('plugin.utils.ai')

-- ─   Add Custom Prompts                                 ──
-- Example of adding new prompts:

-- ai.prompts.review = {
--   name = "Code Review",
--   prompt = "Perform a thorough code review. Check for: correctness, performance, security, maintainability, and adherence to best practices.",
--   provider = "anthropic"
-- }

-- ai.prompts.optimize = {
--   name = "Optimize Performance",
--   prompt = "Optimize this code for better performance. Explain what changes you made and why.",
--   provider = "openai"
-- }

-- ai.prompts.explain_simple = {
--   name = "ELI5 Explanation",
--   prompt = "Explain this code as if I'm a beginner programmer. Use simple terms and analogies.",
--   provider = "gemini"
-- }

-- ─   Filetype-specific Default Prompts                  ──
-- Set different defaults based on file type

local filetype_defaults = {
  python = "explain",
  javascript = "improve",
  typescript = "improve",
  lua = "explain",
  vim = "explain",
  markdown = "topic",
  text = "topic",
  sh = "explain",
  bash = "explain",
}

-- Override the default prompt function
local original_getDefaultPrompt = _G.getDefaultPrompt
_G.getDefaultPrompt = function()
  local ft = vim.bo.filetype
  local prompt_key = filetype_defaults[ft]

  if prompt_key and ai.prompts[prompt_key] then
    return ai.prompts[prompt_key].prompt
  end

  -- Fallback to topic summary
  return ai.prompts.topic.prompt
end

-- ─   Quick Access Aliases                               ──
-- Create shorter commands for your most used prompts

vim.api.nvim_create_user_command("T", function()
  require('plugin.utils.ai').sendVisualQuick("topic")
end, { range = true, desc = "Quick topic summary" })

vim.api.nvim_create_user_command("E", function()
  require('plugin.utils.ai').sendVisualQuick("explain")
end, { range = true, desc = "Quick explain" })

-- ─^  AI Prompt Configuration                            ▲
