##############################################################################
# ZSH Environment Variables
# Loaded by login shells, before .zshrc
##############################################################################

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Editor
export EDITOR=nano
export VISUAL=nano

# Homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# NVM (Node Version Manager)
if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
fi

# Pyenv (Python Version Manager)
if command -v pyenv &> /dev/null; then
    eval "$(pyenv init --path)"
fi

# Rbenv (Ruby Version Manager)
if command -v rbenv &> /dev/null; then
    eval "$(rbenv init --path)"
fi

# Go
if [[ -d /usr/local/go ]]; then
    export PATH="/usr/local/go/bin:$PATH"
fi

# Rust
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# Custom PATH
export PATH="$HOME/.local/bin:$PATH"

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000
