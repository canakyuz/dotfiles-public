# 🚀 Professional Developer Dotfiles Makefile
# Automated setup and maintenance for development environment

.DEFAULT_GOAL := help
SHELL := /bin/bash

# Colors
RESET := \033[0m
BOLD := \033[1m
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m

# Configuration
DOTFILES_DIR := $(shell pwd)
BACKUP_DIR := $(HOME)/.dotfiles_backup_$(shell date +%Y%m%d_%H%M%S)
CONFIG_DIR := $(DOTFILES_DIR)/config

.PHONY: help install backup restore update clean test doctor brew shell node python git vscode links

## Display this help message
help:
	@echo "$(BOLD)$(BLUE)🚀 Professional Developer Dotfiles$(RESET)"
	@echo "$(BOLD)Available commands:$(RESET)"
	@echo
	@awk 'BEGIN {FS = ":.*##"; printf ""} /^[a-zA-Z_-]+:.*?##/ { printf "  $(YELLOW)%-15s$(RESET) %s\n", $$1, $$2 } /^##@/ { printf "\n$(BOLD)%s$(RESET)\n", substr($$0, 5) }' $(MAKEFILE_LIST)

##@ Installation
## Full installation (recommended for new machines)
install: backup brew shell node python git vscode links
	@echo "$(GREEN)✅ Installation completed successfully!$(RESET)"
	@echo "$(YELLOW)Next steps:$(RESET)"
	@echo "  1. Restart your terminal"
	@echo "  2. Run: source ~/.zshrc"
	@echo "  3. Configure Git: make git-setup"
	@echo "  4. Configure Powerlevel10k: p10k configure"

## Quick setup (for existing dotfiles users)
quick: backup links
	@echo "$(GREEN)✅ Quick setup completed!$(RESET)"

##@ Backup & Restore
## Backup existing dotfiles
backup:
	@echo "$(BLUE)📦 Creating backup...$(RESET)"
	@mkdir -p $(BACKUP_DIR)
	@for file in .zshrc .zshenv .gitconfig .tmux.conf .vimrc; do \
		if [ -f "$(HOME)/$$file" ]; then \
			cp "$(HOME)/$$file" "$(BACKUP_DIR)/"; \
			echo "$(GREEN)✓$(RESET) Backed up $$file"; \
		fi; \
	done
	@if [ -d "$(HOME)/Library/Application Support/Code/User" ]; then \
		mkdir -p "$(BACKUP_DIR)/vscode"; \
		cp -r "$(HOME)/Library/Application Support/Code/User"/* "$(BACKUP_DIR)/vscode/" 2>/dev/null || true; \
		echo "$(GREEN)✓$(RESET) Backed up VS Code settings"; \
	fi
	@echo "$(YELLOW)📍 Backup location: $(BACKUP_DIR)$(RESET)"

## Restore from backup
restore:
	@echo "$(YELLOW)⚠️  This will restore your previous configuration$(RESET)"
	@read -p "Enter backup directory path: " backup_path; \
	if [ -d "$$backup_path" ]; then \
		cp $$backup_path/.* $(HOME)/ 2>/dev/null || true; \
		echo "$(GREEN)✅ Restored from backup$(RESET)"; \
	else \
		echo "$(RED)❌ Backup directory not found$(RESET)"; \
	fi

##@ Package Management
## Install Homebrew packages
brew:
	@echo "$(BLUE)🍺 Installing Homebrew packages...$(RESET)"
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "$(YELLOW)Installing Homebrew...$(RESET)"; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@if [ -f "$(DOTFILES_DIR)/Brewfile" ]; then \
		cd $(DOTFILES_DIR) && brew bundle install --verbose; \
		echo "$(GREEN)✅ Homebrew packages installed$(RESET)"; \
	else \
		echo "$(RED)❌ Brewfile not found$(RESET)"; \
	fi

## Update Homebrew packages
brew-update:
	@echo "$(BLUE)🔄 Updating Homebrew packages...$(RESET)"
	@brew update && brew upgrade && brew cleanup
	@echo "$(GREEN)✅ Homebrew packages updated$(RESET)"

##@ Development Environment
## Setup shell environment (Zsh + Oh My Zsh)
shell:
	@echo "$(BLUE)🐚 Setting up shell environment...$(RESET)"
	@if [ ! -d "$(HOME)/.oh-my-zsh" ]; then \
		echo "$(YELLOW)Installing Oh My Zsh...$(RESET)"; \
		sh -c "$$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
	fi
	@if [ "$(SHELL)" != "$$(which zsh)" ]; then \
		echo "$(YELLOW)Setting Zsh as default shell...$(RESET)"; \
		chsh -s $$(which zsh); \
	fi
	@echo "$(GREEN)✅ Shell environment configured$(RESET)"

## Setup Node.js environment
node:
	@echo "$(BLUE)📦 Setting up Node.js environment...$(RESET)"
	@if [ ! -d "$(HOME)/.nvm" ]; then \
		echo "$(YELLOW)Installing nvm...$(RESET)"; \
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash; \
	fi
	@export NVM_DIR="$(HOME)/.nvm"; \
	[ -s "$$NVM_DIR/nvm.sh" ] && \. "$$NVM_DIR/nvm.sh"; \
	if command -v nvm >/dev/null 2>&1; then \
		nvm install --lts; \
		nvm use --lts; \
		nvm alias default node; \
	fi
	@echo "$(GREEN)✅ Node.js environment configured$(RESET)"

## Setup Python environment
python:
	@echo "$(BLUE)🐍 Setting up Python environment...$(RESET)"
	@if command -v pyenv >/dev/null 2>&1; then \
		if ! pyenv versions | grep -q "3.12"; then \
			pyenv install 3.12.0; \
			pyenv global 3.12.0; \
		fi; \
	fi
	@if command -v pip3 >/dev/null 2>&1; then \
		pip3 install --user --upgrade pip virtualenv pipenv poetry; \
	fi
	@echo "$(GREEN)✅ Python environment configured$(RESET)"

##@ Applications
## Setup Git configuration
git:
	@echo "$(BLUE)📝 Setting up Git configuration...$(RESET)"
	@if [ -f "$(CONFIG_DIR)/git/.gitconfig" ]; then \
		ln -sf "$(CONFIG_DIR)/git/.gitconfig" "$(HOME)/.gitconfig"; \
		echo "$(GREEN)✓$(RESET) Git config linked"; \
	fi
	@if [ -f "$(CONFIG_DIR)/git/.gitignore_global" ]; then \
		ln -sf "$(CONFIG_DIR)/git/.gitignore_global" "$(HOME)/.gitignore_global"; \
		echo "$(GREEN)✓$(RESET) Global gitignore linked"; \
	fi
	@echo "$(YELLOW)⚠️  Don't forget to set your Git name and email!$(RESET)"

## Interactive Git setup
git-setup:
	@echo "$(BLUE)📝 Git Configuration Setup$(RESET)"
	@read -p "Enter your full name: " name; \
	read -p "Enter your email address: " email; \
	git config --global user.name "$$name"; \
	git config --global user.email "$$email"; \
	echo "$(GREEN)✅ Git user configuration completed$(RESET)"

## Setup VS Code
vscode:
	@echo "$(BLUE)💻 Setting up VS Code...$(RESET)"
	@if command -v code >/dev/null 2>&1; then \
		extensions=( \
			"ms-python.python" \
			"ms-vscode.vscode-typescript-next" \
			"bradlc.vscode-tailwindcss" \
			"esbenp.prettier-vscode" \
			"ms-vscode.vscode-eslint" \
			"formulahendry.auto-rename-tag" \
			"christian-kohler.path-intellisense" \
			"ms-vscode.vscode-json" \
			"redhat.vscode-yaml" \
			"ms-vscode-remote.remote-ssh" \
			"ms-vscode-remote.remote-containers" \
			"github.copilot" \
			"github.vscode-pull-request-github" \
			"eamodio.gitlens" \
			"pkief.material-icon-theme" \
			"dracula-theme.theme-dracula" \
			"ms-vscode.hexeditor" \
		); \
		for ext in "$${extensions[@]}"; do \
			code --install-extension "$$ext" --force; \
		done; \
		if [ -f "$(CONFIG_DIR)/vscode/settings.json" ]; then \
			mkdir -p "$(HOME)/Library/Application Support/Code/User"; \
			ln -sf "$(CONFIG_DIR)/vscode/settings.json" "$(HOME)/Library/Application Support/Code/User/settings.json"; \
		fi; \
		echo "$(GREEN)✅ VS Code configured$(RESET)"; \
	else \
		echo "$(YELLOW)⚠️  VS Code not installed$(RESET)"; \
	fi

##@ Maintenance
## Create symbolic links for all dotfiles
links:
	@echo "$(BLUE)🔗 Creating symbolic links...$(RESET)"
	@mkdir -p "$(HOME)/.config/zsh"
	@if [ -f "$(CONFIG_DIR)/zsh/.zshrc" ]; then \
		ln -sf "$(CONFIG_DIR)/zsh/.zshrc" "$(HOME)/.zshrc"; \
		ln -sf "$(CONFIG_DIR)/zsh/.zshrc" "$(HOME)/.config/zsh/zshrc"; \
		echo "$(GREEN)✓$(RESET) .zshrc linked"; \
	fi
	@if [ -f "$(CONFIG_DIR)/zsh/.zshenv" ]; then \
		ln -sf "$(CONFIG_DIR)/zsh/.zshenv" "$(HOME)/.zshenv"; \
		echo "$(GREEN)✓$(RESET) .zshenv linked"; \
	fi
	@if [ -f "$(CONFIG_DIR)/zsh/aliases.zsh" ]; then \
		ln -sf "$(CONFIG_DIR)/zsh/aliases.zsh" "$(HOME)/.config/zsh/aliases.zsh"; \
		echo "$(GREEN)✓$(RESET) aliases linked"; \
	fi
	@if [ -f "$(CONFIG_DIR)/zsh/functions.zsh" ]; then \
		ln -sf "$(CONFIG_DIR)/zsh/functions.zsh" "$(HOME)/.config/zsh/functions.zsh"; \
		echo "$(GREEN)✓$(RESET) functions linked"; \
	fi
	@if [ -f "$(CONFIG_DIR)/git/.gitconfig" ]; then \
		ln -sf "$(CONFIG_DIR)/git/.gitconfig" "$(HOME)/.gitconfig"; \
		echo "$(GREEN)✓$(RESET) .gitconfig linked"; \
	fi
	@if [ -f "$(CONFIG_DIR)/git/.gitignore_global" ]; then \
		ln -sf "$(CONFIG_DIR)/git/.gitignore_global" "$(HOME)/.gitignore_global"; \
		echo "$(GREEN)✓$(RESET) .gitignore_global linked"; \
	fi
	@if [ -f "$(CONFIG_DIR)/tmux/.tmux.conf" ]; then \
		ln -sf "$(CONFIG_DIR)/tmux/.tmux.conf" "$(HOME)/.tmux.conf"; \
		echo "$(GREEN)✓$(RESET) .tmux.conf linked"; \
	fi
	@if [ -d "$(CONFIG_DIR)/nvim" ]; then \
		mkdir -p "$(HOME)/.config"; \
		ln -sf "$(CONFIG_DIR)/nvim" "$(HOME)/.config/nvim"; \
		echo "$(GREEN)✓$(RESET) Neovim config linked"; \
	fi

## Update dotfiles repository
update:
	@echo "$(BLUE)🔄 Updating dotfiles...$(RESET)"
	@git pull origin main
	@echo "$(GREEN)✅ Dotfiles updated$(RESET)"

## Clean up broken symlinks and cache
clean:
	@echo "$(BLUE)🧹 Cleaning up...$(RESET)"
	@find $(HOME) -maxdepth 1 -name ".*" -type l ! -exec test -e {} \; -delete 2>/dev/null || true
	@brew cleanup 2>/dev/null || true
	@if command -v npm >/dev/null 2>&1; then npm cache clean --force; fi
	@echo "$(GREEN)✅ Cleanup completed$(RESET)"

##@ Testing & Diagnostics
## Test dotfiles configuration
test:
	@echo "$(BLUE)🧪 Testing configuration...$(RESET)"
	@echo "$(YELLOW)Checking shell...$(RESET)"
	@if [ "$(SHELL)" = "$$(which zsh)" ]; then \
		echo "$(GREEN)✓$(RESET) Zsh is default shell"; \
	else \
		echo "$(RED)✗$(RESET) Zsh is not default shell"; \
	fi
	@echo "$(YELLOW)Checking Git...$(RESET)"
	@if git config --get user.name >/dev/null && git config --get user.email >/dev/null; then \
		echo "$(GREEN)✓$(RESET) Git user configured"; \
	else \
		echo "$(RED)✗$(RESET) Git user not configured"; \
	fi
	@echo "$(YELLOW)Checking SSH...$(RESET)"
	@if [ -f "$(HOME)/.ssh/id_rsa" ] || [ -f "$(HOME)/.ssh/id_ed25519" ]; then \
		echo "$(GREEN)✓$(RESET) SSH key found"; \
	else \
		echo "$(RED)✗$(RESET) No SSH key found"; \
	fi

## System health check
doctor:
	@echo "$(BLUE)🏥 System Health Check$(RESET)"
	@echo
	@echo "$(BOLD)Environment:$(RESET)"
	@echo "  Shell: $(SHELL)"
	@echo "  OS: $$(uname -s) $$(uname -r)"
	@echo "  Architecture: $$(uname -m)"
	@echo
	@echo "$(BOLD)Tools:$(RESET)"
	@command -v brew >/dev/null && echo "  ✓ Homebrew: $$(brew --version | head -1)" || echo "  ✗ Homebrew: Not installed"
	@command -v git >/dev/null && echo "  ✓ Git: $$(git --version)" || echo "  ✗ Git: Not installed"
	@command -v node >/dev/null && echo "  ✓ Node.js: $$(node --version)" || echo "  ✗ Node.js: Not installed"
	@command -v python3 >/dev/null && echo "  ✓ Python: $$(python3 --version)" || echo "  ✗ Python: Not installed"
	@command -v code >/dev/null && echo "  ✓ VS Code: Installed" || echo "  ✗ VS Code: Not installed"
	@echo
	@echo "$(BOLD)Configuration:$(RESET)"
	@[ -f "$(HOME)/.zshrc" ] && echo "  ✓ Zsh config" || echo "  ✗ Zsh config"
	@[ -f "$(HOME)/.gitconfig" ] && echo "  ✓ Git config" || echo "  ✗ Git config"
	@git config --get user.name >/dev/null && echo "  ✓ Git user" || echo "  ✗ Git user"

##@ Utilities
## Generate SSH key
ssh-keygen:
	@echo "$(BLUE)🔑 SSH Key Generation$(RESET)"
	@read -p "Enter your email address: " email; \
	read -p "Enter key type (ed25519/rsa): " keytype; \
	case $$keytype in \
		ed25519) ssh-keygen -t ed25519 -C "$$email" -f "$(HOME)/.ssh/id_ed25519" ;; \
		rsa) ssh-keygen -t rsa -b 4096 -C "$$email" -f "$(HOME)/.ssh/id_rsa" ;; \
		*) echo "$(RED)Invalid key type$(RESET)"; exit 1 ;; \
	esac; \
	echo "$(GREEN)✅ SSH key generated$(RESET)"; \
	echo "$(YELLOW)Add this public key to your Git provider:$(RESET)"; \
	cat "$(HOME)/.ssh/id_$$keytype.pub"

## Show current configuration
show-config:
	@echo "$(BLUE)📋 Current Configuration$(RESET)"
	@echo
	@echo "$(BOLD)Dotfiles Directory:$(RESET) $(DOTFILES_DIR)"
	@echo "$(BOLD)Shell:$(RESET) $(SHELL)"
	@echo "$(BOLD)Git User:$(RESET) $$(git config --get user.name 2>/dev/null || echo 'Not set') <$$(git config --get user.email 2>/dev/null || echo 'Not set')>"
	@echo "$(BOLD)Active Symlinks:$(RESET)"
	@ls -la $(HOME) | grep -E "\.zshrc|\.gitconfig|\.tmux\.conf" | grep "\->" || echo "  None found"