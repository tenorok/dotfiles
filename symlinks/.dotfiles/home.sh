alias venus="ssh root@77.223.99.105"
alias earth="ssh root@82.148.19.168"
alias vpn="ssh root@109.107.174.47"
alias resistance="ssh root@91.243.71.190"
alias nas="ssh Zeus@192.168.0.100 -p 88"

export VAULT_ADDR=http://192.168.0.100:8200

vault_unseal() {
    local secrets_file="$HOME/.secrets/vault.json"

    # Check if secrets file exists
    if [[ ! -f "$secrets_file" ]]; then
        echo "❌ Ошибка: Файл с секретами не найден по пути $secrets_file"
        echo "💡 Пример: { \"unsealKeys\": [\"key1\", \"key2\", \"key3\"] }"
        return 1
    fi

    # Check if jq is available
    if ! command -v jq &> /dev/null; then
        echo "❌ Ошибка: требуется установить jq"
        echo "🔗 https://jqlang.org/download/"
        return 1
    fi

    # Check if vault is available
    if ! command -v vault &> /dev/null; then
        echo "❌ Ошибка: требуется установить vault"
        echo "🔗 https://developer.hashicorp.com/vault/install"
        return 1
    fi

    echo "🔓 Распечатываем Vault..."

    # Извлекаем ключи из массива и выполняем команды последовательно
    local keys=($(jq -r '.unsealKeys[:3][]' "$secrets_file"))

    for i in "${!keys[@]}"; do
        echo "🔑 Используем ключ $((i+1))/3..."
        if ! vault operator unseal "${keys[$i]}"; then
            echo "❌ Ошибка при использовании ключа $((i+1))"
            return 1
        fi
    done

    echo "✅ Vault успешно распечатан!"
}
