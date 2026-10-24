# dotfiles

zsh ve bash için alias ve fonksiyonlar. macOS'ta ve Linux sunucuda aynı repo.

## Kurulum

```sh
git clone https://github.com/canakyuz/dotfiles-public ~/.dotfiles
~/.dotfiles/install
```

`install` zsh varsa `~/.zshrc`'yi repodaki dosyaya bağlar; Linux'ta `~/.bashrc`'nin sonuna tek bir satır ekler. Var olan dosyayı `.bak.<tarih>` olarak yedekler. İki kez çalıştırmak güvenli.

## Yapı

| Dosya | Nerede yüklenir |
| --- | --- |
| `shell/common.sh` | her yer: mac ve sunucu, zsh ve bash |
| `shell/mac.sh` | sadece macOS |
| `shell/linux.sh` | sadece Linux |
| `zsh/zshrc` | zsh yükleyicisi |
| `zsh/expand.zsh` | alias'ı satırda açma ve ipuçları, sadece zsh |
| `bash/bashrc` | bash yükleyicisi |
| `bin/info` | komut listesi |
| `~/.zshrc.local` | bu makineye özel, repoda yok |
| `~/.secrets` | token ve anahtarlar, repoda yok, `chmod 600` |

## Komutları görmek

```sh
info            # hepsi, katmana göre
info git        # adında, komutunda ya da açıklamasında "git" geçenler
info killport   # tek komutun tanımı ve dosyadaki yeri
```

zsh'ta bir alias yazıp boşluğa basınca satırda açılır, Enter'dan önce ne çalışacağı görünür. Açmadan boşluk için `Ctrl+Space`. Alias'ı olan bir komutu uzun yazınca kısası gri bir satırda hatırlatılır.

## Yeni komut eklemek

İlgili dosyaya ekle, satır sonuna `#:` ile açıklama yaz. `info` onu otomatik listeler:

```sh
alias gp='git push'   #: gönder
```
