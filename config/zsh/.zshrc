# 🚀 Professional Zsh Configuration
# Optimized for full-stack development

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    brew
    macos
    node
    npm
    python
    docker
    kubectl
    terraform
    aws
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
    history-substring-search
)

# Oh My Zsh
source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

# Language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# History configuration
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history       # record timestamp of command
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# Directory navigation
setopt auto_cd              # change directory just by typing directory name
setopt auto_pushd           # make cd push the old directory onto the directory stack
setopt pushd_ignore_dups    # don't push the same dir twice

# Completions
autoload -Uz compinit
compinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Load custom configurations
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Load aliases
[[ -f ~/.config/zsh/aliases.zsh ]] && source ~/.config/zsh/aliases.zsh

# Load functions
[[ -f ~/.config/zsh/functions.zsh ]] && source ~/.config/zsh/functions.zsh

# Load exports
[[ -f ~/.config/zsh/exports.zsh ]] && source ~/.config/zsh/exports.zsh

# Initialize tools
eval "$(zoxide init zsh)"
eval "$(starship init zsh)" 2>/dev/null || true

# FZF configuration
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
fi

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Pyenv configuration
if command -v pyenv >/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# Go configuration
if command -v go >/dev/null 2>&1; then
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
fi

# Rust configuration
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# Java configuration (jenv)
if command -v jenv >/dev/null 2>&1; then
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)"
fi

# Ruby configuration (rbenv)
if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init - zsh)"
fi

# Homebrew
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# GPG configuration
export GPG_TTY=$(tty)

# SSH agent
if [[ ! -S ~/.ssh/ssh_auth_sock ]]; then
    eval `ssh-agent`
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

# AWS CLI auto-completion
if command -v aws_completer >/dev/null 2>&1; then
    complete -C aws_completer aws
fi

# Kubectl auto-completion
if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
fi

# Docker completion
if command -v docker >/dev/null 2>&1; then
    source <(docker completion zsh)
fi

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Performance optimization
skip_global_compinit=1