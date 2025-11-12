#!/usr/bin/env bash
##############################################################################
# Shared utilities for dotfiles installation scripts
# Source this file in other scripts: source "$(dirname "$0")/lib.sh"
##############################################################################

set -euo pipefail

# Colors for output
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export BOLD='\033[1m'
export NC='\033[0m' # No Color

# Log levels
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

fail() {
    error "$1"
    exit 1
}

##############################################################################
# System Checks
##############################################################################

check_os() {
    if [[ "$(uname)" != "Darwin" ]]; then
        fail "This script is for macOS only. Detected: $(uname)"
    fi
    local macos_version
    macos_version=$(sw_vers -productVersion)
    info "Running on macOS $macos_version"
}

check_internet() {
    if ! nc -zw1 8.8.8.8 443 2>/dev/null; then
        fail "Internet connection required."
    fi
    success "Internet connectivity verified"
}

##############################################################################
# Symlink Management
##############################################################################

create_symlink() {
    local src="$1"
    local dest="$2"

    if [[ ! -e "$src" ]]; then
        warn "Source not found: $src"
        return 1
    fi

    # Remove existing symlink or file
    if [[ -L "$dest" ]] || [[ -e "$dest" ]]; then
        rm -f "$dest"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
    success "Linked $(basename "$src")"
}

##############################################################################
# Backup Management
##############################################################################

backup_file() {
    local file="$1"
    local backup_dir="${2:-.}"

    if [[ -f "$file" ]]; then
        mkdir -p "$backup_dir"
        cp "$file" "$backup_dir/"
        info "Backed up $(basename "$file")"
    fi
}

##############################################################################
# Homebrew Helpers
##############################################################################

ensure_homebrew() {
    if ! command -v brew &> /dev/null; then
        log "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Setup PATH for Apple Silicon
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
    success "Homebrew ready"
}

##############################################################################
# Profile Selection
##############################################################################

select_profile() {
    echo ""
    echo -e "${BOLD}Installation Profile:${NC}"
    echo "1) ${YELLOW}minimal${NC}   - Git, shell, essential CLI tools (fastest)"
    echo "2) ${YELLOW}standard${NC}  - minimal + development tools (Node, Python, etc.)"
    echo "3) ${YELLOW}full${NC}      - standard + IDEs, databases, optional tools"
    echo ""
    read -p "Choose profile (1-3): " profile_choice

    case $profile_choice in
        1) echo "minimal" ;;
        2) echo "standard" ;;
        3) echo "full" ;;
        *) echo "standard" ;; # Default to standard
    esac
}

##############################################################################
# Xcode Tools
##############################################################################

ensure_xcode() {
    if ! xcode-select -p &> /dev/null; then
        log "Installing Xcode Command Line Tools..."
        xcode-select --install

        until xcode-select -p &> /dev/null; do
            sleep 5
        done
    fi
    success "Xcode Command Line Tools ready"
}
