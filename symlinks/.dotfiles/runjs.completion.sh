### run completion - begin. generated by omelette.js ###
if type compdef &>/dev/null; then
  _run_completion() {
    compadd -- `run --compzsh --compgen "${CURRENT}" "${words[CURRENT-1]}" "${BUFFER}"`
  }
  compdef _run_completion run
elif type complete &>/dev/null; then
  _run_completion() {
    local cur prev nb_colon
    _get_comp_words_by_ref -n : cur prev
    nb_colon=$(grep -o ":" <<< "$COMP_LINE" | wc -l)

    COMPREPLY=( $(compgen -W '$(run --compbash --compgen "$((COMP_CWORD - (nb_colon * 2)))" "$prev" "${COMP_LINE}")' -- "$cur") )

    __ltrim_colon_completions "$cur"
  }
  complete -F _run_completion run
fi
### run completion - end ###
