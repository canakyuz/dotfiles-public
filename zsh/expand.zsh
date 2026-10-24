# Alias görünürlüğü.
# Boşluk: komut konumundaki alias satırda açılır, Enter'dan önce ne çalışacağı görünür.
# globalias'tan farkı: glob ve değişkenler açılmaz. Açmadan boşluk için Ctrl+Space.
# Enter'dan önce açılmamış alias çalışırsa açılımı gri basılır; alias'ı olan komut
# uzun yazılırsa kısası hatırlatılır.

# Açılınca satırı kalabalıklaştıran alias'lar
DOT_NOEXPAND=(ls ll l la lt l. c .. ...)

# Bu kelimelerden sonra gelen kelime yeni bir komuttur. sudo yok: zsh, sudo'dan sonraki alias'ı zaten açmaz.
_dot_cmd_start=(';' '|' '||' '&&' '|&' '&' '!' '(' '{')

_dot_expand_space() {
  local -a words=(${(z)LBUFFER})
  local word=${words[-1]} prev=${words[-2]}
  if [[ -n $word && ${LBUFFER: -${#word}} == "$word" ]] \
     && (( ${+aliases[$word]} && ! ${DOT_NOEXPAND[(Ie)$word]} )) \
     && (( ${#words} == 1 || ${_dot_cmd_start[(Ie)$prev]} )); then
    zle _expand_alias
    _dot_expanded=1
  fi
  zle self-insert
}
zle -N _dot_expand_space
bindkey -M emacs ' ' _dot_expand_space
bindkey -M viins ' ' _dot_expand_space
bindkey -M emacs '^ ' magic-space
bindkey -M viins '^ ' magic-space
bindkey -M isearch ' ' magic-space

_dot_alias_hint() {
  local typed=$1 run=$2
  if (( _dot_expanded )); then
    _dot_expanded=0
    return
  fi
  local first=${${(Az)typed}[1]}
  if (( ${+aliases[$first]} )); then
    (( ${DOT_NOEXPAND[(Ie)$first]} )) || print -r -- $'\e[90m'"→ $run"$'\e[0m'
    return
  fi
  # En uzun eşleşen alias değeri kazanır; eşitlikte kısa ad
  local name val best= bestname=
  for name val in ${(kv)aliases}; do
    (( ${#val} > ${#name} )) || continue
    [[ $typed == "$val" || $typed == "$val "* ]] || continue
    if (( ${#val} > ${#best} || (${#val} == ${#best} && ${#name} < ${#bestname}) )); then
      best=$val bestname=$name
    fi
  done
  [[ -n $bestname ]] && print -r -- $'\e[90m'"ipucu: $bestname = $best"$'\e[0m'
}
autoload -Uz add-zsh-hook
add-zsh-hook preexec _dot_alias_hint
