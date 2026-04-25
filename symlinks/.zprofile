# Homebrew — только для login shell (macOS Terminal/iTerm, SSH-логин)
# Intel
[[ -x /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"
# M1/M2
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
