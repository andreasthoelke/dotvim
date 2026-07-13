# parrot.nvim Notes

Upstream: [frankroeder/parrot.nvim](https://github.com/frankroeder/parrot.nvim)
Runtime path: `~/.vim/plugged/parrot.nvim`
Mirror checkout: `plugged/parrot.nvim`
Config: `plugin/config/parrot.lua`

## Local patches (as of 2026-03-06, upstream at `34bff8b`)

This is a patched local fork - do not blindly pull from upstream.

- **Reverted advanced stop logic** (`bed2d12`, upstream PR #184): upstream replaced the simple `ChatHandler:stop()` with a complex buffer-targeted stop + cancellation system across `chat_handler.lua`, `pool.lua`, `queries.lua`, `response_handler.lua`, `preview_response_handler.lua`. Local keeps the simple version.
- **`15split` instead of `split`** in `open_buf` for the split target.
- **Custom `generate_chat_filename()`**: collision-safe filename generation (later upstreamed in `064b392` but local version predates it).
- **Cache behavior**: local diverges from upstream on `cache_expiry_hours` logic in `state.lua` and `multi_provider.lua`.

## Pulling from upstream

1. `git -C plugged/parrot.nvim fetch origin && git -C plugged/parrot.nvim log HEAD..origin/main --oneline`
2. Check for conflicts with the patched files listed above before merging.
3. Cherry-pick selectively rather than doing a full pull.

## Model config (`plugin/config/parrot.lua`)

### Updating models
- Model presets are in the `PRESETS` table.
- Providers declare their available models with `models`; some legacy provider entries also use a singular `model` default. Presets pin the actual startup selection.
- Update both `PRESETS` and the provider config when adding a new model.

### Prompt assembly debug
- In a Parrot chat buffer, `<c-w><leader><cr>` writes `.parrot-prompt-debug-*.md` to the current working directory without calling the model.
- The debug file includes the assembled messages and provider payload after context expansion, so it can be used to confirm exactly what `@file:`, `@folder:`, `@directory:`, and `@buffer:` references send to the API.
- Context tags can be used inline or as full-line commands. Inline tags are replaced in place with a relative-path header and the referenced content, preserving surrounding prose flow.
- The default `system_prompt` is intentionally blank. Both OpenAI providers also discard a per-chat `- system:` header by design; this setup uses ordinary user messages rather than privileged system/developer instructions.

### OpenAI / GPT reasoning models
- GPT-5.6 Sol via Chat Completions is the startup default, using `xhigh` reasoning.
- `:PrtReasoningXHigh` selects the regular `openai` provider (`/v1/chat/completions`) with flat `reasoning_effort = "xhigh"`.
- `:PrtReasoningMax` selects the separate `openai_responses` provider (`/v1/responses`) with nested `reasoning = { effort = "max" }`.
- The preset cycle contains Sol/xhigh, Sol/max, and the configured Claude max presets. Gemini remains available through `:PrtProvider`, but is intentionally not in the preset cycle.
- The Responses adapter is `lua/ai/openai_responses.lua`. It translates Parrot's `messages` payload to `input`, converts image blocks, maps token/reasoning fields, and parses `response.output_text.delta` SSE events.
- The Responses provider is stateless (`store = false`) because Parrot resends the complete visible transcript instead of chaining response IDs.
- Chat Completions currently rejects Sol `max` and reports `xhigh` as its highest supported value; do not put `max` in the regular `openai` provider.
- `ultra` is not an API reasoning level. It is a four-agent product mode; API developers need the Responses API multi-agent beta to build an ultra-like workflow.
- The token ceiling is 128000 (`max_completion_tokens` for Chat, `max_output_tokens` for Responses); reasoning tokens can otherwise consume the budget and leave nothing visible.
- The old raw-stream debug writer was removed. It was unbounded and could record prompt/output text. The existing `~/.local/share/nvim/parrot_openai_debug.log` is not deleted automatically, but no longer grows from Parrot requests.

### Anthropic / Claude
- The selectable Claude models use adaptive thinking in `preprocess_payload`.
- `thinking_level` is sent as `output_config.effort`; adaptive models use effort rather than budget tokens.
- Direct effort commands: `:PrtClaudeThinkingLow`, `:PrtClaudeThinkingHigh`, `:PrtClaudeThinkingXHigh`, `:PrtClaudeThinkingMax`.

### Gemini
- Thinking level is passed via `generationConfig.thinkingConfig.thinkingLevel` in `preprocess_payload`.
