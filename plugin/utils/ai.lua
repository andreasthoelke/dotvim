-- ─   AI/LLM Integration Module                         ──

local M = {}

-- ─   Prompt Templates                                   ──
M.prompts = {
  -- Quick analysis
  topic = {
    name = "Topic Summary",
    prompt = "Provide a concise topic summary for this text. Respond with only the topic summary string, nothing else.",
    provider = "gemini"
  },
  explain = {
    name = "Explain Code",
    prompt = "Explain what this code does in clear, simple terms.",
    provider = "openai"
  },

  -- Code improvement
  improve = {
    name = "Suggest Improvements",
    prompt = "Analyze this code and suggest improvements for readability, performance, and best practices.",
    provider = "anthropic"
  },
  bugs = {
    name = "Find Bugs",
    prompt = "Identify potential bugs, edge cases, or issues in this code.",
    provider = "anthropic"
  },
  refactor = {
    name = "Refactor Suggestions",
    prompt = "Suggest how to refactor this code for better maintainability and clarity.",
    provider = "openai"
  },

  -- Documentation
  docs = {
    name = "Generate Documentation",
    prompt = "Generate appropriate documentation comments for this code (JSDoc, docstring, etc).",
    provider = "openai"
  },
  comment = {
    name = "Add Comments",
    prompt = "Add helpful inline comments explaining complex parts of this code.",
    provider = "openai"
  },

  -- Transformation
  translate = {
    name = "Translate Comments",
    prompt = "Translate all comments and documentation in this code to English.",
    provider = "gemini"
  },
  simplify = {
    name = "Simplify Code",
    prompt = "Rewrite this code in a simpler, more readable way while maintaining the same functionality.",
    provider = "openai"
  },
  typescript = {
    name = "Convert to TypeScript",
    prompt = "Convert this JavaScript code to TypeScript with appropriate type annotations.",
    provider = "openai"
  },

  -- Testing
  tests = {
    name = "Generate Tests",
    prompt = "Generate unit tests for this code with good coverage of edge cases.",
    provider = "openai"
  },
  testcases = {
    name = "Test Cases",
    prompt = "List test cases that should be covered for this code, including edge cases.",
    provider = "gemini"
  },

  -- Analysis
  complexity = {
    name = "Complexity Analysis",
    prompt = "Analyze the time and space complexity of this code.",
    provider = "openai"
  },
  security = {
    name = "Security Review",
    prompt = "Review this code for security vulnerabilities and suggest fixes.",
    provider = "anthropic"
  },
  performance = {
    name = "Performance Analysis",
    prompt = "Analyze performance bottlenecks and suggest optimizations.",
    provider = "openai"
  },

  -- Custom prompt
  custom = {
    name = "Custom Prompt",
    prompt = nil,  -- Will be set dynamically
    provider = "openai"
  }
}

-- Get default prompt based on context
local function getDefaultPrompt()
  -- You can add logic here to detect file type and suggest appropriate default
  local ft = vim.bo.filetype

  -- For now, return topic summary as default
  return M.prompts.topic.prompt
end

-- Helper function to get visual selection text
local function getVisualSelection()
  -- Get visual selection marks
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local start_col = start_pos[3]
  local end_line = end_pos[2]
  local end_col = end_pos[3]

  -- Get lines
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  if #lines == 0 then
    return ""
  end

  -- Handle single line selection
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_col, end_col)
  else
    -- First line: from start_col to end
    lines[1] = string.sub(lines[1], start_col)
    -- Last line: from beginning to end_col
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
  end

  return table.concat(lines, "\n")
end

-- Send text to LLM with a prompt
function M.sendToLLM(text, prompt, provider)
  provider = provider or "openai"

  -- Path to the llm-text script
  local script_path = vim.fn.expand("~/.config/nvim/plugin/utils/llm-text.sh")

  -- Check if script exists
  if vim.fn.filereadable(script_path) == 0 then
    vim.notify("LLM script not found at: " .. script_path, vim.log.levels.ERROR)
    return
  end

  -- Make script executable
  vim.fn.system("chmod +x " .. script_path)

  -- Build command
  local cmd = string.format(
    "PROVIDER=%s %s %s %s",
    vim.fn.shellescape(provider),
    vim.fn.shellescape(script_path),
    vim.fn.shellescape(text),
    vim.fn.shellescape(prompt)
  )

  -- Show loading indicator
  vim.notify("Sending to LLM...", vim.log.levels.INFO)

  -- Execute async
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data, _)
      if data and #data > 0 then
        -- Remove empty last line if present
        if data[#data] == "" then
          table.remove(data)
        end

        if #data > 0 then
          -- Display result in floating window
          vim.g['floatWin_win'] = vim.fn.FloatingSmallNew(data)
          vim.fn.FloatWin_FitWidthHeight()
          vim.cmd('wincmd p')
        end
      end
    end,
    on_stderr = function(_, data, _)
      if data and #data > 0 and data[1] ~= "" then
        local error_msg = table.concat(data, "\n")
        vim.notify("LLM Error: " .. error_msg, vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, exit_code, _)
      if exit_code ~= 0 then
        vim.notify("LLM command failed with exit code: " .. exit_code, vim.log.levels.ERROR)
      end
    end,
  })
end

-- Send visual selection to LLM
function M.sendVisualToLLM(prompt, provider)
  local text = getVisualSelection()

  if text == "" then
    vim.notify("No visual selection found", vim.log.levels.WARN)
    return
  end

  M.sendToLLM(text, prompt, provider)
end

