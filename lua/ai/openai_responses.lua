-- OpenAI Responses API adapter for parrot.nvim's Chat-Completions-shaped
-- provider interface.  It deliberately lives outside the patched Parrot fork
-- so the regular OpenAI provider can remain on /v1/chat/completions.

local M = {}

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
	-- useful for GPT-5.6 reasoning requests through Responses.
	translated.temperature = nil
	translated.top_p = nil
	translated.presence_penalty = nil
	translated.frequency_penalty = nil
	translated.logprobs = nil
	translated.logit_bias = nil
	translated.top_logprobs = nil

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

local function collect_output_text(response)
	local chunks = {}
	for _, item in ipairs(response.output or {}) do
		if item.type == "message" then
			for _, content in ipairs(item.content or {}) do
				if content.type == "output_text" and type(content.text) == "string" then
					table.insert(chunks, content.text)
				elseif content.type == "refusal" and type(content.refusal) == "string" then
					table.insert(chunks, content.refusal)
				end
			end
		end
	end
	return table.concat(chunks)
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
---@return string|nil
function M.process_stdout(response)
	local decoded = decode_event(response)
	if not decoded then
		return nil
	end

	if decoded.error then
		log("error", "OpenAI Responses API error: " .. error_message(decoded.error))
		return nil
	end

	if decoded.type == "response.output_text.delta" and type(decoded.delta) == "string" then
		return decoded.delta
	end

	if decoded.type == "response.refusal.delta" and type(decoded.delta) == "string" then
		return decoded.delta
	end

	if decoded.type == "error" then
		log("error", "OpenAI Responses stream error: " .. error_message(decoded))
		return nil
	end

	if decoded.type == "response.failed" then
		local err = decoded.response and decoded.response.error or decoded
		log("error", "OpenAI Responses request failed: " .. error_message(err))
		return nil
	end

	if decoded.type == "response.incomplete" then
		local details = decoded.response and decoded.response.incomplete_details or decoded.incomplete_details
		log("warning", "OpenAI Responses request incomplete: " .. error_message(details or "unknown reason"))
		return nil
	end

	-- This also makes the adapter usable if streaming is disabled externally.
	if decoded.object == "response" then
		local text = collect_output_text(decoded)
		return text ~= "" and text or nil
	end

	return nil
end

---Parrot always sends this provider with `stream = true`; stdout has already
---been handled event-by-event. Returning nil avoids replaying output or errors
---from the Job object's collected stdout during its exit callback.
---@param response string
---@return string|nil
function M.process_onexit(_response)
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
