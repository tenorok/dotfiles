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

convert_wma_to_m4a() {
    local input_dir="$1"
    local output_dir="$2"

    if [[ -z "$input_dir" || -z "$output_dir" ]]; then
        echo "Usage: convert_wma_to_m4a <input_directory> <output_directory>"
        return 1
    fi

    if ! command -v ffmpeg &> /dev/null; then
        echo "❌ Ошибка: требуется установить ffmpeg"
        echo "🔗 https://ffmpeg.org/download.html"
        return 1
    fi

    mkdir -p "$output_dir"

    for f in "$input_dir"/*.wma; do
        if [[ -f "$f" ]]; then
            local filename=$(basename "$f" .wma)
            echo "Конвертирую: $f..."
            ffmpeg -i "$f" -vn -c:a alac "$output_dir/${filename}.m4a"
        else
            echo "⚠️  Файл не найден: $f"
        fi
    done

    echo "✅ Готово! Все файлы лежат в папке '$output_dir'."
}
