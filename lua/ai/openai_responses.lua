-- OpenAI Responses API adapter for parrot.nvim's Chat-Completions-shaped
-- provider interface.  It deliberately lives outside the patched Parrot fork
-- so the regular OpenAI provider can remain on /v1/chat/completions.

local M = {}
local usage_by_model = {}
local last_usage = nil
local streamed_text_by_query = {}

local function trim(value)
	if type(value) ~= "string" then
		return value
	end
	return value:gsub("^%s*(.-)%s*$", "%1")
end

local function log(level, message)
	local ok, logger = pcall(require, "parrot.logger")
	if ok and type(logger[level]) == "function" then
		logger[level](message)
		return
	end

	if vim and vim.notify then
		local vim_level = vim.log and vim.log.levels and vim.log.levels.ERROR or nil
		vim.schedule(function()
			vim.notify(message, vim_level)
		end)
	end
end

local function error_message(err)
	if type(err) == "string" then
		return err
	end
	if type(err) ~= "table" then
		return tostring(err)
	end

	local message = err.message or err.code or err.type
	if message then
		return tostring(message)
	end

	local ok, encoded = pcall(vim.json.encode, err)
	return ok and encoded or vim.inspect(err)
end

local function normalize_image_block(block)
	local image_url = block.image_url
	local detail = block.detail

	-- Chat Completions represents image_url as { url = ..., detail = ... };
	-- Responses expects the URL itself on the input_image content item.
	if type(image_url) == "table" then
		detail = detail or image_url.detail
		image_url = image_url.url
	end

	if type(image_url) ~= "string" or image_url == "" then
		return nil
	end

	return {
		type = "input_image",
		image_url = image_url,
		detail = detail or "auto",
	}
end

local function assistant_content(content)
	if type(content) ~= "table" then
		return trim(content)
	end

	-- Parrot normally stores assistant history as a string.  Flatten any text
	-- blocks defensively because input_image is not valid assistant history.
	local text = {}
	for _, block in ipairs(content) do
		if type(block) == "string" then
			table.insert(text, block)
		elseif type(block) == "table" and type(block.text) == "string" then
			table.insert(text, block.text)
		end
	end
	return trim(table.concat(text, "\n"))
end

local function input_content(content)
	if type(content) ~= "table" then
		return trim(content)
	end

	local normalized = {}
	for _, block in ipairs(content) do
		if type(block) == "string" then
			table.insert(normalized, { type = "input_text", text = trim(block) })
		elseif type(block) == "table" then
			if block.type == "image_url" or block.type == "input_image" then
				local image = normalize_image_block(block)
				if image then
					table.insert(normalized, image)
				end
			elseif block.type == "text" or block.type == "input_text" then
				table.insert(normalized, { type = "input_text", text = trim(block.text or "") })
			elseif block.type == "input_file" or block.type == "input_audio" then
				table.insert(normalized, vim.deepcopy(block))
			elseif type(block.text) == "string" then
				table.insert(normalized, { type = "input_text", text = trim(block.text) })
			end
		end
	end

	return normalized
end

---Translate Parrot/Chat messages into Responses input messages.
---@param messages table
---@param opts? table
---@return table
function M.messages_to_input(messages, opts)
	opts = opts or {}
	local input = {}
	local valid_roles = {
		user = true,
		assistant = true,
		system = true,
		developer = true,
	}

	for _, message in ipairs(messages or {}) do
		local role = valid_roles[message.role] and message.role or "user"
		if not (opts.drop_system and role == "system") then
			local content = role == "assistant" and assistant_content(message.content) or input_content(message.content)
			table.insert(input, {
				role = role,
				content = content,
			})
		end
	end

	return input
end