-- Interactive version that prompts for input
function M.sendVisualToLLMInteractive(provider)
  local text = getVisualSelection()

  if text == "" then
    vim.notify("No visual selection found", vim.log.levels.WARN)
    return
  end

  -- Prompt user for the task/question
  vim.ui.input({
    prompt = "Enter prompt for LLM: ",
    default = getDefaultPrompt(),
  }, function(prompt)
    if prompt and prompt ~= "" then
      M.sendToLLM(text, prompt, provider)
    end
  end)
end

-- Select prompt from list using telescope or vim.ui.select
function M.selectPrompt(callback)
  local items = {}
  local prompt_keys = {}

  -- Build list of prompts
  for key, prompt_data in pairs(M.prompts) do
    if key ~= "custom" then
      table.insert(items, string.format("[%s] %s", key, prompt_data.name))
      table.insert(prompt_keys, key)
    end
  end
  table.insert(items, "[custom] Custom Prompt")
  table.insert(prompt_keys, "custom")

  vim.ui.select(items, {
    prompt = "Select LLM Prompt: ",
    format_item = function(item) return item end,
  }, function(choice, idx)
    if not choice then return end

    local selected_key = prompt_keys[idx]
    local prompt_data = M.prompts[selected_key]

    if selected_key == "custom" then
      -- Ask for custom prompt
      vim.ui.input({
        prompt = "Enter custom prompt: ",
        default = "",
      }, function(custom_prompt)
        if custom_prompt and custom_prompt ~= "" then
          callback(custom_prompt, prompt_data.provider)
        end
      end)
    else
      callback(prompt_data.prompt, prompt_data.provider)
    end
  end)
end

-- Send visual selection with prompt selection menu
function M.sendVisualWithMenu()
  local text = getVisualSelection()

  if text == "" then
    vim.notify("No visual selection found", vim.log.levels.WARN)
    return
  end

  M.selectPrompt(function(prompt, provider)
    if prompt then
      M.sendToLLM(text, prompt, provider)
    end
  end)
end

-- Quick access functions for common prompts
function M.sendVisualQuick(prompt_key)
  local text = getVisualSelection()

  if text == "" then
    vim.notify("No visual selection found", vim.log.levels.WARN)
    return
  end

  local prompt_data = M.prompts[prompt_key]
  if not prompt_data then
    vim.notify("Unknown prompt key: " .. prompt_key, vim.log.levels.ERROR)
    return
  end

  M.sendToLLM(text, prompt_data.prompt, prompt_data.provider)
end

-- Create commands for easy access
vim.api.nvim_create_user_command("LLMVisual", function(opts)
  local prompt = opts.args
  if prompt == "" then
    M.sendVisualToLLMInteractive()
  else
    M.sendVisualToLLM(prompt)
  end
end, { range = true, nargs = "?" })

vim.api.nvim_create_user_command("LLMVisualGemini", function(opts)
  local prompt = opts.args
  if prompt == "" then
    M.sendVisualToLLMInteractive("gemini")
  else
    M.sendVisualToLLM(prompt, "gemini")
  end
end, { range = true, nargs = "?" })

vim.api.nvim_create_user_command("LLMVisualClaude", function(opts)
  local prompt = opts.args
  if prompt == "" then
    M.sendVisualToLLMInteractive("anthropic")
  else
    M.sendVisualToLLM(prompt, "anthropic")
  end
end, { range = true, nargs = "?" })

-- Command with menu selection
vim.api.nvim_create_user_command("LLMMenu", function()
  M.sendVisualWithMenu()
end, { range = true })

-- Quick commands for common prompts
vim.api.nvim_create_user_command("LLMTopic", function()
  M.sendVisualQuick("topic")
end, { range = true })

vim.api.nvim_create_user_command("LLMExplain", function()
  M.sendVisualQuick("explain")
end, { range = true })

vim.api.nvim_create_user_command("LLMImprove", function()
  M.sendVisualQuick("improve")
end, { range = true })

vim.api.nvim_create_user_command("LLMBugs", function()
  M.sendVisualQuick("bugs")
end, { range = true })

vim.api.nvim_create_user_command("LLMDocs", function()
  M.sendVisualQuick("docs")
end, { range = true })

-- ─   Keybinding Suggestions                             ──
-- Based on your existing mappings, here are recommended keybindings:

-- Main LLM visual selection bindings (using <c-g> prefix like your other AI maps)
vim.keymap.set('v', '<c-g>l', ':LLMMenu<CR>', { desc = 'LLM prompt menu' })
vim.keymap.set('v', '<c-g>lt', ':LLMTopic<CR>', { desc = 'LLM topic summary' })
vim.keymap.set('v', '<c-g>le', ':LLMExplain<CR>', { desc = 'LLM explain code' })
vim.keymap.set('v', '<c-g>li', ':LLMImprove<CR>', { desc = 'LLM suggest improvements' })
vim.keymap.set('v', '<c-g>lb', ':LLMBugs<CR>', { desc = 'LLM find bugs' })
vim.keymap.set('v', '<c-g>ld', ':LLMDocs<CR>', { desc = 'LLM generate docs' })

-- Alternative with <leader><c-g> prefix for less frequent operations
vim.keymap.set('v', '<leader><c-g>l', ':LLMVisual<CR>', { desc = 'LLM custom prompt' })
vim.keymap.set('v', '<leader><c-g>lg', ':LLMVisualGemini<CR>', { desc = 'LLM Gemini' })
vim.keymap.set('v', '<leader><c-g>lc', ':LLMVisualClaude<CR>', { desc = 'LLM Claude' })

-- ─^  Keybinding Suggestions                             ▲

return M

-- ─^  AI/LLM Integration Module                         ▲
