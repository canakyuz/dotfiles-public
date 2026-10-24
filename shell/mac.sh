# Sadece macOS. zshrc bunu oh-my-zsh'tan önce yükler: eklentiler brew araçlarını PATH'te bulmalı.

#@ Ortam
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export JAVA_HOME="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
export GPG_TTY=$(tty)
export PATH="$PATH:$HOME/.maestro/bin"

#@ Pano
alias pt='pbpaste | tee'                            #: panodakini göster ve aktar: pt > a.json
alias cpy='pbcopy'                                  #: girdiyi panoya kopyala: cat a.txt | cpy
alias cpwd='pwd | tr -d "\n" | pbcopy'              #: bulunduğun klasörün yolunu kopyala
alias json='pbpaste | jq .'                         #: panodaki JSON'u formatlı göster
alias o='open .'                                    #: bu klasörü Finder'da aç

#@ Klasörler
alias desk='cd ~/Desktop'                           #: Masaüstü
alias down='cd ~/Downloads'                         #: İndirilenler
alias doc='cd ~/Documents'                          #: Belgeler

#@ Ağ ve portlar
alias localip='ipconfig getifaddr en0'              #: yerel ağ IP'si
alias ports='lsof -iTCP -sTCP:LISTEN -nP'           #: dinleyen tüm portlar
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'  #: DNS önbelleğini temizle
port() { lsof -i ":${1:?port gerekli}"; }           #: portu kim kullanıyor: port 5180
killport() {  #: porttaki süreci öldür: killport 8081
  local pids
  pids=$(lsof -ti tcp:"${1:?port gerekli}") || { echo "$1 boş"; return 1; }
  kill -9 $pids
}
serve() { python3 -m http.server "${1:-8000}"; }    #: bu klasörü HTTP ile yayınla, varsayılan 8000
tunnel() { ssh -N -L "${2:?port gerekli}:localhost:$2" "${1:?host gerekli}"; }  #: uzak portu local'e aç: tunnel ca-serv 5432

#@ Araçlar
alias lg='lazygit'                                  #: git arayüzü
alias brewup='brew update && brew upgrade && brew cleanup'  #: brew paketlerini güncelle
mt() {  #: Makefile hedefini fzf ile seç ve çalıştır
  [ -f Makefile ] || { echo "Makefile yok"; return 1; }
  local t
  t=$(grep -E '^[a-zA-Z0-9_-]+:' Makefile | cut -d: -f1 | sort -u | fzf) && make "$t"
}

#@ GitHub
alias prc='gh pr create --fill'                     #: commit'lerden PR aç
alias prv='gh pr view --web'                        #: bu dalın PR'ını tarayıcıda aç
alias prs='gh pr status'                            #: PR durumları
alias runw='gh run watch'                           #: çalışan workflow'u izle
