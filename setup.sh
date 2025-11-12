#!/usr/bin/env bash
##############################################################################
# 🎯 Professional Developer Dotfiles - Interactive Setup
# Choose your installation profile: minimal, standard, or full
##############################################################################

set -euo pipefail

# Source shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./scripts/lib.sh
source "${SCRIPT_DIR}/scripts/lib.sh" || exit 1

##############################################################################
# Profile Installation
##############################################################################

install_profile() {
    local profile="$1"

    case "$profile" in
        minimal)
            log "Installing ${YELLOW}minimal${NC} profile..."
            info "Includes: essentials, shell, CLI tools (from Brewfile)"
            # Brewfile already installed by install.sh
            ;;
        standard)
            log "Installing ${YELLOW}standard${NC} profile..."
            info "Includes: minimal + Node, Python, Go, Rust, build tools"
            if [[ -f "$SCRIPT_DIR/Brewfile.dev" ]]; then
                brew bundle install --file "$SCRIPT_DIR/Brewfile.dev"
                success "Development tools installed"
            fi
            setup_development_envs
            ;;
        full)
            log "Installing ${YELLOW}full${NC} profile..."
            info "Includes: standard + IDEs, databases, optional tools"
            if [[ -f "$SCRIPT_DIR/Brewfile.dev" ]]; then
                brew bundle install --file "$SCRIPT_DIR/Brewfile.dev"
            fi
            if [[ -f "$SCRIPT_DIR/Brewfile.ide" ]]; then
                info "Preparing to install IDEs (this may take time)..."
                read -p "Install IDEs? (y/n) " -r
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    brew bundle install --file "$SCRIPT_DIR/Brewfile.ide"
                    success "IDEs installed"
                fi
            fi
            setup_development_envs
            ;;
        personal)
            log "Installing ${YELLOW}personal${NC} profile..."
            info "Personal apps: browsers, productivity, communication tools"
            if [[ -f "$SCRIPT_DIR/Brewfile.personal" ]]; then
                brew bundle install --file "$SCRIPT_DIR/Brewfile.personal"
                success "Personal applications installed"
            fi
            ;;
        *)
            error "Unknown profile: $profile"
            ;;
    esac
}

setup_development_envs() {
    log "Setting up development environments..."

    # Node.js with nvm
    if command -v nvm &> /dev/null || [[ -d "$HOME/.nvm" ]]; then
        info "Setting up Node.js with nvm..."
        export NVM_DIR="$HOME/.nvm"
        # shellcheck source=/dev/null
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        if command -v nvm &> /dev/null; then
            nvm install --lts
            nvm use --lts
            nvm alias default node
            success "Node.js LTS installed"
        fi
    fi

    # Python with pyenv
    if command -v pyenv &> /dev/null; then
        info "Setting up Python with pyenv..."
        if ! pyenv versions | grep -q "3.12"; then
            pyenv install 3.12.0
            pyenv global 3.12.0
            success "Python 3.12 installed"
        fi
    fi

    # Python packages
    if command -v pip3 &> /dev/null; then
        pip3 install --user --upgrade pip virtualenv pipenv poetry 2>/dev/null || true
        success "Python packages installed"
    fi
}

show_menu() {
    echo ""
    echo -e "${BOLD}${BLUE}Installation Profiles${NC}"
    echo ""
    echo "  ${YELLOW}1)${NC} ${BOLD}minimal${NC}   - Essentials only"
    echo "       Git, shell, basic CLI tools. ~5 min, ~1GB"
    echo ""
    echo "  ${YELLOW}2)${NC} ${BOLD}standard${NC}  - Developer setup (RECOMMENDED)"
    echo "       minimal + Node, Python, Go, Rust, databases. ~15 min, ~5GB"
    echo ""
    echo "  ${YELLOW}3)${NC} ${BOLD}full${NC}      - Complete suite"
    echo "       standard + JetBrains IDEs, optional tools. ~30 min, ~15GB+"
    echo ""
    echo "  ${YELLOW}4)${NC} ${BOLD}personal${NC}  - Personal applications"
    echo "       Browsers, productivity, communication apps"
    echo ""
    echo "  ${YELLOW}5)${NC} ${BOLD}custom${NC}    - Choose packages manually"
    echo "       Select individual Brewfiles to install"
    echo ""
    read -p "Choose profile (1-5): " -r choice

    case $choice in
        1) echo "minimal" ;;
        2) echo "standard" ;;
        3) echo "full" ;;
        4) echo "personal" ;;
        5) echo "custom" ;;
        *) echo "standard" ;; # Default
    esac
}

show_custom_menu() {
    echo ""
    echo -e "${BOLD}${BLUE}Custom Installation${NC}"
    echo ""
    echo "Available Brewfiles:"
    echo ""
    local brewfiles=(
        "Brewfile:essentials|Essential tools"
        "Brewfile.dev:development|Languages, build tools, databases"
        "Brewfile.ide:ides|IDEs & editors (JetBrains, VS Code)"
        "Brewfile.personal:personal|Personal apps (browsers, productivity)"
    )

    for i in "${!brewfiles[@]}"; do
        IFS='|' read -r file desc <<< "${brewfiles[$i]}"
        echo "  ${YELLOW}$((i+1))${NC} $file - $desc"
    done
    echo "  ${YELLOW}6${NC} Exit"
    echo ""

    while true; do
        read -p "Select file to install (1-6): " -r choice
        case $choice in
            1) brew bundle install --file "$SCRIPT_DIR/Brewfile" ;;
            2) brew bundle install --file "$SCRIPT_DIR/Brewfile.dev" ;;
            3) brew bundle install --file "$SCRIPT_DIR/Brewfile.ide" ;;
            4) brew bundle install --file "$SCRIPT_DIR/Brewfile.personal" ;;
            6) return ;;
            *) warn "Invalid choice" ;;
        esac
    done
}

main() {
    echo -e "${BOLD}${BLUE}🎯 Professional Developer Dotfiles - Setup${NC}"
    echo ""

    check_os
    ensure_homebrew

    # Get profile choice
    profile=$(show_menu)

    if [[ "$profile" == "custom" ]]; then
        show_custom_menu
    else
        install_profile "$profile"
    fi

    # Post-installation
    echo ""
    echo -e "${BOLD}${GREEN}✅ Installation complete!${NC}"
    echo ""
    echo -e "${BOLD}Next Steps:${NC}"
    echo "1. Configure Git:"
    echo "   ${YELLOW}git config --global user.name \"Your Name\"${NC}"
    echo "   ${YELLOW}git config --global user.email \"your@email.com\"${NC}"
    echo ""
    echo "2. Setup SSH keys:"
    echo "   ${YELLOW}ssh-keygen -t ed25519 -C \"your@email.com\"${NC}"
    echo ""
    echo "3. Configure Powerlevel10k (optional):"
    echo "   ${YELLOW}p10k configure${NC}"
    echo ""
    echo "4. Restart terminal:"
    echo "   ${YELLOW}source ~/.zshrc${NC}"
    echo ""
    echo -e "${GREEN}Happy coding! 🚀${NC}"
}

main "$@"
