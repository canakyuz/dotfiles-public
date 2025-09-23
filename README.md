# 🚀 Professional Developer Dotfiles

> Modern, efficient, and secure development environment for full-stack developers

[![macOS](https://img.shields.io/badge/macOS-000000?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Zsh](https://img.shields.io/badge/Zsh-1A2C34?style=flat-square&logo=zsh&logoColor=white)](https://zsh.sourceforge.io/)
[![Homebrew](https://img.shields.io/badge/Homebrew-FBB040?style=flat-square&logo=homebrew&logoColor=black)](https://brew.sh/)

## ✨ Features

- **🎯 Modern CLI Tools**: bat, eza, fzf, zoxide, starship
- **⚡ Development Stack**: Node.js, Python, Java, Go, Rust, PHP
- **🛠️ Professional IDEs**: Complete JetBrains suite + VS Code
- **🐳 DevOps Ready**: Docker, Kubernetes, Cloud CLI tools
- **🔒 Security First**: GPG, SSH, secure configurations
- **📊 Observability**: Built-in monitoring and logging tools

## 🚀 Quick Install

```bash
# Clone repository
git clone https://github.com/yourusername/dotfiles-public.git ~/.dotfiles
cd ~/.dotfiles

# Run automated setup
./install.sh

# Or manual setup
make install
```

## 📁 Structure

```
dotfiles-public/
├── install.sh              # Automated installer
├── Makefile                # Installation tasks
├── Brewfile                # Homebrew dependencies
├── config/
│   ├── zsh/
│   │   ├── .zshrc
│   │   ├── .zshenv
│   │   ├── aliases.zsh
│   │   ├── functions.zsh
│   │   └── exports.zsh
│   ├── git/
│   │   ├── .gitconfig
│   │   └── .gitignore_global
│   ├── tmux/
│   │   └── .tmux.conf
│   ├── nvim/
│   │   └── init.lua
│   └── vscode/
│       ├── settings.json
│       ├── keybindings.json
│       └── extensions.json
├── scripts/
│   ├── bootstrap.sh
│   ├── macos.sh
│   ├── brew.sh
│   └── symlinks.sh
└── docs/
    ├── SETUP.md
    ├── CUSTOMIZATION.md
    └── TROUBLESHOOTING.md
```

## 🛠️ What's Included

### Development Tools
- **Languages**: Node.js (nvm), Python, Java, Go, Rust, PHP, Ruby
- **Package Managers**: npm/yarn, pip, cargo, composer, bundler
- **Build Tools**: Maven, Gradle, Make, CMake
- **Version Control**: Git, GitHub CLI, GitLab CLI

### IDEs & Editors
- **JetBrains**: IntelliJ IDEA, PyCharm, WebStorm, GoLand, CLion
- **Editors**: VS Code, Neovim, Helix, Sublime Text
- **Database**: DataGrip, DBeaver, MongoDB Compass

### DevOps & Cloud
- **Containers**: Docker, Podman, Kubernetes CLI
- **Cloud**: AWS CLI, Google Cloud SDK, Azure CLI
- **Infrastructure**: Terraform, Ansible, Helm
- **Monitoring**: htop, btop, ncdu, glances

### Terminal Enhancement
- **Shell**: Zsh + Oh My Zsh + Powerlevel10k
- **Multiplexer**: tmux, zellij
- **File Navigation**: eza, ranger, fzf, zoxide
- **Text Processing**: bat, ripgrep, jq, yq

## 🎯 Usage

### Terminal Aliases
```bash
# File operations
ll          # eza -la --icons
la          # eza -a --icons
tree        # eza --tree

# Git shortcuts
gst         # git status
gco         # git checkout
gp          # git push
gl          # git pull

# Development
serve       # python -m http.server 8000
weather     # curl wttr.in
myip        # curl ipinfo.io/ip
```

### Custom Functions
```bash
# Create and enter directory
mkcd dirname

# Extract any archive
extract filename.zip

# Quick HTTP server
serve [port]

# Git commit with conventional format
gcom "feat: add new feature"

# Docker cleanup
docker-clean
```

## ⚙️ Customization

### Adding Personal Configurations
```bash
# Create local config (ignored by git)
cp config/zsh/.zshrc.local.example config/zsh/.zshrc.local
vim config/zsh/.zshrc.local
```

### Environment Variables
```bash
# Set in ~/.zshenv.local (create if doesn't exist)
export CUSTOM_VAR="value"
export PATH="$HOME/custom/bin:$PATH"
```

## 🔧 Requirements

- macOS 12.0+ (Monterey or later)
- Xcode Command Line Tools
- Internet connection for downloads

## 📚 Documentation

- [**Setup Guide**](docs/SETUP.md) - Detailed installation instructions
- [**Customization**](docs/CUSTOMIZATION.md) - How to personalize your setup
- [**Troubleshooting**](docs/TROUBLESHOOTING.md) - Common issues and solutions

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