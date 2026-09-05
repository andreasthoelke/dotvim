# parrot.nvim Notes

Upstream: [frankroeder/parrot.nvim](https://github.com/frankroeder/parrot.nvim)
Runtime path: `~/.vim/plugged/parrot.nvim`
Mirror checkout: `plugged/parrot.nvim`
Config: `plugin/config/parrot.lua`

## Local patches (updated 2026-07-26; last compared with upstream at `34bff8b`)

This is a patched local fork - do not blindly pull from upstream.

- **Reverted advanced stop logic** (`bed2d12`, upstream PR #184): upstream replaced the simple `ChatHandler:stop()` with a complex buffer-targeted stop + cancellation system across `chat_handler.lua`, `pool.lua`, `queries.lua`, `response_handler.lua`, `preview_response_handler.lua`. Local keeps the simple version.
- **`15split` instead of `split`** in `open_buf` for the split target.
- **Custom `generate_chat_filename()`**: collision-safe filename generation (later upstreamed in `064b392` but local version predates it).
- **Cache behavior**: local diverges from upstream on `cache_expiry_hours` logic in `state.lua` and `multi_provider.lua`.
- **Protect active queries during cleanup** (`3cc0ee0`): long-running reasoning requests remain registered until curl exits; only completed query records older than the cleanup age can be removed.
- **Per-query stream state** (`3cc0ee0`): provider stream handlers receive the Parrot query ID so simultaneous chats cannot share response reconciliation state.
- **Terminal and empty-response recovery** (`3cc0ee0`): terminal Responses events finalize their curl job; a genuinely textless response removes the pending assistant marker and restores the user turn for retry.
- **Safe attached-context fences** (`7a27fa3`): `@file:`, `@buffer:`, and directory attachments use an outer backtick fence longer than every backtick run inside the attachment. Markdown files containing their own fenced code blocks therefore remain one bounded context block.

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
- Attached context is rendered as a named fenced block at the position of the tag. Put long `@file:`/`@folder:` references before the actual instruction when task adherence matters, so the expanded payload ends with the task rather than with source prose that resembles a document continuation.
- The context renderer dynamically lengthens its outer backtick fence when the attached content contains backticks. Do not simplify it back to a fixed triple-backtick fence: Markdown attachments commonly contain triple-backtick blocks of their own.
- The default `system_prompt` is intentionally blank. Both OpenAI providers also discard a per-chat `- system:` header by design; this setup uses ordinary user messages rather than privileged system/developer instructions.
- The `<c-w><cr>` respond shortcut is intentionally mapped only in normal and insert mode. Parrot interprets a visual-mode invocation as a ranged request and sends only the selected chat lines; use an explicit ranged `:PrtChatRespond` only when that behavior is intended.

### OpenAI / GPT reasoning models
- GPT-6 Astra (`gpt-6-astra`) is integrated through the Responses API at `max`, its highest reasoning level. `:PrtReasoningMax` and `:PrtGPT6Max` select it.
- This API key still returned `model_not_found` for Astra on 2026-09-04 during the staged rollout, so GPT-5.6 Sol via Chat Completions remains the non-breaking startup default at `xhigh` for now.
- `:PrtSolMax` selects Sol through the separate `openai_responses` provider with nested `reasoning = { effort = "max" }`; `:PrtReasoningXHigh` selects the regular `openai` provider with flat `reasoning_effort = "xhigh"`.
- The preset cycle contains Sol/xhigh, Astra/max, Sol/max, Gemini 3.8 Flash/high, and the configured Fable presets.
- The Responses adapter is `lua/ai/openai_responses.lua`. It translates Parrot's `messages` payload to `input`, converts image blocks, maps token/reasoning fields, and parses `response.output_text.delta` SSE events.
- The adapter also reconciles `output_text.done`, `output_item.done`, and terminal response snapshots, recovering visible text when a stream omits deltas without duplicating normal delta output. Reconciliation is isolated by Parrot query ID so simultaneous chats cannot share stream state. `response.completed`, `response.incomplete`, and `response.failed` are authoritative job boundaries: Parrot finalizes curl when one arrives instead of waiting forever for a delayed EOF. A genuinely textless request now warns and removes the pending assistant marker, restoring the user turn for a clean retry instead of silently appending another user turn.
- The Responses provider is stateless (`store = false`) because Parrot resends the complete visible transcript instead of chaining response IDs. Stateless requests still qualify for OpenAI prompt caching.
- Astra supports `low`, `medium`, `high`, `xhigh`, and `max`; it does not support `none`. Chat Completions is supported, but Astra tool calling requires Responses. Parrot has no agent/tool loop, so this integration intentionally uses the model's single-agent `max` reasoning path.
- Chat Completions currently rejects Sol `max` and reports `xhigh` as its highest supported value; do not put `max` in the regular `openai` provider. GPT-6 Chat requests also remove `temperature`, `top_p`, and log-probability controls as required by the API.
- The token ceiling is 128000 (`max_completion_tokens` for Chat, `max_output_tokens` for Responses); reasoning tokens can otherwise consume the budget and leave nothing visible.
- The old raw-stream debug writer was removed. It was unbounded and could record prompt/output text. The existing `~/.local/share/nvim/parrot_openai_debug.log` is not deleted automatically, but no longer grows from Parrot requests.

### Caches and Responses state
- The startup `Updating model cache` notices are only Parrot refreshing provider model-ID lists. The local config refreshes those lists every 30 days (`model_cache_expiry_hours = 720`); this is unrelated to inference or prompt caching.
- OpenAI prompt caching applies to eligible exact prefixes of at least 1024 tokens on GPT-5.6 and later. Cache writes cost more than uncached input, while cache reads reduce cost and latency.
- Astra/max and Sol/max chat requests include a stable `prompt_cache_key` derived from a hash of the chat file path. This improves cache routing without sending the local path, and exact-prefix matching prevents stale cache reuse after an earlier message is edited.
- The default implicit breakpoint is used for chats, which suits Parrot's append-only full-transcript payload. One-off commands and Luna topic summaries use explicit mode with no breakpoints, disabling cache writes that are unlikely to be reused.
- `:PrtResponsesCacheStatus` shows the latest Astra or Sol Responses request's API status, input, cache-read, cache-write, output, and reasoning token counts, plus the number of visible response characters Parrot received. These statistics are session-local and become available after a terminal Responses event.
- Response-ID chaining and persisted reasoning are intentionally not enabled. They do not remove billing for prior input, would retain response objects server-side for 30 days, and need transcript-fingerprint invalidation for edited/retried/branched Markdown chats. The current setup keeps the Markdown transcript authoritative and `store = false`.

### Anthropic / Claude
- The selectable Claude models use adaptive thinking in `preprocess_payload`.
- `thinking_level` is sent as `output_config.effort`; adaptive models use effort rather than budget tokens.
- The preset cycle includes Claude Opus 4.6/max, Claude Opus 5/max, and Claude Fable 5.1/max. Anthropic curl-level retries remain disabled because retrying a streaming request below Parrot's query lifecycle can concatenate or misclassify attempts.
- `max` and `xhigh` requests use a 64k `max_tokens` ceiling. Anthropic counts hidden thinking and visible response text together against this hard limit and recommends 64k as a starting point for deep-effort runs. `effort = "max"` remains the highest reasoning setting; the ceiling bounds total output rather than lowering the effort signal. See the official [effort](https://platform.claude.com/docs/en/build-with-claude/effort) and [adaptive thinking](https://platform.claude.com/docs/en/build-with-claude/adaptive-thinking) documentation.
- Direct effort commands: `:PrtClaudeThinkingLow`, `:PrtClaudeThinkingHigh`, `:PrtClaudeThinkingXHigh`, `:PrtClaudeThinkingMax`.

### Fable 5 investigation (2026-07-26)

Observed local chat buffers:

- `~/.local/share/nvim/parrot/chats/2026-07-26.nkf6.md`: Fable/max answered an inline 16kB design document as a shallow continuation.
- `~/.local/share/nvim/parrot/chats/2026-07-26.ifnu.md`: another inline run continued author-like prose for more than six minutes until stopped.
- `~/.local/share/nvim/parrot/chats/2026-07-26.l6ql.md`: the behavior persisted after removing Opus 5 and Anthropic curl retries. The prompt's only instruction was at the beginning, while its final tokens were a short, continuation-shaped Markdown table.
- `~/.local/share/nvim/parrot/chats/2026-07-26.cmn4.md`: loading nearly the same material through `@file:docs/57-brief.md` produced a coherent, grounded response after a normal thinking delay. The attachment was labeled and fenced, and that source version omitted the dangling final table.
- `~/.local/share/nvim/parrot/chats/2026-07-26.xs2z.md`: Opus 5/max answered the original inline material well, showing that stronger instruction following could recover the distant task even when the prompt boundary was weak.

Conclusions and handoff guidance:

- The buffer role markers, UTF-8 encoding, and Markdown fences were valid. Parrot sent one user message, no system prompt, and the expected `claude-fable-5` payload with adaptive thinking plus `output_config.effort = "max"`.
- Fast visible output is not proof that `max` was lost. Effort is a behavioral signal; a continuation-shaped prompt can still make Fable immediately continue source prose. The former 128k output ceiling then gave that mistaken trajectory excessive room.
- The Opus 5 model entry did not cause the Fable behavior: the failure reproduced while Opus 5 was removed, and Opus 5 is now restored without curl-level retries.
- For long reference material, use a fresh chat, put context tags first, and place a specific task after them. Explicitly say that attached material is reference context rather than text to continue. State the desired abstraction level, limits, tradeoffs, and response structure when quality matters.
- Do not retry a failed streaming Anthropic request inside curl. A future automatic retry should be application-level, use a new query lifecycle, and occur only when the failed attempt produced no visible content. Never append two transport attempts into one assistant turn.
- When investigating prompt assembly, use the prompt-debug shortcut instead of issuing a paid request. Do not reuse a malformed assistant turn in the next test because Parrot will correctly send it back as assistant history.

### Gemini
- Thinking level is passed via `generationConfig.thinkingConfig.thinkingLevel` in `preprocess_payload`.
- Gemini 3.8 Flash is the Gemini default and a `high`-thinking preset. It supports `low`, `medium`, and `high` (`medium` is the API default); `minimal` is rejected.
- Gemini 3.8 requests omit the deprecated `temperature`, `top_p`, and `top_k` sampling controls and use the model's 65,536-token output limit.
