# Her yerde yüklenir: mac ve sunucu, zsh ve bash.
# Satır sonundaki "#:" açıklamayı, "#@" bölüm başlığını `info` komutu okur.

#@ Gezinme
alias c='clear'                                     #: ekranı temizle
alias ..='cd ..'                                    #: bir üst klasör
alias ...='cd ../..'                                #: iki üst klasör
alias m='mkdir'                                     #: klasör oluştur
alias rd='rmdir'                                    #: boş klasörü sil
alias t='touch'                                     #: boş dosya oluştur
mcd() { mkdir -p "${1:?klasör adı gerekli}" && cd "$1"; }  #: klasör oluştur ve içine gir

#@ Listeleme
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --color=always --group-directories-first --icons'                                   #: renkli, ikonlu ls
  alias ll='eza -la --icons --color=always --octal-permissions --group-directories-first'          #: gizliler dahil uzun liste
  alias l='eza -bGF --header --git --color=always --group-directories-first --icons'               #: git durumuyla liste
  alias la='eza --long --all --group --group-directories-first'                                    #: uzun liste, grup sütunuyla
  alias lt='eza --tree --level=5 --color=always --group-directories-first --icons'                 #: 5 seviye ağaç
  alias l.="eza -a | grep -E '^\.'"                                                                 #: sadece gizli dosyalar
else
  alias ll='ls -lah'                                #: gizliler dahil uzun liste (eza yok)
fi

#@ Kabuk
alias sz='exec "$SHELL"'                            #: kabuğu sıfırdan yeniden başlat
alias path='echo "$PATH" | tr ":" "\n"'             #: PATH'i satır satır göster
alias h='history | grep'                            #: geçmişte ara: h docker
alias dush='du -sh * 2>/dev/null | sort -h'         #: klasördekilerin boyutu, en büyük en altta
alias rmds='find . -type f -name ".DS_Store" -delete'  #: .DS_Store dosyalarını sil
backup() { cp -a "${1:?dosya gerekli}" "$1.bak.$(date +%Y%m%d-%H%M%S)"; }  #: dosyanın tarihli yedeğini al
cheat() { curl -s "cheat.sh/${1:?komut gerekli}"; }  #: komut için hızlı örnekler: cheat tar

extract() {  #: arşivi türüne göre aç: extract x.tar.gz
  if [ ! -f "$1" ]; then echo "'$1' geçerli bir dosya değil"; return 1; fi
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.tar.xz)  tar xJf "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.gz)      gunzip "$1" ;;
    *.tar)     tar xf "$1" ;;
    *.tbz2)    tar xjf "$1" ;;
    *.tgz)     tar xzf "$1" ;;
    *.zip)     unzip "$1" ;;
    *.Z)       uncompress "$1" ;;
    *.7z)      7z x "$1" ;;
    *)         echo "'$1' açılamıyor"; return 1 ;;
  esac
}

#@ Editör
if command -v nvim >/dev/null 2>&1; then
  alias v='nvim'                                    #: neovim
  alias vi='nvim'                                   #: neovim
  alias vim='nvim'                                  #: neovim
  alias vz='nvim ~/.zshrc'                          #: zshrc'yi düzenle
  alias vconf='nvim ~/.config/nvim/'                #: neovim ayarlarını aç
fi

#@ Git
alias g='git'                                       #: git
alias gs='git status'                               #: durum
alias ga='git add'                                  #: dosya ekle
alias gaa='git add .'                               #: hepsini ekle
alias gc='git commit'                               #: commit
alias gcm='git commit -m'                           #: mesajlı commit: gcm "fix: ..."
alias gch='git checkout'                            #: dal değiştir
alias gchb='git checkout -b'                        #: yeni dal aç ve geç
alias gbd='git branch -d'                           #: dalı sil
alias gbm='git branch -m'                           #: dalı yeniden adlandır
alias gbr='git branch'                              #: dalları listele
alias gl='git pull'                                 #: çek
alias gp='git push'                                 #: gönder
alias gpo='git pull origin'                         #: origin'den çek
alias gcd='git checkout develop'                    #: develop dalına geç
alias gmain='git checkout main && git pull'         #: main'e geç ve güncelle
alias glog='git log --oneline --graph --decorate -20'  #: son 20 commit, grafikli
alias gundo='git reset --soft HEAD~1'               #: son commit'i geri al, değişiklikler kalır
gclone() { git clone "${1:?url gerekli}" && cd "$(basename "$1" .git)"; }  #: klonla ve içine gir
# oh-my-zsh git eklentisi gcp'yi cherry-pick olarak tanımlıyor; alias kalırsa fonksiyon tanımı açılıp bozulur
unalias gcp 2>/dev/null
gcp() { git add -A && git commit -m "${1:?mesaj gerekli}" && git push; }  #: hepsini ekle, commit, push

#@ Node projeleri
# Paket yöneticisi lockfile'dan seçilir, kural tek yerde.
_pm() {
  if [ -f bun.lock ] || [ -f bun.lockb ]; then echo bun
  elif [ -f pnpm-lock.yaml ]; then echo pnpm
  elif [ -f yarn.lock ]; then echo yarn
  else echo npm; fi
}
dev() { "$(_pm)" run dev "$@"; }                    #: dev script'i, bun/pnpm/yarn/npm lockfile'a göre
start() { "$(_pm)" run start "$@"; }                #: start script'i, paket yöneticisi lockfile'a göre

#@ Ağ
alias myip='curl -s ifconfig.me; echo'              #: dış IP adresi
alias rsy='rsync -avhP'                             #: ilerlemeli kopya: rsy ./dist sunucu:/yol
isup() { curl -sI "${1:?url gerekli}" | head -1; }  #: site ayakta mı: isup https://x.com

#@ Docker
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'  #: çalışan container'lar, sade tablo
alias dlogs='docker logs -f --tail 100'             #: container logunu izle: dlogs api
alias dcu='docker compose up -d'                    #: compose arka planda başlat
alias dcd='docker compose down'                     #: compose durdur
alias dcl='docker compose logs -f --tail 100'       #: compose loglarını izle
dex() { docker exec -it "${1:?container gerekli}" sh; }  #: container'ın içine gir
