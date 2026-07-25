# parrot.nvim Notes

Upstream: [frankroeder/parrot.nvim](https://github.com/frankroeder/parrot.nvim)
Runtime path: `~/.vim/plugged/parrot.nvim`
Mirror checkout: `plugged/parrot.nvim`
Config: `plugin/config/parrot.lua`

## Local patches (updated 2026-07-25; last compared with upstream at `34bff8b`)

This is a patched local fork - do not blindly pull from upstream.

- **Reverted advanced stop logic** (`bed2d12`, upstream PR #184): upstream replaced the simple `ChatHandler:stop()` with a complex buffer-targeted stop + cancellation system across `chat_handler.lua`, `pool.lua`, `queries.lua`, `response_handler.lua`, `preview_response_handler.lua`. Local keeps the simple version.
- **`15split` instead of `split`** in `open_buf` for the split target.
- **Custom `generate_chat_filename()`**: collision-safe filename generation (later upstreamed in `064b392` but local version predates it).
- **Cache behavior**: local diverges from upstream on `cache_expiry_hours` logic in `state.lua` and `multi_provider.lua`.
- **Protect active queries during cleanup**: long-running reasoning requests remain registered until curl exits; only completed query records older than the cleanup age can be removed.

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
- The `<c-w><cr>` respond shortcut is intentionally mapped only in normal and insert mode. Parrot interprets a visual-mode invocation as a ranged request and sends only the selected chat lines; use an explicit ranged `:PrtChatRespond` only when that behavior is intended.

### OpenAI / GPT reasoning models
- GPT-5.6 Sol via Chat Completions is the startup default, using `xhigh` reasoning.
- `:PrtReasoningXHigh` selects the regular `openai` provider (`/v1/chat/completions`) with flat `reasoning_effort = "xhigh"`.
- `:PrtReasoningMax` selects the separate `openai_responses` provider (`/v1/responses`) with nested `reasoning = { effort = "max" }`.
- The preset cycle contains Sol/xhigh, Sol/max, and the configured Claude max presets. Gemini remains available through `:PrtProvider`, but is intentionally not in the preset cycle.
- The Responses adapter is `lua/ai/openai_responses.lua`. It translates Parrot's `messages` payload to `input`, converts image blocks, maps token/reasoning fields, and parses `response.output_text.delta` SSE events.
- The adapter also reconciles `output_text.done`, `output_item.done`, and terminal response snapshots, recovering visible text when a stream omits deltas without duplicating normal delta output. Reconciliation is isolated by Parrot query ID so simultaneous chats cannot share stream state. `response.completed`, `response.incomplete`, and `response.failed` are authoritative job boundaries: Parrot finalizes curl when one arrives instead of waiting forever for a delayed EOF. A genuinely textless request now warns and removes the pending assistant marker, restoring the user turn for a clean retry instead of silently appending another user turn.
- The Responses provider is stateless (`store = false`) because Parrot resends the complete visible transcript instead of chaining response IDs. Stateless requests still qualify for OpenAI prompt caching.
- Chat Completions currently rejects Sol `max` and reports `xhigh` as its highest supported value; do not put `max` in the regular `openai` provider.
- `ultra` is not an API reasoning level. It is a four-agent product mode; API developers need the Responses API multi-agent beta to build an ultra-like workflow.
- The token ceiling is 128000 (`max_completion_tokens` for Chat, `max_output_tokens` for Responses); reasoning tokens can otherwise consume the budget and leave nothing visible.
- The old raw-stream debug writer was removed. It was unbounded and could record prompt/output text. The existing `~/.local/share/nvim/parrot_openai_debug.log` is not deleted automatically, but no longer grows from Parrot requests.

### Caches and Responses state
- The startup `Updating model cache` notices are only Parrot refreshing provider model-ID lists. The local config refreshes those lists every 30 days (`model_cache_expiry_hours = 720`); this is unrelated to inference or prompt caching.
- OpenAI prompt caching applies automatically to eligible exact prefixes of at least 1024 tokens. GPT-5.6 cache writes cost more than uncached input, while cache reads reduce cost and latency.
- Sol/max chat requests include a stable `prompt_cache_key` derived from a hash of the chat file path. This improves cache routing without sending the local path, and exact-prefix matching prevents stale cache reuse after an earlier message is edited.
- The default implicit breakpoint is used for chats, which suits Parrot's append-only full-transcript payload. One-off commands and Luna topic summaries use explicit mode with no breakpoints, disabling cache writes that are unlikely to be reused.
- `:PrtResponsesCacheStatus` shows the latest Sol request's API status, input, cache-read, cache-write, output, and reasoning token counts, plus the number of visible response characters Parrot received. These statistics are session-local and become available after a terminal Responses event.
- Response-ID chaining and persisted reasoning are intentionally not enabled. They do not remove billing for prior input, would retain response objects server-side for 30 days, and need transcript-fingerprint invalidation for edited/retried/branched Markdown chats. The current setup keeps the Markdown transcript authoritative and `store = false`.

### Anthropic / Claude
- The selectable Claude models use adaptive thinking in `preprocess_payload`.
- `thinking_level` is sent as `output_config.effort`; adaptive models use effort rather than budget tokens.
- The preset cycle orders Claude Opus 4.8/max, Claude Opus 5/max, then Claude Fable 5/max. Opus 5 uses API model ID `claude-opus-5`; `max` is its highest reasoning effort and the 128k output ceiling leaves room for thinking plus visible text.
- Anthropic requests retry standard transient HTTP failures twice, including 429 throttling and common 5xx responses. Provider errors are recorded on their own query, and a recovered attempt clears that error when visible text arrives, so parallel requests do not leak failure state into one another or misreport an API error as a textless successful response.
- Direct effort commands: `:PrtClaudeThinkingLow`, `:PrtClaudeThinkingHigh`, `:PrtClaudeThinkingXHigh`, `:PrtClaudeThinkingMax`.

### Gemini
- Thinking level is passed via `generationConfig.thinkingConfig.thinkingLevel` in `preprocess_payload`.
