# 🔗 Professional Developer Aliases
# Modern CLI replacements and productivity shortcuts

# === Modern CLI Replacements ===
alias ls='eza --icons'
alias ll='eza -la --icons --git'
alias la='eza -a --icons'
alias lt='eza --tree --icons'
alias cat='bat'
alias grep='rg'
alias find='fd'
alias ps='procs'
alias du='dust'
alias df='duf'
alias top='btop'
alias cd='z'

# === Git Shortcuts ===
alias g='git'
alias gst='git status'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git pull'
alias gp='git push'
alias gpo='git push origin'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias glog='git log --oneline --graph --decorate'
alias gclean='git clean -fd'
alias greset='git reset --hard'
alias gstash='git stash'
alias gpop='git stash pop'

# === Docker Shortcuts ===
alias d='docker'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcb='docker-compose build'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drmi='docker rmi'
alias dclean='docker system prune -f'
alias dstop='docker stop $(docker ps -q)'

# === Kubernetes Shortcuts ===
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias klog='kubectl logs'
alias kexec='kubectl exec -it'

# === Development Shortcuts ===
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias serve='python3 -m http.server'
alias json='python3 -m json.tool'

# Node.js shortcuts
alias ni='npm install'
alias nid='npm install --save-dev'
alias nis='npm install --save'
alias nig='npm install -g'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nlint='npm run lint'

# Yarn shortcuts
alias yi='yarn install'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yr='yarn run'
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'

# === System & Network ===
alias reload='source ~/.zshrc'
alias myip='curl ipinfo.io/ip'
alias localip='ipconfig getifaddr en0'
alias weather='curl wttr.in'
alias speedtest='speedtest-cli'
alias ports='lsof -i -P -n | grep LISTEN'

# === File Operations ===
alias mkdir='mkdir -p'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# === macOS Specific ===
alias finder='open -a Finder'
alias preview='open -a Preview'
alias chrome='open -a "Google Chrome"'
alias safari='open -a Safari'
alias code='open -a "Visual Studio Code"'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'

# === Productivity ===
alias h='history'
alias j='jobs'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# === Quick File Editing ===
alias zshrc='code ~/.zshrc'
alias gitconfig='code ~/.gitconfig'
alias hosts='sudo code /etc/hosts'

# === Archive Operations ===
alias targz='tar -czf'
alias untargz='tar -xzf'

# === Security ===
alias sshkey='cat ~/.ssh/id_rsa.pub | pbcopy && echo "SSH key copied to clipboard"'
alias genpass='openssl rand -base64 32'

# === Development Server Shortcuts ===
alias php-server='php -S localhost:8000'
alias rails-server='rails server'
alias django-server='python manage.py runserver'

# === Cloud CLIs ===
alias awsprofile='export AWS_PROFILE=$(aws configure list-profiles | fzf)'
alias gcpproject='gcloud config set project $(gcloud projects list --format="value(projectId)" | fzf)'

# === Terraform ===
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'

# === SSH ===
alias sshconfig='code ~/.ssh/config'

# === Homebrew ===
alias brewup='brew update && brew upgrade && brew cleanup'
alias brewinfo='brew leaves | xargs brew desc --eval-all'

# === Fun ===
alias matrix='cmatrix'
alias pipes='pipes.sh'
alias fortune='fortune | cowsay | lolcat'