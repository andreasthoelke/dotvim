# Parrot.nvim Issues & Open Questions

## Date: 2025-11-15

### 1. Model Picker Not Saving Full Model Names

**Issue:** When using the model picker (`:PrtChatModel` or keybind) to select "gpt-5.1", the model is saved as "gpt-5" in the persisted state file instead of "gpt-5.1".

**Evidence:**
- User selected "gpt-5.1" from the model picker
- State file showed `"chat_model":"gpt-5"` instead of `"chat_model":"gpt-5.1"`
- Both "gpt-5" and "gpt-5.1" exist as separate entries in the cached models list from OpenAI's API

**Possible Causes:**
1. OpenAI's API might return models with display name "gpt-5.1" but ID "gpt-5"
2. Model name normalization happening in the selection/save process
3. Bug in how model names are extracted from online model list
4. String matching or truncation in the model selection code

**Impact:** Users cannot reliably select newer model versions through the UI - must manually edit state file

**Workaround:** Manually edit `~/.local/share/nvim/parrot/persisted/state.json` to set the correct model name

**Files Involved:**
- `plugged/parrot.nvim/lua/parrot/chat_handler.lua` - model selection logic
- `plugged/parrot.nvim/lua/parrot/state.lua` - state persistence
- `~/.local/share/nvim/parrot/persisted/state.json` - persisted state

---

### 2. State File Overrides Config Defaults (By Design, But Poorly Documented)

**Issue:** The persisted state file (`state.json`) overrides config file defaults for model selection. When users update their config with new models, the old selection persists.

**Behavior:**
- Config file specifies `model = "gpt-5.1"`
- State file contains `"chat_model":"gpt-5"`
- State file takes precedence → user sees "gpt-5" despite config update

**Impact:** Confusing UX - updating config doesn't seem to work

**Expected Behavior (Unclear):**
- Should config updates reset state?
- Should there be a warning when state differs from config?
- Should there be an easier way to reset to config defaults?

**Workaround:** Delete state file or manually edit it

---

### 3. Separate Chat vs Command Model Settings Not Obvious

**Issue:** The plugin maintains separate model selections for `chat_model` and `command_model`, but this distinction isn't clear in the UI or documentation.

**Example from our debugging:**
- `command_model` was correctly set to "gpt-5.1"
- `chat_model` was set to "gpt-5"
- Only chat interactions showed the old model

**Questions:**
- When using `:PrtChatModel`, which model does it update?
- Is there a separate command to update `command_model`?
- Should these be unified or is the separation intentional?

---

## Recommendations for Plugin Maintainers

1. **Investigate model name saving logic** - Why does "gpt-5.1" become "gpt-5"?
2. **Add state inspection command** - e.g., `:PrtShowState` to see current vs config models
3. **Add state reset command** - e.g., `:PrtResetState` to clear persisted state
4. **Improve documentation** - Explain state file precedence and chat vs command models
5. **Consider warning on model mismatch** - Alert when state differs from config default

---

## Investigation Notes

### Code Locations Examined:
- `plugged/parrot.nvim/lua/parrot/state.lua:164` - `State:get_model()` function
- `plugged/parrot.nvim/lua/parrot/chat_handler.lua:237` - `ChatHandler:get_model()` function
- `plugged/parrot.nvim/lua/parrot/chat_handler.lua:1160` - `ChatHandler:switch_model()` function

### Debugging Approach Used:
- Added logging to trace model name through the call chain
- Confirmed model name is correctly "gpt-5.1" at config level
- Found state file returning "gpt-5" for chat_model
- Manually editing state file resolved the display issue

### State File Location:
`~/.local/share/nvim/parrot/persisted/state.json`

### State File Structure:
```json
{
  "openai": {
    "chat_model": "model-name-here",
    "command_model": "model-name-here",
    "cached_models": { ... }
  },
  ...
}
```

---

## 2025-11-16 Update — gpt-5.1 Pin + UX Playbook

### Confusions Resolved
- The UI showed **gpt-5** because `state.json` kept the previous `chat_model` even after updating the config. This is expected behavior in Parrot (state > config) but it was undocumented for us.
- Selecting `gpt-5.1` in the picker did work, yet the persisted value was truncated back to `gpt-5`, so every restart silently reverted to the old model.
- We now call `pin_openai_models("gpt-5.1")` right after `require("parrot").setup(...)`. On startup it patches both the in-memory state and `state.json` so chat+command always report `gpt-5.1` unless we deliberately change them.
- OpenAI lacked a topic model, so `# topic: ?` stayed empty. We now assign `gpt-4o-mini` as the dedicated `topic.model` for the OpenAI provider, so topic summaries fill in regardless of the active provider (and the second spinner was removed to avoid double progress messages).
- Chat buffers previously showed `⌘:[gpt-5.1 - openai]` only after the first response. We hooked Parrot's label rendering so it now displays `⌘:[gpt-5.1:M]` directly in each assistant block, dropping the redundant provider name.

### Ideal Settings (2025-11-16)
- `OPENAI_PRIMARY_MODEL = "gpt-5.1"` – edit once and reuse across the config.
- Both chat + command use `reasoning_effort = "medium"` by default via `OPENAI_REASONING_DEFAULT`, giving a smart baseline that can still burst to high when needed.
- Anthropic topic model: `claude-haiku-4-5-20251001` for lightweight summaries.
- Keep `model_cache_expiry_hours = 48`; run `:PrtReloadCache openai` if OpenAI adds a newer build and the picker feels stale.

### UX + Ops Checklist
- To verify the active model, run `:PrtStatus` (or `lua =require('parrot').get_status_info()`). The OpenAI entry now appends `:M` or `:H` (one-letter indicator) after the model name to reflect the current reasoning effort.
- Topic summaries populate for both Anthropic and OpenAI sessions (OpenAI now uses `gpt-4o-mini` for the short prompt), so `# topic:` updates once a response lands without manual edits or an extra spinner.
- The persisted file lives at `~/.local/share/nvim/parrot/persisted/state.json`. If we need a clean slate, delete or archive it before reopening Neovim (remember Parrot will recreate it).
- Model picker commands:
  - `:PrtChatModel` updates chat mode.
  - `:PrtModel` in a non-chat buffer updates the command model.
  - Both are now safe to use; the pin reruns on startup to keep defaults aligned.
- Reasoning effort quick toggles:
  - `:PrtReasoningMedium` returns to the default smart mode.
  - `:PrtReasoningHigh` or `:PrtReasoningToggle` temporarily boosts GPT-5.1 into the highest reasoning tier for both chat + command.
  - The boost status is visible via `:PrtStatus` and automatically logged.
- If we ever want to temporarily test another OpenAI model, set it via the picker; once finished, restart (or run the helper manually) to repin to gpt-5.1.
- Log entries appear at **debug** level when the helper overwrites the persisted value—enable Parrot logging if you need confirmation.
