#!/usr/bin/env bash
##############################################################################
# 🚀 Professional Developer Dotfiles - Quick Installer
# This script handles essentials + homebrew. For advanced setup, use:
#   ./setup.sh  - Interactive profile-based installation
#   make install - Full Makefile-based setup
##############################################################################

set -euo pipefail

# Source shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./scripts/lib.sh
source "${SCRIPT_DIR}/scripts/lib.sh" || exit 1

readonly DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
readonly BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

##############################################################################
# Main Installation
##############################################################################

backup_existing() {
    log "Creating backup of existing dotfiles..."
    mkdir -p "$BACKUP_DIR"

    local files_to_backup=(".zshrc" ".zshenv" ".gitconfig" ".tmux.conf" ".vimrc")
    for file in "${files_to_backup[@]}"; do
        backup_file "$HOME/$file" "$BACKUP_DIR"
    done

    # Backup VS Code settings
    local vscode_path="$HOME/Library/Application Support/Code/User"
    if [[ -d "$vscode_path" ]]; then
        mkdir -p "$BACKUP_DIR/vscode"
        cp -r "$vscode_path"/* "$BACKUP_DIR/vscode/" 2>/dev/null || true
        info "Backed up VS Code settings"
    fi

    log "Backup completed: $BACKUP_DIR"
}

setup_shell() {
    log "Setting up Zsh environment..."

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    if [[ "$SHELL" != "$(which zsh)" ]]; then
        info "Setting Zsh as default shell..."
        chsh -s "$(which zsh)"
    fi

    success "Shell environment ready"
}

create_symlinks() {
    log "Creating symlinks for dotfiles..."
    local config_dir="$DOTFILES_DIR/config"

    create_symlink "$config_dir/zsh/.zshrc" "$HOME/.zshrc"
    create_symlink "$config_dir/zsh/.zshenv" "$HOME/.zshenv"
    create_symlink "$config_dir/git/.gitconfig" "$HOME/.gitconfig"
    create_symlink "$config_dir/tmux/.tmux.conf" "$HOME/.tmux.conf"

    if [[ -d "$config_dir/nvim" ]]; then
        mkdir -p "$HOME/.config"
        create_symlink "$config_dir/nvim" "$HOME/.config/nvim"
    fi

    success "Symlinks created"
}

main() {
    echo -e "${BOLD}${BLUE}🚀 Professional Developer Dotfiles Installer${NC}"
    echo ""

    check_os
    check_internet
    backup_existing
    ensure_xcode
    ensure_homebrew

    # Install essential packages from Brewfile
    log "Installing packages from Brewfile..."
    if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
        cd "$DOTFILES_DIR"
        brew bundle install
        success "Homebrew packages installed"
    else
        warn "Brewfile not found at $DOTFILES_DIR/Brewfile"
    fi

    setup_shell
    create_symlinks

    # Offer advanced setup
    echo ""
    echo -e "${BOLD}Next Steps:${NC}"
    echo "1. Restart your terminal: ${YELLOW}source ~/.zshrc${NC}"
    echo "2. For advanced setup (Node, Python, IDEs): ${YELLOW}./setup.sh${NC}"
    echo "3. Or use Makefile: ${YELLOW}make help${NC}"
    echo ""
    echo -e "${BLUE}Backup: $BACKUP_DIR${NC}"
    echo ""
    echo -e "${GREEN}✅ Basic setup complete! Happy coding! 🚀${NC}"
}

main "$@"