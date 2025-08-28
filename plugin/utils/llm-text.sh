#!/usr/bin/env bash
# llm-text: send text content + prompt to a cloud LLM, print answer.
set -euo pipefail

# Provider: openai | anthropic | gemini | litellm
: "${PROVIDER:=openai}"

# Models
: "${OPENAI_MODEL:=gpt-5-mini}"
: "${ANTHROPIC_MODEL:=claude-3-5-haiku-latest}"
: "${GEMINI_MODEL:=gemini-1.5-flash}"
: "${LITELLM_MODEL:=gpt-4o-mini}"

# Keys / endpoints
OPENAI_API_KEY="${OPENAI_API_KEY:-}"
ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}"
GEMINI_API_KEY="${GEMINI_API_KEY:-}"
LITELLM_API_KEY="${LITELLM_API_KEY:-}"
: "${LITELLM_BASE_URL:=http://localhost:4000}"

# Temperature
: "${TEMPERATURE:=1}"

usage() { 
  echo "Usage: llm-text \"<text_content>\" \"<prompt>\""
  echo "  Environment variables:"
  echo "    PROVIDER=openai|anthropic|gemini|litellm (default: openai)"
  exit 1
}

[[ $# -eq 2 ]] || usage

TEXT_CONTENT="$1"
PROMPT="$2"

# Build the combined message
FULL_MESSAGE="Context:
$TEXT_CONTENT

Task:
$PROMPT"

# Function to call OpenAI API
call_openai() {
  local response
  response=$(curl -s https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "$(jq -n \
      --arg model "$OPENAI_MODEL" \
      --arg content "$FULL_MESSAGE" \
      --argjson temp "$TEMPERATURE" \
      '{model: $model, messages: [{role: "user", content: $content}], temperature: $temp}')")
  
  echo "$response" | jq -r '.choices[0].message.content // .error.message // "Error: Invalid response"'
}

# Function to call Anthropic API
call_anthropic() {
  local response
  response=$(curl -s https://api.anthropic.com/v1/messages \
    -H "Content-Type: application/json" \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -d "$(jq -n \
      --arg model "$ANTHROPIC_MODEL" \
      --arg content "$FULL_MESSAGE" \
      --argjson temp "$TEMPERATURE" \
      '{model: $model, max_tokens: 4096, messages: [{role: "user", content: $content}], temperature: $temp}')")
  
  echo "$response" | jq -r '.content[0].text // .error.message // "Error: Invalid response"'
}

# Function to call Gemini API
call_gemini() {
  local response
  response=$(curl -s "https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${GEMINI_API_KEY}" \
    -H "Content-Type: application/json" \
    -d "$(jq -n \
      --arg content "$FULL_MESSAGE" \
      --argjson temp "$TEMPERATURE" \
      '{contents: [{parts: [{text: $content}]}], generationConfig: {temperature: $temp}}')")
  
  echo "$response" | jq -r '.candidates[0].content.parts[0].text // .error.message // "Error: Invalid response"'
}

# Function to call LiteLLM API
call_litellm() {
  local response
  response=$(curl -s "${LITELLM_BASE_URL}/chat/completions" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $LITELLM_API_KEY" \
    -d "$(jq -n \
      --arg model "$LITELLM_MODEL" \
      --arg content "$FULL_MESSAGE" \
      --argjson temp "$TEMPERATURE" \
      '{model: $model, messages: [{role: "user", content: $content}], temperature: $temp}')")
  
  echo "$response" | jq -r '.choices[0].message.content // .error.message // "Error: Invalid response"'
}

# Call the appropriate provider
case "$PROVIDER" in
  openai)
    [[ -n "$OPENAI_API_KEY" ]] || { echo "Error: OPENAI_API_KEY not set" >&2; exit 1; }
    call_openai
    ;;
  anthropic)
    [[ -n "$ANTHROPIC_API_KEY" ]] || { echo "Error: ANTHROPIC_API_KEY not set" >&2; exit 1; }
    call_anthropic
    ;;
  gemini)
    [[ -n "$GEMINI_API_KEY" ]] || { echo "Error: GEMINI_API_KEY not set" >&2; exit 1; }
    call_gemini
    ;;
  litellm)
    call_litellm
    ;;
  *)
    echo "Error: Unknown provider: $PROVIDER" >&2
    exit 1
    ;;
esac
