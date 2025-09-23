#!/usr/bin/env bash

# Professional Developer Dotfiles Installer
# Modern, secure, and comprehensive development environment setup

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

# Configuration
readonly DOTFILES_DIR="$HOME/.dotfiles"
readonly BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
readonly LOG_FILE="/tmp/dotfiles_install.log"

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" | tee -a "$LOG_FILE"
    exit 1
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}" | tee -a "$LOG_FILE"
}

# Check if running on macOS
check_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        error "This script is designed for macOS only."
    fi

    local macos_version
    macos_version=$(sw_vers -productVersion)
    info "Running on macOS $macos_version"
}

# Check internet connectivity
check_internet() {
    if ! ping -c 1 google.com &> /dev/null; then
        error "Internet connection required for installation."
    fi
    log "Internet connectivity verified"
}

# Create backup of existing dotfiles
backup_existing() {
    log "Creating backup of existing dotfiles..."

    mkdir -p "$BACKUP_DIR"

    local files_to_backup=(
        ".zshrc"
        ".zshenv"
        ".gitconfig"
        ".tmux.conf"
        ".vimrc"
    )

    for file in "${files_to_backup[@]}"; do
        if [[ -f "$HOME/$file" ]]; then
            cp "$HOME/$file" "$BACKUP_DIR/"
            info "Backed up $file"
        fi
    done

    # Backup VS Code settings
    if [[ -d "$HOME/Library/Application Support/Code/User" ]]; then
        mkdir -p "$BACKUP_DIR/vscode"
        cp -r "$HOME/Library/Application Support/Code/User"/* "$BACKUP_DIR/vscode/" 2>/dev/null || true
        info "Backed up VS Code settings"
    fi

    log "Backup completed at $BACKUP_DIR"
}

# Install Xcode Command Line Tools
install_xcode_tools() {
    if ! xcode-select -p &> /dev/null; then
        log "Installing Xcode Command Line Tools..."
        xcode-select --install

        # Wait for installation to complete
        until xcode-select -p &> /dev/null; do
            sleep 5
        done
        log "Xcode Command Line Tools installed"
    else
        info "Xcode Command Line Tools already installed"
    fi
}

# Install Homebrew
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        log "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi

        log "Homebrew installed successfully"
    else
        info "Homebrew already installed"
        log "Updating Homebrew..."
        brew update
    fi
}

# Install packages from Brewfile
install_brew_packages() {
    log "Installing packages from Brewfile..."

    if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
        cd "$DOTFILES_DIR"
        brew bundle install --verbose
        log "Homebrew packages installed"
    else
        warn "Brewfile not found, skipping package installation"
    fi
}

# Setup shell environment
setup_shell() {
    log "Setting up Zsh environment..."

    # Install Oh My Zsh if not present
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Set Zsh as default shell
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        log "Setting Zsh as default shell..."
        chsh -s "$(which zsh)"
    fi

    log "Shell environment setup completed"
}

# Setup Node.js environment
setup_nodejs() {
    log "Setting up Node.js environment..."

    # Install nvm if not present
    if [[ ! -d "$HOME/.nvm" ]]; then
        log "Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

        # Source nvm
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi

    # Install latest LTS Node.js
    if command -v nvm &> /dev/null; then
        nvm install --lts
        nvm use --lts
        nvm alias default node
        log "Node.js LTS installed via nvm"
    fi
}

# Setup Python environment
setup_python() {
    log "Setting up Python environment..."

    # Install pyenv if not present via brew
    if command -v pyenv &> /dev/null; then
        # Install latest Python 3.12
        if ! pyenv versions | grep -q "3.12"; then
            pyenv install 3.12.0
            pyenv global 3.12.0
            log "Python 3.12 installed via pyenv"
        fi
    fi

    # Install essential Python packages
    if command -v pip3 &> /dev/null; then
        pip3 install --user --upgrade pip
        pip3 install --user virtualenv pipenv poetry
        log "Essential Python packages installed"
    fi
}

# Create symlinks for dotfiles
create_symlinks() {
    log "Creating symlinks for configuration files..."

    local config_dir="$DOTFILES_DIR/config"

    # Zsh configuration
    if [[ -f "$config_dir/zsh/.zshrc" ]]; then
        ln -sf "$config_dir/zsh/.zshrc" "$HOME/.zshrc"
        info "Linked .zshrc"
    fi

    if [[ -f "$config_dir/zsh/.zshenv" ]]; then
        ln -sf "$config_dir/zsh/.zshenv" "$HOME/.zshenv"
        info "Linked .zshenv"
    fi

    # Git configuration
    if [[ -f "$config_dir/git/.gitconfig" ]]; then
        ln -sf "$config_dir/git/.gitconfig" "$HOME/.gitconfig"
        info "Linked .gitconfig"
    fi

    # Tmux configuration
    if [[ -f "$config_dir/tmux/.tmux.conf" ]]; then
        ln -sf "$config_dir/tmux/.tmux.conf" "$HOME/.tmux.conf"
        info "Linked .tmux.conf"
    fi

    # Neovim configuration
    if [[ -d "$config_dir/nvim" ]]; then
        mkdir -p "$HOME/.config"
        ln -sf "$config_dir/nvim" "$HOME/.config/nvim"
        info "Linked Neovim config"
    fi

    log "Symlinks created successfully"
}

# Configure macOS settings
configure_macos() {
    log "Configuring macOS settings..."

    # Show hidden files in Finder
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Disable the "Are you sure you want to open this application?" dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    # Enable full keyboard access for all controls
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

    # Set fast key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    # Show battery percentage in menu bar
    defaults write com.apple.menuextra.battery ShowPercent -string "YES"

    # Restart Finder and Dock to apply changes
    killall Finder
    killall Dock

    log "macOS settings configured"
}

# Setup VS Code
setup_vscode() {
    if command -v code &> /dev/null; then
        log "Setting up VS Code..."

        local extensions=(
            "ms-python.python"
            "ms-vscode.vscode-typescript-next"
            "bradlc.vscode-tailwindcss"
            "esbenp.prettier-vscode"
            "ms-vscode.vscode-eslint"
            "formulahendry.auto-rename-tag"
            "christian-kohler.path-intellisense"
            "ms-vscode.vscode-json"
            "redhat.vscode-yaml"
            "ms-vscode-remote.remote-ssh"
            "ms-vscode-remote.remote-containers"
            "github.copilot"
            "github.vscode-pull-request-github"
            "eamodio.gitlens"
            "pkief.material-icon-theme"
            "dracula-theme.theme-dracula"
            "ms-vscode.hexeditor"
        )

        for extension in "${extensions[@]}"; do
            code --install-extension "$extension" --force
        done

        log "VS Code extensions installed"
    fi
}

# Final cleanup and instructions
finish_installation() {
    log "Installation completed successfully!"

    echo ""
    echo -e "${BOLD}${GREEN}🎉 Professional Developer Dotfiles Installation Complete!${NC}"
    echo ""
    echo -e "${BOLD}Next Steps:${NC}"
    echo "1. Restart your terminal or run: source ~/.zshrc"
    echo "2. Configure Git with your details:"
    echo "   git config --global user.name \"Your Name\""
    echo "   git config --global user.email \"your.email@example.com\""
    echo "3. Setup SSH keys for GitHub/GitLab"
    echo "4. Install JetBrains IDEs via JetBrains Toolbox"
    echo "5. Configure Powerlevel10k: p10k configure"
    echo ""
    echo -e "${BLUE}Backup of your previous dotfiles: $BACKUP_DIR${NC}"
    echo -e "${BLUE}Installation log: $LOG_FILE${NC}"
    echo ""
    echo -e "${YELLOW}Enjoy your new development environment! 🚀${NC}"
}

# Error handling
cleanup_on_error() {
    error "Installation failed. Check the log file: $LOG_FILE"
}

trap cleanup_on_error ERR

# Main installation flow
main() {
    echo -e "${BOLD}${BLUE}🚀 Professional Developer Dotfiles Installer${NC}"
    echo -e "${BOLD}Setting up your complete development environment...${NC}"
    echo ""

    check_macos
    check_internet
    backup_existing
    install_xcode_tools
    install_homebrew
    install_brew_packages
    setup_shell
    setup_nodejs
    setup_python
    create_symlinks
    configure_macos
    setup_vscode
    finish_installation
}

# Run main function
main "$@"