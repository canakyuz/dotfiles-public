# 🚀 Professional Developer Dotfiles

> Modular, efficient, and focused development environment for macOS
> **Install only what you need** - from minimal essentials to full developer suite

[![macOS](https://img.shields.io/badge/macOS-000000?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Zsh](https://img.shields.io/badge/Zsh-1A2C34?style=flat-square&logo=zsh&logoColor=white)](https://zsh.sourceforge.io/)
[![Homebrew](https://img.shields.io/badge/Homebrew-FBB040?style=flat-square&logo=homebrew&logoColor=black)](https://brew.sh/)

## 🎯 Key Features

- **📦 Modular Profiles** - Choose: minimal, standard, full, or custom
- **⚡ Modern CLI Tools** - bat, eza, fzf, zoxide, starship replacements
- **🛠️ Zero Bloat** - No personal apps, browsers, or communication tools by default
- **🔒 Git-Ready** - Shell config, aliases, GitHub CLI
- **⚙️ Easy Updates** - Profile-based Brewfiles, simple symlinks
- **🐚 Smart Shell** - Zsh + Starship + modern utilities

## 🚀 Quick Start (2 minutes)

```bash
# Clone
git clone https://github.com/yourusername/dotfiles-public.git ~/.dotfiles
cd ~/.dotfiles

# Essential only (Xcode tools, Homebrew, shell setup)
./install.sh

# Advanced setup (choose your profile)
./setup.sh
```

## 📊 Installation Profiles

| Profile | Time | Size | Includes |
|---------|------|------|----------|
| **minimal** | ~5 min | ~1GB | Git, shell, CLI tools |
| **standard** | ~15 min | ~5GB | minimal + Node, Python, Go, Rust, databases |
| **full** | ~30 min | ~15GB+ | standard + JetBrains IDEs, optional tools |
| **custom** | varies | varies | Pick specific Brewfiles |

## 📁 Directory Structure

```
dotfiles-public/
├── install.sh              # Quick setup (essentials + brew)
├── setup.sh                # Interactive profile selection ⭐ START HERE
├── Makefile                # Utility targets (make help)
├── Brewfile                # Core tools (essentials only)
├── Brewfile.dev            # Development tools (optional)
├── Brewfile.ide            # IDEs & editors (optional)
├── Brewfile.personal       # Personal apps (optional)
├── config/
│   ├── zsh/
│   │   ├── .zshrc          # Main shell config
│   │   ├── .zshenv         # Environment variables
│   │   ├── aliases.zsh     # Command shortcuts
│   │   └── functions.zsh   # Custom functions
│   ├── git/
│   │   ├── .gitconfig      # Git configuration
│   │   └── .gitignore_global
│   ├── tmux/
│   │   └── .tmux.conf
│   ├── nvim/
│   │   └── init.lua        # Neovim config
│   └── vscode/
│       └── settings.json
├── scripts/
│   └── lib.sh              # Shared utilities (sourced by other scripts)
└── README.md               # You are here
```

## 📦 What's Included (by Profile)

### ✅ Essential (Always Installed)
- **Shell**: Zsh + Starship (minimal, fast prompt)
- **Version Control**: Git, GitHub CLI
- **Security**: GPG, OpenSSH
- **Modern CLI Tools**:
  - `bat` - cat with syntax highlighting
  - `eza` - ls replacement (fast, colorful)
  - `fzf` - fuzzy finder
  - `ripgrep` - fast grep
  - `zoxide` - smart cd
  - `jq/yq` - JSON/YAML processors
- **Terminal**: tmux, utilities

### 📚 Development (Brewfile.dev - Optional)
- **Languages & Version Managers**: Node.js (nvm), Python (pyenv), Go, Rust, PHP, Ruby
- **Build Tools**: Make, CMake, Maven, Gradle
- **Databases**: PostgreSQL, MySQL, Redis, MongoDB, SQLite
- **CLI Enhancements**: lazygit, Neovim, Helix
- **DevOps**: Docker, Kubernetes, Helm

### 💻 IDEs (Brewfile.ide - Optional)
- **JetBrains Suite** (choose what you need):
  - WebStorm, PyCharm, IntelliJ IDEA, GoLand, PhpStorm, RubyMine, CLion, Rider, DataGrip
- **Alternatives**: VS Code, Cursor, Sublime Text

### 👤 Personal (Brewfile.personal - Optional)
- **Productivity**: Notion, Obsidian, Todoist
- **Utilities**: Alfred, Raycast, The Unarchiver
- **Optional**: Browsers, media players, communication tools

## 🎯 Usage & Aliases

All aliases are defined in `config/zsh/aliases.zsh`. Key highlights:

### Modern CLI Replacements
```bash
ls/ll/la/tree  → eza (colored, icons, fast)
cat            → bat (syntax highlighting)
grep           → rg (ripgrep, faster)
find           → fd (intuitive)
cd             → z (smart navigation via zoxide)
du/df/top      → dust/duf/btop
```

### Git Shortcuts (Comprehensive)
```bash
gst, gco, gb, gd, gl, gp, ga, gc, gca, glog, etc.
```

### Docker & Kubernetes
```bash
d, dc, dps, di  # Docker
k, kgp, kgd, klog, kexec  # Kubernetes
```

### Development
```bash
py/pip/venv  # Python
ni, nr, ns, nt, nb  # npm
yi, ya, yr, ys  # Yarn
serve        # Python HTTP server
```

### System & Network
```bash
reload       # source ~/.zshrc
myip/localip # IP addresses
weather      # Weather info
ports        # Show listening ports
```

## ⚙️ Customization

### Extend Your Config
```bash
# Add local zsh config (override anything)
cat >> ~/.zshrc.local << 'EOF'
# Your custom settings here
export MYVAR="value"
alias myalias="command"
EOF
```

### Choose Additional Packages
After initial setup, install additional Brewfiles:
```bash
# Development tools
brew bundle install --file Brewfile.dev

# IDEs
brew bundle install --file Brewfile.ide

# Personal apps
brew bundle install --file Brewfile.personal
```

### Symlink Additional Configs
```bash
# Link custom config files
ln -sf ~/dotfiles/config/xxx ~/.xxx
```

## 🔧 Requirements

- macOS 12.0+ (Monterey or later)
- Xcode Command Line Tools
- Internet connection for downloads

## 📚 Quick Reference

### Installation Methods
- **install.sh** - Fast essentials setup (Git, shell, CLI tools)
- **setup.sh** - Interactive profile-based setup (recommended for new machines)
- **make install** - Full Makefile-based setup with all targets

### Useful Make Targets
```bash
make help          # Show all available targets
make doctor        # Check system health
make test          # Test dotfiles configuration
make clean         # Clean broken symlinks
make brew-update   # Update Homebrew packages
make ssh-keygen    # Generate SSH keys
```

### File Locations
- **Zsh config**: `config/zsh/` (aliases, functions, exports)
- **Git config**: `config/git/` (gitconfig, gitignore)
- **Shell RC**: `~/.zshrc` (symlinked from dotfiles)
- **Local overrides**: `~/.zshrc.local` (git-ignored)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/) community
- [Homebrew](https://brew.sh/) maintainers
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) creator
- All the amazing open source tool creators

---

⭐ **Star this repo if it helped you!**