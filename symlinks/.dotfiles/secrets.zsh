load_env_secrets() {
  local dir="${ENV_SECRETS_DIR:-$HOME/.secrets/env}"
  [[ -d "$dir" ]] || return 0

  local f name value
  for f in "$dir"/*(N); do
    [[ -f "$f" ]] || continue
    name="${f:t}"
    [[ "$name" =~ '^[A-Z][A-Z0-9_]*$' ]] || continue
    value=$(<"$f")
    value=${value%$'\n'}
    value=${value//$'\r'/}
    [[ -n "$value" ]] || continue
    export "$name"="$value"
  done
}

load_env_secrets

if [[ -d ~/yandex ]]; then
  export ANTHROPIC_BASE_URL="https://api.eliza.yandex.net/raw/anthropic"
else
  export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
  unset ANTHROPIC_API_KEY
fi
