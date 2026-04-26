#!/usr/bin/env bash
# image-gen: generate or edit an image via OpenAI Responses API + image_generation tool.
# Decodes the base64 result to a file in OUT_DIR and emits a JSON line on stdout:
#   {"path": "/abs/path/img-<ts>.jpg", "response_id": "resp_...", "revised_prompt": "..."}
# Errors go to stderr with non-zero exit.
#
# Usage:
#   image-gen.sh --prompt "<text>" [--quality low|medium|high|auto]
#                [--previous-id <resp_id>] [--out-dir <dir>]
#                [--size 1024x1024] [--format jpeg|png|webp]
#                [--input-image <path>]   # repeatable; .jpg/.jpeg/.png
#
# When --input-image is given, the request is sent as a multimodal Responses API
# input array with the prompt as input_text and each image as a base64 data-URL
# input_image. Otherwise input is sent as a plain string.
#
# Env:
#   OPENAI_API_KEY  required
#   OPENAI_MODEL    default: gpt-5.5
set -euo pipefail

: "${OPENAI_MODEL:=gpt-5.5}"
: "${OUT_DIR:=$HOME/.cache/nvim/parrot_images}"

QUALITY="auto"
PROMPT=""
PREVIOUS_ID=""
IMAGE_SIZE="1024x1024"
IMAGE_FORMAT="jpeg"
INPUT_IMAGES=()

usage() {
  cat >&2 <<EOF
Usage: image-gen.sh --prompt <text> [--quality low|medium|high|auto]
                    [--previous-id <id>] [--out-dir <dir>]
                    [--size 1024x1024] [--format jpeg|png|webp]
                    [--input-image <path> ...]
EOF
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prompt)      PROMPT="$2"; shift 2 ;;
    --quality)     QUALITY="$2"; shift 2 ;;
    --previous-id) PREVIOUS_ID="$2"; shift 2 ;;
    --out-dir)     OUT_DIR="$2"; shift 2 ;;
    --size)        IMAGE_SIZE="$2"; shift 2 ;;
    --format)      IMAGE_FORMAT="$2"; shift 2 ;;
    --input-image) INPUT_IMAGES+=("$2"); shift 2 ;;
    -h|--help)     usage ;;
    *)             echo "Unknown arg: $1" >&2; usage ;;
  esac
done

[[ -n "$PROMPT" ]]                || { echo "Error: --prompt is required" >&2; exit 1; }
[[ -n "${OPENAI_API_KEY:-}" ]]    || { echo "Error: OPENAI_API_KEY not set" >&2; exit 1; }
command -v jq     >/dev/null      || { echo "Error: jq not found" >&2; exit 1; }
command -v curl   >/dev/null      || { echo "Error: curl not found" >&2; exit 1; }
command -v base64 >/dev/null      || { echo "Error: base64 not found" >&2; exit 1; }

mkdir -p "$OUT_DIR"

# All bulk data (base64 data URLs, full input JSON, full payload) is staged via
# temp files so it never lands on jq/curl argv. With a single ~1 MB image,
# data_url alone can push argv past ARG_MAX once env overhead is added.
TMPDIR_LOCAL=$(mktemp -d "${TMPDIR:-/tmp}/imggen.XXXXXX")
trap 'rm -rf "$TMPDIR_LOCAL"' EXIT

# Determine MIME type from filename (case-insensitive). Echoes mime or empty.
mime_for() {
  case "$1" in
    *.jpg|*.JPG|*.jpeg|*.JPEG) echo "image/jpeg" ;;
    *.png|*.PNG)               echo "image/png" ;;
    *)                         echo "" ;;
  esac
}

# Write the Responses-API `input` field to $1 (file). Plain JSON-string when
# there are no input images, or a multimodal `[{role,content:[...]}]` array.
build_input_to_file() {
  local out_file="$1"
  if [[ ${#INPUT_IMAGES[@]} -eq 0 ]]; then
    jq -n --arg text "$PROMPT" '$text' > "$out_file"
    return
  fi

  local jqargs=(-n --arg text "$PROMPT")
  local content_filter='[{type: "input_text", text: $text}]'
  local i=0
  local img mime tmp
  for img in "${INPUT_IMAGES[@]}"; do
    [[ -r "$img" ]] || { echo "Error: cannot read input image: $img" >&2; exit 1; }
    mime=$(mime_for "$img")
    [[ -n "$mime" ]] || { echo "Error: unsupported input image type: $img (need .jpg/.jpeg/.png)" >&2; exit 1; }
    tmp="$TMPDIR_LOCAL/dataurl-$i"
    printf 'data:%s;base64,' "$mime" > "$tmp"
    base64 < "$img" | tr -d '\n' >> "$tmp"
    jqargs+=(--rawfile "url$i" "$tmp")
    content_filter="$content_filter + [{type: \"input_image\", image_url: \$url$i}]"
    i=$((i+1))
  done
  local filter="[{role: \"user\", content: ($content_filter)}]"
  jq "${jqargs[@]}" "$filter" > "$out_file"
}

INPUT_FILE="$TMPDIR_LOCAL/input.json"
build_input_to_file "$INPUT_FILE"

PAYLOAD_FILE="$TMPDIR_LOCAL/payload.json"
jq -n \
  --arg model       "$OPENAI_MODEL" \
  --slurpfile input "$INPUT_FILE" \
  --arg quality     "$QUALITY" \
  --arg size        "$IMAGE_SIZE" \
  --arg format      "$IMAGE_FORMAT" \
  --arg previous_id "$PREVIOUS_ID" \
  '{
    model: $model,
    input: $input[0],
    tools: [{
      type: "image_generation",
      quality: $quality,
      size: $size,
      output_format: $format
    }]
  } + (if $previous_id != "" then {previous_response_id: $previous_id} else {} end)' > "$PAYLOAD_FILE"

RESPONSE=$(curl -sS https://api.openai.com/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  --data-binary @"$PAYLOAD_FILE")

ERR=$(echo "$RESPONSE" | jq -r '.error.message // empty')
if [[ -n "$ERR" ]]; then
  echo "API Error: $ERR" >&2
  exit 1
fi

RESPONSE_ID=$(echo "$RESPONSE"     | jq -r '.id // empty')
B64=$(echo "$RESPONSE"             | jq -r '.output[]? | select(.type == "image_generation_call") | .result // empty' | head -n 1)
REVISED_PROMPT=$(echo "$RESPONSE"  | jq -r '.output[]? | select(.type == "image_generation_call") | .revised_prompt // empty' | head -n 1)

if [[ -z "$B64" ]]; then
  echo "Error: no image data in response" >&2
  echo "Response: $RESPONSE" >&2
  exit 1
fi

EXT="$IMAGE_FORMAT"
[[ "$EXT" == "jpeg" ]] && EXT="jpg"
TS=$(date +%Y%m%d-%H%M%S)
OUT_PATH="$OUT_DIR/img-$TS.$EXT"

# macOS base64 -d can be picky about whitespace; use -D as a safer flag on Darwin.
if base64 -D </dev/null >/dev/null 2>&1; then
  echo "$B64" | base64 -D > "$OUT_PATH"
else
  echo "$B64" | base64 -d > "$OUT_PATH"
fi

jq -n \
  --arg path           "$OUT_PATH" \
  --arg response_id    "$RESPONSE_ID" \
  --arg revised_prompt "$REVISED_PROMPT" \
  '{path: $path, response_id: $response_id, revised_prompt: $revised_prompt}'
