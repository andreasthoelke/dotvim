# AI/LLM Integration for Neovim

## Overview
This module provides seamless integration with various LLM providers (OpenAI, Anthropic, Gemini, LiteLLM) directly from Neovim.

## Features
- Send visual selections to LLMs with custom prompts
- Predefined prompt templates for common tasks
- Prompt selection menu for quick access
- Support for multiple providers (OpenAI, Anthropic, Gemini, LiteLLM)
- Async execution (non-blocking)
- Results displayed in floating windows
- Interactive and non-interactive modes
- Extensible prompt system

## Setup

### 1. Environment Variables
Set your API keys in your shell configuration (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
export OPENAI_API_KEY="your-openai-key"
export ANTHROPIC_API_KEY="your-anthropic-key"
export GEMINI_API_KEY="your-gemini-key"
# Optional: for local LiteLLM
export LITELLM_BASE_URL="http://localhost:4000"
export LITELLM_API_KEY="your-litellm-key"
```

### 2. Default Provider
The default provider is OpenAI. You can change it:
```bash
export PROVIDER=gemini  # or anthropic, litellm
```

## Usage

### Commands

#### Quick Access Commands (Visual Mode)
- `:LLMMenu` - Show prompt selection menu
- `:LLMTopic` - Generate topic summary
- `:LLMExplain` - Explain selected code
- `:LLMImprove` - Suggest improvements
- `:LLMBugs` - Find potential bugs
- `:LLMDocs` - Generate documentation

#### Provider-Specific Commands
- `:LLMVisual [prompt]` - Send to default provider
- `:LLMVisualGemini [prompt]` - Send to Gemini
- `:LLMVisualClaude [prompt]` - Send to Claude/Anthropic

If no prompt is provided, you'll be prompted interactively.

### Recommended Keybindings

These keybindings follow your existing `<c-g>` pattern for AI features:

```lua
-- Main LLM bindings with <c-g>l prefix
vim.keymap.set('v', '<c-g>l', ':LLMMenu<CR>', { desc = 'LLM prompt menu' })
vim.keymap.set('v', '<c-g>lt', ':LLMTopic<CR>', { desc = 'LLM topic summary' })
vim.keymap.set('v', '<c-g>le', ':LLMExplain<CR>', { desc = 'LLM explain code' })
vim.keymap.set('v', '<c-g>li', ':LLMImprove<CR>', { desc = 'LLM improvements' })
vim.keymap.set('v', '<c-g>lb', ':LLMBugs<CR>', { desc = 'LLM find bugs' })
vim.keymap.set('v', '<c-g>ld', ':LLMDocs<CR>', { desc = 'LLM generate docs' })

-- Alternative with <leader><c-g> for custom prompts
vim.keymap.set('v', '<leader><c-g>l', ':LLMVisual<CR>', { desc = 'LLM custom prompt' })
vim.keymap.set('v', '<leader><c-g>lg', ':LLMVisualGemini<CR>', { desc = 'LLM Gemini' })
vim.keymap.set('v', '<leader><c-g>lc', ':LLMVisualClaude<CR>', { desc = 'LLM Claude' })
```

### Available Prompt Templates

| Key | Name | Description |
|-----|------|-------------|
| `topic` | Topic Summary | Concise topic summary (default for markdown/text) |
| `explain` | Explain Code | Clear explanation of what code does |
| `improve` | Suggest Improvements | Readability, performance, best practices |
| `bugs` | Find Bugs | Identify potential bugs and edge cases |
| `refactor` | Refactor Suggestions | Maintainability improvements |
| `docs` | Generate Documentation | JSDoc, docstrings, etc. |
| `comment` | Add Comments | Inline comments for complex parts |
| `translate` | Translate Comments | Translate to English |
| `simplify` | Simplify Code | Rewrite for readability |
| `typescript` | Convert to TypeScript | Add type annotations |
| `tests` | Generate Tests | Unit tests with edge cases |
| `testcases` | Test Cases | List of test scenarios |
| `complexity` | Complexity Analysis | Time/space complexity |
| `security` | Security Review | Find vulnerabilities |
| `performance` | Performance Analysis | Optimization opportunities |

### Lua API

```lua
local ai = require('ai')

-- Send text directly
ai.sendToLLM("Hello, world!", "Translate to Spanish", "gemini")

-- Send visual selection with prompt
ai.sendVisualToLLM("Explain this code", "openai")

-- Interactive mode (prompts for input)
ai.sendVisualToLLMInteractive("anthropic")

-- Show prompt selection menu
ai.sendVisualWithMenu()

-- Use predefined prompt
ai.sendVisualQuick("explain")  -- Uses the explain prompt template

-- Add custom prompts
ai.prompts.myPrompt = {
  name = "My Custom Prompt",
  prompt = "Do something specific with this text",
  provider = "gemini"
}
```

### Extending Prompts

Edit `plugin/utils/ai-prompts.lua` to:
- Add new prompt templates
- Set filetype-specific defaults
- Create command aliases

Example:
```lua
-- Add new prompt
ai.prompts.review = {
  name = "Code Review",
  prompt = "Perform a thorough code review",
  provider = "anthropic"
}

-- Create quick command
vim.api.nvim_create_user_command("R", function()
  require('ai').sendVisualQuick("review")
end, { range = true })
```

## Examples

### Example 1: Explain Code
1. Select a function in visual mode
2. `:LLMVisual Explain this function and suggest improvements`

### Example 2: Generate Documentation
1. Select code
2. `:LLMVisual Generate JSDoc comments for this function`

### Example 3: Find Bugs
1. Select suspicious code
2. `:LLMVisualClaude Find potential bugs in this code`

### Example 4: Translate Comments
1. Select code with comments
2. `:LLMVisualGemini Translate the comments to English`

## Bash Script Usage

The underlying `llm-text.sh` script can be used standalone:

```bash
# Basic usage
./plugin/utils/llm-text.sh "Your text" "Your prompt"

# With specific provider
PROVIDER=gemini ./plugin/utils/llm-text.sh "Code here" "Review this"

# With custom temperature
TEMPERATURE=0.5 ./plugin/utils/llm-text.sh "Text" "Summarize"
```

## Troubleshooting

### API Key Issues
- Ensure API keys are exported in your shell
- Test with: `echo $OPENAI_API_KEY`

### Script Permissions
The script should be automatically made executable, but if needed:
```bash
chmod +x ~/.config/nvim/plugin/utils/llm-text.sh
```

### Floating Window Issues
Ensure you have the required floating window utilities loaded in your Neovim config.

### Provider-Specific Issues
- **OpenAI**: Check API quota and rate limits
- **Anthropic**: Ensure you're using the correct API version
- **Gemini**: Verify API key has proper permissions
- **LiteLLM**: Ensure the server is running at the specified URL

## Models
Default models can be changed via environment variables:
```bash
export OPENAI_MODEL="gpt-4"
export ANTHROPIC_MODEL="claude-3-opus-20240229"
export GEMINI_MODEL="gemini-1.5-pro"
export LITELLM_MODEL="custom-model"
```
