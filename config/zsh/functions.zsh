# 🚀 Professional Developer Functions
# Custom functions for enhanced productivity

# === Directory Operations ===

# Create directory and navigate into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Create a new project structure
newproject() {
    if [[ -z "$1" ]]; then
        echo "Usage: newproject <project-name>"
        return 1
    fi

    local project_name="$1"
    mkdir -p "$project_name"/{src,tests,docs,scripts}
    cd "$project_name"

    # Initialize git
    git init

    # Create basic files
    touch README.md .gitignore
    echo "# $project_name" > README.md

    echo "Project '$project_name' created successfully!"
}

# === Archive Operations ===

# Extract any archive type
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# === Development Utilities ===

# Quick HTTP server with custom port
serve() {
    local port="${1:-8000}"
    echo "Starting HTTP server on port $port..."
    echo "Access your files at: http://localhost:$port"
    python3 -m http.server "$port"
}

# Find and kill process by port
killport() {
    if [[ -z "$1" ]]; then
        echo "Usage: killport <port>"
        return 1
    fi

    local pid=$(lsof -ti tcp:"$1")
    if [[ -n "$pid" ]]; then
        kill -9 "$pid"
        echo "Process on port $1 killed"
    else
        echo "No process found on port $1"
    fi
}

# === Git Utilities ===

# Conventional commit helper
gcom() {
    if [[ -z "$1" ]]; then
        echo "Usage: gcom \"type: description\""
        echo "Types: feat, fix, docs, style, refactor, test, chore"
        return 1
    fi

    git add .
    git commit -m "$1"
}

# Create and switch to new git branch
gnb() {
    if [[ -z "$1" ]]; then
        echo "Usage: gnb <branch-name>"
        return 1
    fi

    git checkout -b "$1"
}

# Git clone and enter directory
gclone() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# === Node.js Utilities ===

# Create new Node.js project
newnode() {
    if [[ -z "$1" ]]; then
        echo "Usage: newnode <project-name>"
        return 1
    fi

    local project_name="$1"
    mkdir -p "$project_name"
    cd "$project_name"

    npm init -y
    mkdir -p src tests
    touch src/index.js tests/index.test.js

    # Create basic .gitignore
    cat > .gitignore << EOF
node_modules/
npm-debug.log*
.env
dist/
build/
.DS_Store
EOF

    git init
    echo "Node.js project '$project_name' created!"
}

# === Python Utilities ===

# Create new Python project with virtual environment
newpy() {
    if [[ -z "$1" ]]; then
        echo "Usage: newpy <project-name>"
        return 1
    fi

    local project_name="$1"
    mkdir -p "$project_name"
    cd "$project_name"

    # Create virtual environment
    python3 -m venv venv
    source venv/bin/activate

    # Create project structure
    mkdir -p src tests docs
    touch src/__init__.py src/main.py tests/__init__.py tests/test_main.py
    touch requirements.txt requirements-dev.txt README.md

    # Create basic .gitignore
    cat > .gitignore << EOF
__pycache__/
*.py[cod]
*$py.class
venv/
.env
*.so
.coverage
htmlcov/
.pytest_cache/
.mypy_cache/
dist/
build/
*.egg-info/
EOF

    git init
    echo "Python project '$project_name' created with virtual environment!"
    echo "Don't forget to activate it: source venv/bin/activate"
}

# === Docker Utilities ===

# Docker cleanup
docker-clean() {
    echo "Cleaning up Docker..."

    # Remove stopped containers
    docker container prune -f

    # Remove unused images
    docker image prune -f

    # Remove unused volumes
    docker volume prune -f

    # Remove unused networks
    docker network prune -f

    echo "Docker cleanup completed!"
}

# Quick Docker run with common options
drun() {
    if [[ -z "$1" ]]; then
        echo "Usage: drun <image> [command]"
        return 1
    fi

    docker run --rm -it "$@"
}

# === System Information ===

# System information
sysinfo() {
    echo "=== System Information ==="
    echo "OS: $(uname -s)"
    echo "Kernel: $(uname -r)"
    echo "Architecture: $(uname -m)"
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime)"
    echo ""
    echo "=== CPU Information ==="
    sysctl -n machdep.cpu.brand_string
    echo ""
    echo "=== Memory Information ==="
    vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+):\s+(\d+)/ and printf("%-16s % 16.2f MB\n", "$1:", $2 * $size / 1048576);'
    echo ""
    echo "=== Disk Usage ==="
    df -h | head -n 1
    df -h | grep -E '^/dev'
}

# === Network Utilities ===

# Check if website is up
isup() {
    if [[ -z "$1" ]]; then
        echo "Usage: isup <domain>"
        return 1
    fi

    curl -s --head "$1" | head -n 1
}

# Get external IP
myip() {
    curl -s ipinfo.io/ip
}

# === File Operations ===

# Find files by name
fname() {
    find . -iname "*$1*"
}

# Find in files
findin() {
    if [[ -z "$1" ]]; then
        echo "Usage: findin <pattern> [directory]"
        return 1
    fi

    local dir="${2:-.}"
    rg -i "$1" "$dir"
}

# === Security ===

# Generate secure password
genpass() {
    local length="${1:-32}"
    openssl rand -base64 "$length"
}

# === Development Environment ===

# Load .env file
loadenv() {
    if [[ -f .env ]]; then
        export $(cat .env | grep -v '^#' | xargs)
        echo ".env file loaded"
    else
        echo ".env file not found"
    fi
}

# === Backup Utilities ===

# Backup file with timestamp
backup() {
    if [[ -z "$1" ]]; then
        echo "Usage: backup <file>"
        return 1
    fi

    local timestamp=$(date +%Y%m%d_%H%M%S)
    cp "$1" "${1}.backup_$timestamp"
    echo "Backup created: ${1}.backup_$timestamp"
}

# === Quick Notes ===

# Quick note taking
note() {
    local notes_dir="$HOME/Documents/notes"
    mkdir -p "$notes_dir"

    if [[ -z "$1" ]]; then
        # List existing notes
        ls -la "$notes_dir"
    else
        # Create or edit note
        local note_file="$notes_dir/$(date +%Y-%m-%d)-$1.md"
        echo "# Note: $1" >> "$note_file"
        echo "Date: $(date)" >> "$note_file"
        echo "" >> "$note_file"
        code "$note_file"
    fi
}

# === Weather ===

# Get weather information
weather() {
    local city="${1:-}"
    if [[ -n "$city" ]]; then
        curl "wttr.in/$city"
    else
        curl "wttr.in"
    fi
}