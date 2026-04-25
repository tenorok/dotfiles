export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
unset ANTHROPIC_API_KEY

load_openrouter_key() {
  local cache_file="$HOME/.cache/openrouter.token"
  local ttl=$((7 * 24 * 3600))
  local key mtime now

  # Пробуем получить свежий ключ из Vault (таймаут 2 сек, не блокируем shell)
  if command -v vault &>/dev/null && [[ -n "$VAULT_ADDR" ]]; then
    key=$(VAULT_CLIENT_TIMEOUT=2 vault kv get -field=api_key kv/openrouter 2>/dev/null)
    if [[ -n "$key" ]]; then
      mkdir -p "$(dirname "$cache_file")"
      umask 077
      printf '%s' "$key" > "$cache_file"
      chmod 600 "$cache_file"
    fi
  fi

  # Читаем из кэша, если он не старше TTL
  if [[ -f "$cache_file" ]]; then
    mtime=$(stat -f %m "$cache_file" 2>/dev/null || stat -c %Y "$cache_file" 2>/dev/null)
    now=$(date +%s)
    if (( now - mtime < ttl )); then
      key=$(<"$cache_file")
      if [[ -n "$key" ]]; then
        export OPENROUTER_API_KEY="$key"
        export ANTHROPIC_AUTH_TOKEN="$key"
      fi
    fi
  fi
}

load_openrouter_key
