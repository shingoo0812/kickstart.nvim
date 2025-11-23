#!/bin/bash
# ============================================================================
# Neovim Development Tools Setup Script
# ============================================================================
# This script installs development tools on-demand inside the Docker container.
# Usage: setup-tools.sh [base|python|node|go|rust|csharp|lazygit|all]
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# ============================================================================
# Base Installation (Node.js + Neovim + Lazy.nvim)
# ============================================================================

install_base() {
    print_header "Installing Base Environment (Node.js + Neovim + Lazy.nvim)"
    
    # Git large post buffer 設定
    git config --global http.postBuffer 524288000
    print_info "Configured git http.postBuffer to 500MB"
    # ========================================================================
    # Node.js 20.x Installation
    # ========================================================================
    print_info "Installing Node.js 20.x LTS..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
    rm -rf /var/lib/apt/lists/*
    
    print_success "Node.js installed: $(node --version)"
    print_success "npm installed: $(npm --version)"
    
    # ========================================================================
    # Neovim Installation
    # ========================================================================
    print_info "Installing Neovim"
    curl -L --progress-bar -o /tmp/nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    rm -rf /opt/nvim-linux64
    tar -C /opt -xzf /tmp/nvim-linux64.tar.gz
    ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
    rm /tmp/nvim-linux64.tar.gz
    
    print_success "Neovim installed: $(nvim --version | head -n 1)"
    
    # ========================================================================
    # pynvim Installation
    # ========================================================================
    print_info "Installing pynvim..."
    pip3 install --no-cache-dir --break-system-packages pynvim
    
    print_success "pynvim installed"
    
    # ========================================================================
    # Lazy.nvim Installation
    # ========================================================================
    print_info "Installing Lazy.nvim plugin manager..."
    
    for i in 1 2 3 4 5; do
        echo "Attempt $i: Cloning lazy.nvim..."
        if git -c http.version=HTTP/1.1 clone --filter=blob:none --depth=1 --progress \
            https://github.com/folke/lazy.nvim.git /root/.local/share/nvim/lazy/lazy.nvim; then
            print_success "Lazy.nvim cloned successfully"
            break
        else
            if [ $i -lt 5 ]; then
                print_warning "Failed attempt $i, retrying in 5 seconds..."
                sleep 5
            else
                print_error "Failed to clone lazy.nvim after 5 attempts"
                return 1
            fi
        fi
    done
    
    print_success "Base environment installed successfully!"
    echo ""
    print_info "Next steps:"
    echo "  1. Exit and restart the container"
    echo "  2. Run: nvim"
    echo "  3. Inside Neovim run: :Lazy sync"
    echo "  4. Install dev tools: setup-tools.sh [python|node|go|rust|all]"
}

# ============================================================================
# Python Tools Installation
# ============================================================================

install_python_tools() {
    print_header "Installing Python Development Tools"
    
    print_info "Installing Python LSP servers and formatters..."
    pip3 install --no-cache-dir --break-system-packages \
        python-lsp-server[all] \
        pylsp-mypy \
        black \
        isort \
        autopep8 \
        flake8 \
        pylint \
        mypy \
        debugpy \
        pydocstyle
    
    print_success "Python tools installed successfully"
}

# ============================================================================
# Node.js/TypeScript Tools Installation
# ============================================================================

install_node_tools() {
    print_header "Installing Node.js/TypeScript Development Tools"
    
    print_info "Installing LSP servers and formatters..."
    npm install -g \
        typescript \
        typescript-language-server \
        vscode-langservers-extracted \
        bash-language-server \
        yaml-language-server \
        dockerfile-language-server-nodejs \
        vim-language-server \
        prettier \
        eslint \
        tree-sitter-cli
    
    print_success "Node.js tools installed successfully"
}

# ============================================================================
# Go Tools Installation
# ============================================================================

install_go_tools() {
    print_header "Installing Go Development Tools"
    
    # Check if Go is already installed
    if command -v go &> /dev/null; then
        print_warning "Go is already installed: $(go version)"
        print_info "Installing Go tools only..."
        go install golang.org/x/tools/gopls@latest
        go install github.com/go-delve/delve/cmd/dlv@latest
        print_success "Go tools installed successfully"
        return
    fi
    
    print_info "Installing Go..."
    GO_VERSION="1.23.4"
    wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
    rm go${GO_VERSION}.linux-amd64.tar.gz
    
    # Update PATH for current session
    export PATH="/usr/local/go/bin:/root/go/bin:${PATH}"
    export GOPATH="/root/go"
    
    # Add to bashrc for persistence
    echo 'export PATH="/usr/local/go/bin:/root/go/bin:${PATH}"' >> /root/.bashrc
    echo 'export GOPATH="/root/go"' >> /root/.bashrc
    
    print_info "Installing Go tools..."
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    
    print_success "Go and tools installed successfully"
    print_info "Go version: $(go version)"
}

# ============================================================================
# Rust Tools Installation
# ============================================================================

install_rust_tools() {
    print_header "Installing Rust Development Tools"
    
    # Check if Rust is already installed
    if command -v rustc &> /dev/null; then
        print_warning "Rust is already installed: $(rustc --version)"
        print_info "Installing rust-analyzer only..."
        rustup component add rust-analyzer
        print_success "Rust tools installed successfully"
        return
    fi
    
    print_info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    
    # Update PATH for current session
    export PATH="/root/.cargo/bin:${PATH}"
    
    # Add to bashrc for persistence
    echo 'export PATH="/root/.cargo/bin:${PATH}"' >> /root/.bashrc
    
    print_info "Installing rust-analyzer..."
    source /root/.cargo/env
    rustup component add rust-analyzer
    
    print_success "Rust and tools installed successfully"
    print_info "Rust version: $(rustc --version)"
}

# ============================================================================
# C# Tools Installation
# ============================================================================

install_csharp_tools() {
    print_header "Installing C# Development Tools"
    
    print_info "Installing .NET SDK..."
    wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
    chmod +x dotnet-install.sh
    ./dotnet-install.sh --channel 8.0
    rm dotnet-install.sh
    
    # Update PATH for current session
    export PATH="/root/.dotnet:${PATH}"
    export DOTNET_ROOT="/root/.dotnet"
    
    # Add to bashrc for persistence
    echo 'export PATH="/root/.dotnet:${PATH}"' >> /root/.bashrc
    echo 'export DOTNET_ROOT="/root/.dotnet"' >> /root/.bashrc
    
    print_success "C# tools installed successfully"
    print_info ".NET version: $(/root/.dotnet/dotnet --version)"
}

# ============================================================================
# LazyGit Installation
# ============================================================================

install_lazygit() {
    print_header "Installing LazyGit"
    
    # Git large post buffer 設定
    git config --global http.postBuffer 524288000
    # Check if lazygit is already installed
    if command -v lazygit &> /dev/null; then
        print_warning "LazyGit is already installed: $(lazygit --version)"
        return
    fi
    
    print_info "Downloading LazyGit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
    
    print_success "LazyGit installed successfully"
    print_info "LazyGit version: $(lazygit --version)"
}

# ============================================================================
# Main Script
# ============================================================================

show_usage() {
    echo "Usage: setup-tools.sh [option]"
    echo ""
    echo "Options:"
    echo "  base     - Install base environment (Node.js + Neovim + Lazy.nvim) - RUN THIS FIRST"
    echo "  python   - Install Python development tools"
    echo "  node     - Install Node.js/TypeScript development tools"
    echo "  go       - Install Go development tools"
    echo "  rust     - Install Rust development tools"
    echo "  csharp   - Install C# development tools"
    echo "  lazygit  - Install LazyGit"
    echo "  all      - Install base + all development tools"
    echo "  help     - Show this help message"
    echo ""
    echo "Recommended workflow:"
    echo "  1. setup-tools.sh base"
    echo "  2. Exit container and restart"
    echo "  3. setup-tools.sh python (or other tools as needed)"
    echo ""
}

# Main execution
case "${1:-help}" in
    base)
        install_base
        ;;
    python)
        install_python_tools
        ;;
    node)
        install_node_tools
        ;;
    go)
        install_go_tools
        ;;
    rust)
        install_rust_tools
        ;;
    csharp)
        install_csharp_tools
        ;;
    lazygit)
        install_lazygit
        ;;
    all)
        print_header "Installing Base + All Development Tools"
        install_base
        echo ""
        install_python_tools
        echo ""
        install_node_tools
        echo ""
        install_go_tools
        echo ""
        install_rust_tools
        echo ""
        install_csharp_tools
        echo ""
        install_lazygit
        echo ""
        print_success "All tools installed successfully!"
        echo ""
        print_info "Please exit and restart the container, then run: nvim"
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        print_error "Unknown option: $1"
        echo ""
        show_usage
        exit 1
        ;;
esac
