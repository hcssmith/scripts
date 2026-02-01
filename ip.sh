#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/ip_provider_state"
ROTATE_EVERY=10
TIMEOUT=5

# List of providers (IPv4)
PROVIDERS=(
  "https://api.ipify.org"
  "https://checkip.amazonaws.com"
  "https://ifconfig.me/ip"
  "https://icanhazip.com"
  "https://ipinfo.io/ip"
)

mkdir -p "$(dirname "$STATE_FILE")"

# Initialise state if missing
if [[ ! -f "$STATE_FILE" ]]; then
  echo "0 0" > "$STATE_FILE"
fi

read -r PROVIDER_INDEX REQUEST_COUNT < "$STATE_FILE"

provider_count=${#PROVIDERS[@]}

# Rotate provider every ROTATE_EVERY requests
if (( REQUEST_COUNT >= ROTATE_EVERY )); then
  PROVIDER_INDEX=$(( (PROVIDER_INDEX + 1) % provider_count ))
  REQUEST_COUNT=0
fi

try_provider() {
  local url="$1"
  curl -fsS --max-time "$TIMEOUT" "$url" | tr -d '\n'
}

ip=""

# Try current provider first, then fall back through others
for ((i = 0; i < provider_count; i++)); do
  index=$(( (PROVIDER_INDEX + i) % provider_count ))
  provider="${PROVIDERS[$index]}"

  if ip=$(try_provider "$provider"); then
    if [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
      PROVIDER_INDEX="$index"
      break
    fi
  fi
done

if [[ -z "$ip" ]]; then
  echo "Failed to obtain public IP" >&2
  exit 1
fi

REQUEST_COUNT=$(( REQUEST_COUNT + 1 ))
echo "$PROVIDER_INDEX $REQUEST_COUNT" > "$STATE_FILE"

echo "$ip"
