#!/usr/bin/env bash
# image-gen: generate or edit an image via OpenAI Images API.
# Decodes the base64 result to a file in OUT_DIR and emits a JSON line on stdout:
#   {"path": "/abs/path/img-<ts>.png", "response_id": "", "revised_prompt": "..."}
# Errors go to stderr with non-zero exit.
#
# Usage:
#   image-gen.sh --prompt "<text>" [--quality low|medium|high|auto]
#                [--previous-id <resp_id>] [--out-dir <dir>]
#                [--size 1024x1024] [--format jpeg|png|webp]
#                [--n <count>]
#                [--input-image <path>]   # repeatable; .jpg/.jpeg/.png
#
# When --input-image is given, the request is sent to the image edits endpoint
# with the images as multipart file uploads. Otherwise it is sent to the image
# generations endpoint.
#
# Env:
#   OPENAI_API_KEY  required
#   IMAGE_GEN_MODEL default: gpt-image-2
#   IMAGE_GEN_N     default: 1
set -euo pipefail

: "${IMAGE_GEN_MODEL:=gpt-image-2}"
: "${IMAGE_GEN_N:=1}"
: "${OUT_DIR:=$HOME/.cache/nvim/parrot_images}"

QUALITY="auto"
PROMPT=""
PREVIOUS_ID=""
IMAGE_SIZE="1024x1024"
IMAGE_FORMAT="png"
IMAGE_N="$IMAGE_GEN_N"
INPUT_IMAGES=()

usage() {
  cat >&2 <<EOF
Usage: image-gen.sh --prompt <text> [--quality low|medium|high|auto]
                    [--previous-id <id>] [--out-dir <dir>]
                    [--size 1024x1024] [--format jpeg|png|webp]
                    [--n <count>]
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
    --n)           IMAGE_N="$2"; shift 2 ;;
    --input-image) INPUT_IMAGES+=("$2"); shift 2 ;;
    -h|--help)     usage ;;
    *)             echo "Unknown arg: $1" >&2; usage ;;
  esac
done

[[ -n "$PROMPT" ]]                || { echo "Error: --prompt is required" >&2; exit 1; }
[[ -n "${OPENAI_API_KEY:-}" ]]    || { echo "Error: OPENAI_API_KEY not set" >&2; exit 1; }
[[ "$IMAGE_N" =~ ^[1-9][0-9]*$ ]] || { echo "Error: --n must be a positive integer" >&2; exit 1; }
(( IMAGE_N <= 10 ))               || { echo "Error: --n must be <= 10" >&2; exit 1; }
command -v jq     >/dev/null      || { echo "Error: jq not found" >&2; exit 1; }
command -v curl   >/dev/null      || { echo "Error: curl not found" >&2; exit 1; }
command -v base64 >/dev/null      || { echo "Error: base64 not found" >&2; exit 1; }

mkdir -p "$OUT_DIR"

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

json_value() {
  local filter="$1"
  jq -r "$filter" 2>/dev/null <<<"$RESPONSE"
}

check_response_error() {
  local err
  if ! err=$(json_value '.error.message // empty'); then
    echo "Error: API returned non-JSON response" >&2
    printf '%s\n' "$RESPONSE" >&2
    exit 1
  fi
  if [[ -n "$err" ]]; then
    echo "API Error: $err" >&2
    exit 1
  fi
}

ENDPOINT="https://api.openai.com/v1/images/generations"
if [[ ${#INPUT_IMAGES[@]} -gt 0 ]]; then
  ENDPOINT="https://api.openai.com/v1/images/edits"
fi

if [[ ${#INPUT_IMAGES[@]} -eq 0 ]]; then
  PAYLOAD_FILE="$TMPDIR_LOCAL/payload.json"
  jq -n \
    --arg model   "$IMAGE_GEN_MODEL" \
    --arg prompt  "$PROMPT" \
    --arg quality "$QUALITY" \
    --arg size    "$IMAGE_SIZE" \
    --arg format  "$IMAGE_FORMAT" \
    --argjson n   "$IMAGE_N" \
    '{
      model: $model,
      prompt: $prompt,
      n: $n,
      quality: $quality,
      size: $size,
      output_format: $format,
      background: "auto"
    }' > "$PAYLOAD_FILE"

  RESPONSE=$(curl -sS "$ENDPOINT" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    --data-binary @"$PAYLOAD_FILE")
else
  curl_args=(
    -sS
    -X POST "$ENDPOINT"
    -H "Authorization: Bearer $OPENAI_API_KEY"
    -F "model=$IMAGE_GEN_MODEL"
    -F "prompt=$PROMPT"
    -F "n=$IMAGE_N"
    -F "quality=$QUALITY"
    -F "size=$IMAGE_SIZE"
    -F "output_format=$IMAGE_FORMAT"
    -F "background=auto"
  )
  for img in "${INPUT_IMAGES[@]}"; do
    [[ -r "$img" ]] || { echo "Error: cannot read input image: $img" >&2; exit 1; }
    mime=$(mime_for "$img")
    [[ -n "$mime" ]] || { echo "Error: unsupported input image type: $img (need .jpg/.jpeg/.png)" >&2; exit 1; }
    curl_args+=(-F "image[]=@$img;type=$mime")
  done
  RESPONSE=$(curl "${curl_args[@]}")
fi
check_response_error

B64_FILE="$TMPDIR_LOCAL/images.b64"
jq -r '.data[]?.b64_json // empty' <<<"$RESPONSE" > "$B64_FILE"
REVISED_PROMPT=$(jq -r 'first(.data[]?.revised_prompt? // empty) // ""' <<<"$RESPONSE")

if [[ ! -s "$B64_FILE" ]]; then
  echo "Error: no image data in response" >&2
  echo "Response: $RESPONSE" >&2
  exit 1
fi

EXT="$IMAGE_FORMAT"
[[ "$EXT" == "jpeg" ]] && EXT="jpg"
TS=$(date +%Y%m%d-%H%M%S)
OUT_PATHS=()
idx=0

while IFS= read -r B64; do
  [[ -n "$B64" ]] || continue
  if [[ "$IMAGE_N" == "1" && "$idx" == "0" ]]; then
    OUT_PATH="$OUT_DIR/img-$TS.$EXT"
  else
    OUT_PATH="$OUT_DIR/img-$TS-$idx.$EXT"
  fi

  # macOS base64 -d can be picky about whitespace; use -D as a safer flag on Darwin.
  if base64 -D </dev/null >/dev/null 2>&1; then
    printf '%s' "$B64" | base64 -D > "$OUT_PATH"
  else
    printf '%s' "$B64" | base64 -d > "$OUT_PATH"
  fi
  OUT_PATHS+=("$OUT_PATH")
  idx=$((idx+1))
done < "$B64_FILE"

OUT_PATH="${OUT_PATHS[0]}"
PATHS_JSON=$(printf '%s\n' "${OUT_PATHS[@]}" | jq -R . | jq -s .)

jq -n \
  --arg path           "$OUT_PATH" \
  --argjson paths      "$PATHS_JSON" \
  --arg response_id    "" \
  --arg revised_prompt "$REVISED_PROMPT" \
  '{path: $path, paths: $paths, response_id: $response_id, revised_prompt: $revised_prompt}'