---Translate the payload Parrot prepares for Chat Completions into a native
---Responses request. Unknown Responses-compatible fields are preserved.
---@param payload table
---@param opts? table
---@return table
function M.preprocess_payload(payload, opts)
	opts = opts or {}
	local translated = vim.deepcopy(payload)

	translated.input = M.messages_to_input(translated.messages, opts)
	translated.messages = nil

	local effort = translated.reasoning_effort or opts.reasoning_effort
	if effort then
		local reasoning = type(translated.reasoning) == "table" and translated.reasoning or {}
		reasoning.effort = effort
		translated.reasoning = reasoning
	end
	translated.reasoning_effort = nil

	if translated.max_output_tokens == nil and translated.max_completion_tokens ~= nil then
		translated.max_output_tokens = translated.max_completion_tokens
	end
	translated.max_completion_tokens = nil

	-- These are Chat Completions controls and are either unsupported or not
	-- useful for GPT-5.6-and-later reasoning requests through Responses.
	translated.temperature = nil
	translated.top_p = nil
	translated.presence_penalty = nil
	translated.frequency_penalty = nil
	translated.logprobs = nil
	translated.logit_bias = nil
	translated.top_logprobs = nil

	local is_gpt6 = type(translated.model) == "string" and translated.model:match("^gpt%-6")
	if is_gpt6 and type(translated.include) == "table" then
		local include = {}
		for _, value in ipairs(translated.include) do
			if value ~= "message.output_text.logprobs" then
				table.insert(include, value)
			end
		end
		translated.include = #include > 0 and include or nil
	end

	if opts.drop_system then
		-- Keep the user's intentional no-system-instructions policy even if a
		-- future config accidentally supplies the Responses `instructions` field.
		translated.instructions = nil
	end

	if opts.store ~= nil and translated.store == nil then
		translated.store = opts.store
	end

	return translated
end

local function query_key(query_id)
	-- Parrot supplies a unique query ID. The fallback keeps direct calls and
	-- non-Parrot consumers backwards-compatible, though they should be serial.
	return query_id ~= nil and tostring(query_id) or "__default"
end

local function content_key(item_id, output_index, content_index)
	if type(item_id) == "string" and item_id ~= "" then
		return item_id .. ":" .. tostring(content_index or 0)
	end
	return tostring(output_index or 0) .. ":" .. tostring(content_index or 0)
end

local function query_stream(query_id, create)
	local key = query_key(query_id)
	local stream = streamed_text_by_query[key]
	if not stream and create then
		stream = {}
		streamed_text_by_query[key] = stream
	end
	return stream, key
end

local function reset_stream(query_id)
	streamed_text_by_query[query_key(query_id)] = nil
end

-- `process_stdout` runs in libuv's fast-event context, where Vimscript
-- functions such as `vim.fn.strchars()` are forbidden. Count UTF-8 codepoints
-- in pure Lua by subtracting continuation bytes from the byte length.
local function utf8_char_count(text)
	local _, continuation_bytes = text:gsub("[\128-\191]", "")
	return #text - continuation_bytes
end

local function record_stream_text(query_id, key, text)
	if type(text) ~= "string" or text == "" then
		return nil
	end
	local stream = query_stream(query_id, true)
	stream[key] = (stream[key] or "") .. text
	return text
end

