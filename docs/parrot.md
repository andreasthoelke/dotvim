# parrot.nvim Notes

Upstream: [frankroeder/parrot.nvim](https://github.com/frankroeder/parrot.nvim)
Local path: `plugged/parrot.nvim`
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
- Each provider also has a `model` (default) and `models` (list) field in the `require("parrot").setup()` call.
- Update both `PRESETS` and the provider config when adding a new model.

### OpenAI / GPT reasoning models
- `max_completion_tokens` must be large (currently 65536) - at high/xhigh reasoning effort, reasoning tokens consume the budget leaving nothing for visible output. Symptoms: request "completes" but no text appears.
- A custom `process_stdout` with debug logging is defined for the OpenAI provider - can be removed once stable.
- Reasoning effort toggle cycles: medium -> high -> xhigh -> medium.

### Anthropic / Claude
- Thinking is gated on `thinking_level == "high"` and model matching `opus%-4%-6` in `preprocess_payload`.

### Gemini
- Thinking level is passed via `generationConfig.thinkingConfig.thinkingLevel` in `preprocess_payload`.
