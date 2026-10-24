# Sadece Linux sunucu. Standart araçlarla yetinir; eza, fzf, jq olmadan da çalışır.

#@ Sistem
alias df='df -h'                                    #: disk kullanımı, okunur birimlerle
alias free='free -h'                                #: bellek kullanımı, okunur birimlerle
alias update='sudo apt update && sudo apt upgrade -y'  #: paketleri güncelle

#@ Kaynak
alias topmem='ps aux --sort=-%mem | head -11'       #: en çok RAM kullanan 10 süreç
alias topcpu='ps aux --sort=-%cpu | head -11'       #: en çok CPU kullanan 10 süreç
alias bigfiles='sudo du -ahx / 2>/dev/null | sort -rh | head -20'  #: diskteki en büyük 20 şey
alias ports='sudo ss -tulpn'                        #: dinleyen portlar ve süreçleri
killport() { sudo fuser -k "${1:?port gerekli}/tcp"; }  #: porttaki süreci öldür: killport 4000

#@ Servisler ve loglar
alias sst='systemctl status'                        #: servis durumu: sst nginx
alias ssr='sudo systemctl restart'                  #: servisi yeniden başlat: ssr api
alias logs='journalctl -f -u'                       #: servis logunu canlı izle: logs api
alias authlog='sudo tail -f /var/log/auth.log'      #: SSH giriş denemelerini izle
alias nginxt='sudo nginx -t && sudo systemctl reload nginx'  #: nginx ayarını test et, geçerse reload
alias fw='sudo ufw status numbered'                 #: güvenlik duvarı kuralları
alias certs='sudo certbot certificates'             #: SSL sertifikaları ve bitiş tarihleri
alias dclean='docker system prune'                  #: kullanılmayan docker verisini sil, onay sorar