-- Done/item events contain a complete text snapshot. Return only the suffix
-- not already emitted by delta events, so they can safely recover a stream
-- whose deltas were absent without duplicating a normal stream.
local function recover_snapshot(query_id, key, text)
	if type(text) ~= "string" or text == "" then
		return nil
	end

	local stream = query_stream(query_id, true)
	local streamed = stream[key] or ""
	if streamed == "" then
		stream[key] = text
		return text
	end
	if text:sub(1, #streamed) ~= streamed then
		return nil
	end

	local missing = text:sub(#streamed + 1)
	stream[key] = text
	return missing ~= "" and missing or nil
end

local function recover_output_item(query_id, item, output_index)
	if type(item) ~= "table" or item.type ~= "message" then
		return nil
	end

	local chunks = {}
	local content_items = type(item.content) == "table" and item.content or {}
	for index, content in ipairs(content_items) do
		if type(content) == "table" then
			local text = nil
			if content.type == "output_text" and type(content.text) == "string" then
				text = content.text
			elseif content.type == "refusal" and type(content.refusal) == "string" then
				text = content.refusal
			end
			local recovered = recover_snapshot(query_id, content_key(item.id, output_index, index - 1), text)
			if recovered then
				table.insert(chunks, recovered)
			end
		end
	end
	local recovered = table.concat(chunks)
	return recovered ~= "" and recovered or nil
end

local function finish_stream(query_id, response)
	if type(response) ~= "table" then
		response = {}
	end

	local recovered_chunks = {}
	local output = type(response.output) == "table" and response.output or {}
	for index, item in ipairs(output) do
		local recovered = recover_output_item(query_id, item, index - 1)
		if recovered then
			table.insert(recovered_chunks, recovered)
		end
	end

	local stream = query_stream(query_id, false)
	local visible_chars = 0
	for _, text in pairs(stream or {}) do
		visible_chars = visible_chars + utf8_char_count(text)
	end

	local recovered = table.concat(recovered_chunks)
	return recovered ~= "" and recovered or nil, visible_chars
end

local function terminal_metadata(status, is_error)
	return {
		terminal = true,
		status = status,
		error = is_error == true,
	}
end

local function capture_usage(response)
	if type(response) ~= "table" or type(response.usage) ~= "table" then
		return nil
	end

	local usage = response.usage
	local input_details = type(usage.input_tokens_details) == "table" and usage.input_tokens_details or {}
	local output_details = type(usage.output_tokens_details) == "table" and usage.output_tokens_details or {}
	local captured = {
		response_id = response.id,
		model = response.model,
		status = response.status,
		input_tokens = usage.input_tokens or 0,
		cached_tokens = input_details.cached_tokens or 0,
		cache_write_tokens = input_details.cache_write_tokens or 0,
		output_tokens = usage.output_tokens or 0,
		reasoning_tokens = output_details.reasoning_tokens or 0,
		total_tokens = usage.total_tokens or 0,
		captured_at = os.time(),
	}

	last_usage = captured
	if type(captured.model) == "string" and captured.model ~= "" then
		usage_by_model[captured.model] = captured
	end
	return captured
end

---Return the latest Responses usage counters, optionally for a model. A prefix
---match handles APIs that return a dated model revision rather than the alias.
---@param model? string
---@return table|nil
function M.get_last_usage(model)
	if not model or model == "" then
		return last_usage and vim.deepcopy(last_usage) or nil
	end

	if usage_by_model[model] then
		return vim.deepcopy(usage_by_model[model])
	end

	local best = nil
	for response_model, usage in pairs(usage_by_model) do
		if response_model:sub(1, #model) == model and (not best or usage.captured_at > best.captured_at) then
			best = usage
		end
	end
	return best and vim.deepcopy(best) or nil
end

---@param usage table
---@return string
function M.format_usage(usage)
	local input_tokens = usage.input_tokens or 0
	local cached_tokens = usage.cached_tokens or 0
	local percentage = input_tokens > 0 and (cached_tokens / input_tokens * 100) or 0
	return string.format(
		"OpenAI Responses cache (%s; status %s): input %d, cache read %d (%.1f%%), cache write %d, output %d, reasoning %d, visible text %d chars",
		usage.model or "unknown model",
		usage.status or "unknown",
		input_tokens,
		cached_tokens,
		percentage,
		usage.cache_write_tokens or 0,
		usage.output_tokens or 0,
		usage.reasoning_tokens or 0,
		usage.visible_text_chars or 0
	)
end

local function decode_event(response)
	if type(response) ~= "string" or response == "" then
		return nil
	end

	local json = trim(response:gsub("^data:%s*", ""))
	if json == "" or json == "[DONE]" or json:match("^event:") then
		return nil
	end

	local ok, decoded = pcall(vim.json.decode, json)
	if not ok or type(decoded) ~= "table" then
		return nil
	end
	return decoded
end

---Extract visible text from Responses SSE events.
---@param response string
---@param query_id? string Parrot query ID used to isolate concurrent streams
---@return string|nil
function M.process_stdout(response, query_id)
	local decoded = decode_event(response)
	if not decoded then
		return nil
	end

	if decoded.error ~= nil and decoded.error ~= vim.NIL then
		reset_stream(query_id)
		log("error", "OpenAI Responses API error: " .. error_message(decoded.error))
		return nil, terminal_metadata("error", true)
	end

	if decoded.type == "response.created" then
		-- Query IDs are unique in Parrot, but resetting here also makes an
		-- explicitly reused ID start with clean reconciliation state.
		reset_stream(query_id)
		return nil
	end

	if decoded.type == "response.output_text.delta" and type(decoded.delta) == "string" then
		return record_stream_text(
			query_id,
			content_key(decoded.item_id, decoded.output_index, decoded.content_index),
			decoded.delta
		)
	end

	if decoded.type == "response.refusal.delta" and type(decoded.delta) == "string" then
		return record_stream_text(
			query_id,
			content_key(decoded.item_id, decoded.output_index, decoded.content_index),
			decoded.delta
		)
	end

	if decoded.type == "response.output_text.done" then
		return recover_snapshot(
			query_id,
			content_key(decoded.item_id, decoded.output_index, decoded.content_index),
			decoded.text
		)
	end

	if decoded.type == "response.refusal.done" then
		return recover_snapshot(
			query_id,
			content_key(decoded.item_id, decoded.output_index, decoded.content_index),
			decoded.refusal
		)
	end

	if decoded.type == "response.content_part.done" and type(decoded.part) == "table" then
		local text = decoded.part.type == "refusal" and decoded.part.refusal or decoded.part.text
		return recover_snapshot(
			query_id,
			content_key(decoded.item_id, decoded.output_index, decoded.content_index),
			text
		)
	end

	if decoded.type == "response.output_item.done" and type(decoded.item) == "table" then
		return recover_output_item(query_id, decoded.item, decoded.output_index)
	end

	if decoded.type == "error" then
		reset_stream(query_id)
		log("error", "OpenAI Responses stream error: " .. error_message(decoded))
		return nil, terminal_metadata("error", true)
	end

	if decoded.type == "response.failed" then
		local usage = capture_usage(decoded.response)
		local recovered, visible_chars = finish_stream(query_id, decoded.response)
		if usage then
			usage.visible_text_chars = visible_chars
		end
		local err = decoded.response and decoded.response.error or decoded
		log("error", "OpenAI Responses request failed: " .. error_message(err))
		return recovered, terminal_metadata("failed", true)
	end

	if decoded.type == "response.incomplete" then
		local usage = capture_usage(decoded.response)
		local recovered, visible_chars = finish_stream(query_id, decoded.response)
		if usage then
			usage.visible_text_chars = visible_chars
		end
		local details = decoded.response and decoded.response.incomplete_details or decoded.incomplete_details
		log("warning", "OpenAI Responses request incomplete: " .. error_message(details or "unknown reason"))
		return recovered, terminal_metadata("incomplete", true)
	end

	if decoded.type == "response.completed" and type(decoded.response) == "table" then
		local usage = capture_usage(decoded.response)
		local recovered, visible_chars = finish_stream(query_id, decoded.response)
		if usage then
			usage.visible_text_chars = visible_chars
		end
		return recovered, terminal_metadata("completed", false)
	end

	-- This also makes the adapter usable if streaming is disabled externally.
	if decoded.object == "response" then
		local usage = capture_usage(decoded)
		local recovered, visible_chars = finish_stream(query_id, decoded)
		if usage then
			usage.visible_text_chars = visible_chars
		end
		local failed = decoded.status ~= nil and decoded.status ~= "completed"
		return recovered, terminal_metadata(decoded.status or "completed", failed)
	end

	return nil
end

---Parrot always sends this provider with `stream = true`; stdout has already
---been handled event-by-event. Clear any state left by a malformed/truncated
---stream, and return nil to avoid replaying the Job's collected stdout.
---@param response string
---@param query_id? string
---@return string|nil
function M.process_onexit(_response, query_id)
	reset_stream(query_id)
	return nil
end

---Build a Parrot provider configuration backed by /v1/responses.
---@param opts table
---@return table
function M.provider(opts)
	assert(type(opts) == "table", "OpenAI Responses provider options are required")
	assert(type(opts.api_key) == "string" and opts.api_key ~= "", "OPENAI_API_KEY is required")
	assert(type(opts.models) == "table" and #opts.models > 0, "At least one Responses model is required")

	local effort = opts.reasoning_effort or "max"
	local max_output_tokens = opts.max_output_tokens or 128000
	local request_opts = {
		drop_system = opts.drop_system == true,
		reasoning_effort = effort,
		store = opts.store,
	}

	local config = {
		name = opts.name or "openai_responses",
		api_key = opts.api_key,
		endpoint = opts.endpoint or "https://api.openai.com/v1/responses",
		models = vim.deepcopy(opts.models),
		params = {
			chat = { max_output_tokens = max_output_tokens, reasoning_effort = effort },
			command = { max_output_tokens = max_output_tokens, reasoning_effort = effort },
		},
		headers = function(self)
			return {
				["Content-Type"] = "application/json",
				["Accept"] = "text/event-stream",
				["Authorization"] = "Bearer " .. self.api_key,
			}
		end,
		preprocess_payload = function(payload)
			if type(opts.prepare_payload) == "function" then
				local prepared = opts.prepare_payload(payload)
				if type(prepared) == "table" then
					payload = prepared
				end
			end
			return M.preprocess_payload(payload, request_opts)
		end,
		process_stdout = M.process_stdout,
		process_onexit = M.process_onexit,
	}

	if type(opts.topic) == "table" then
		config.topic = vim.deepcopy(opts.topic)
	end

	return config
end

return M
