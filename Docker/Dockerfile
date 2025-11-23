# ============================================================================
# Neovim Development Environment - Complete Docker Image
# ============================================================================
# This Dockerfile creates a complete, self-contained Neovim development 
# environment with all tools pre-installed. No network required after build.
# ============================================================================

FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# ============================================================================
# System packages and basic tools
# ============================================================================
RUN apt-get update && apt-get install -y \
    # Core utilities
    curl \
    wget \
    git \
    build-essential \
    unzip \
    tar \
    gzip \
    locales \
    software-properties-common \
    # Search and file tools (used by Telescope and plugins)
    ripgrep \
    fd-find \
    fzf \
    # Clipboard tools
    xclip \
    xsel \
    # Python development
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    # Additional development tools
    make \
    cmake \
    ninja-build \
    gettext \
    # C/C++ development
    gcc \
    g++ \
    clang \
    clang-format \
    # Language specific tools
    lua5.4 \
    luarocks \
    # Database clients
    postgresql-client \
    sqlite3 \
    # Version control
    git-lfs \
    # Utilities for LSP and plugins
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen en_US.UTF-8

# Create symbolic links for fd-find
RUN ln -s $(which fdfind) /usr/local/bin/fd

# ============================================================================
# Configure Git for better network handling
# ============================================================================
RUN git config --global http.postBuffer 524288000 && \
    git config --global http.lowSpeedLimit 1000 && \
    git config --global http.lowSpeedTime 600

# ============================================================================
# Install Node.js 20.x (LTS)
# ============================================================================
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Verify Node.js version
RUN node --version && npm --version

# ============================================================================
# Install Neovim 0.10.2 with retry logic
# ============================================================================
RUN for i in 1 2 3 4 5; do \
        echo "Attempt $i: Downloading Neovim..." && \
        curl -L -o /tmp/nvim-linux64.tar.gz \
            https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz && \
        tar -C /opt -xzf /tmp/nvim-linux64.tar.gz && \
        ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim && \
        rm /tmp/nvim-linux64.tar.gz && \
        echo "✓ Neovim installed successfully" && \
        break || { \
            echo "✗ Failed attempt $i, retrying in 10 seconds..." && \
            rm -f /tmp/nvim-linux64.tar.gz && \
            sleep 10; \
        } \
    done && \
    if [ ! -f "/usr/local/bin/nvim" ]; then \
        echo "ERROR: Failed to install Neovim after 5 attempts" && \
        exit 1; \
    fi

# Verify Neovim version
RUN nvim --version

# ============================================================================
# Install Python packages
# ============================================================================
RUN pip3 install --no-cache-dir --break-system-packages \
    # Essential
    pynvim \
    # Python LSP servers
    python-lsp-server[all] \
    pylsp-mypy \
    # Formatters
    black \
    isort \
    autopep8 \
    # Linters
    flake8 \
    pylint \
    mypy \
    # DAP (Debug Adapter Protocol)
    debugpy \
    # Additional Python tools
    pydocstyle

# ============================================================================
# Install Node.js packages globally (LSP servers and formatters)
# ============================================================================
RUN npm install -g \
    # LSP servers
    typescript \
    typescript-language-server \
    vscode-langservers-extracted \
    bash-language-server \
    yaml-language-server \
    dockerfile-language-server-nodejs \
    vim-language-server \
    # Formatters
    prettier \
    eslint \
    # Additional tools
    tree-sitter-cli

# ============================================================================
# Install Go 1.23.4 and Go tools with retry logic
# ============================================================================
ENV GO_VERSION=1.23.4
RUN for i in 1 2 3 4 5; do \
        echo "Attempt $i: Downloading Go..." && \
        wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
        tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
        rm go${GO_VERSION}.linux-amd64.tar.gz && \
        echo "✓ Go installed successfully" && \
        break || { \
            echo "✗ Failed attempt $i, retrying in 10 seconds..." && \
            rm -f go${GO_VERSION}.linux-amd64.tar.gz && \
            sleep 10; \
        } \
    done && \
    if [ ! -d "/usr/local/go" ]; then \
        echo "ERROR: Failed to install Go after 5 attempts" && \
        exit 1; \
    fi

ENV PATH="/usr/local/go/bin:/root/go/bin:${PATH}"
ENV GOPATH="/root/go"

# Install Go tools
RUN go install golang.org/x/tools/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest

# ============================================================================
# Install Rust and Rust analyzer
# ============================================================================
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup component add rust-analyzer

# ============================================================================
# Install LazyGit
# ============================================================================
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf /tmp/lazygit.tar.gz -C /tmp lazygit && \
    install /tmp/lazygit /usr/local/bin && \
    rm /tmp/lazygit /tmp/lazygit.tar.gz

# ============================================================================
# Setup workspace
# ============================================================================
WORKDIR /workspace

# Create Neovim config and data directories
RUN mkdir -p /root/.config/nvim \
             /root/.local/share/nvim \
             /root/.local/state/nvim \
             /root/.cache/nvim

# ============================================================================
# Install Lazy.nvim plugin manager with retry logic
# ============================================================================
RUN for i in 1 2 3 4 5; do \
        echo "Attempt $i: Cloning lazy.nvim..." && \
        git clone --filter=blob:none --depth=1 \
            https://github.com/folke/lazy.nvim.git --branch=stable \
            /root/.local/share/nvim/lazy/lazy.nvim && \
        echo "✓ Successfully cloned lazy.nvim" && \
        break || { \
            echo "✗ Failed attempt $i, retrying in 5 seconds..." && \
            sleep 5; \
        } \
    done && \
    if [ ! -d "/root/.local/share/nvim/lazy/lazy.nvim" ]; then \
        echo "ERROR: Failed to clone lazy.nvim after 5 attempts" && \
        exit 1; \
    fi

# ============================================================================
# Environment setup
# ============================================================================
ENV PYTHONIOENCODING=utf-8
ENV EDITOR=nvim

# Create a startup script
RUN echo '#!/bin/bash\n\
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"\n\
echo "🚀 Neovim Development Environment (Complete)"\n\
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"\n\
echo ""\n\
echo "📂 Workspace:     /workspace"\n\
echo "⚙️  Config:        /root/.config/nvim"\n\
echo "🔌 Plugins:       /root/.local/share/nvim/lazy"\n\
echo ""\n\
echo "📦 Pre-installed:"\n\
echo "   • Neovim:      $(nvim --version | head -n 1 | cut -d\" \" -f2)"\n\
echo "   • Node.js:     $(node --version)"\n\
echo "   • Python:      $(python3 --version | cut -d\" \" -f2)"\n\
echo "   • Go:          $(go version | cut -d\" \" -f3)"\n\
echo "   • Rust:        $(rustc --version | cut -d\" \" -f2)"\n\
echo ""\n\
if [ ! -f "/root/.config/nvim/init.lua" ]; then\n\
    echo "⚠️  WARNING: Neovim config not found!"\n\
    echo "   Mount your config: -v ~/.config/nvim:/root/.config/nvim:ro"\n\
    echo ""\n\
else\n\
    echo "✓ Neovim config mounted"\n\
fi\n\
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"\n\
echo "💡 First time? Run :Lazy sync inside Neovim"\n\
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"\n\
echo ""\n\
exec nvim "$@"' > /usr/local/bin/start-nvim && \
    chmod +x /usr/local/bin/start-nvim

# ============================================================================
# Entry point
# ============================================================================
ENTRYPOINT ["/usr/local/bin/start-nvim"]
CMD []

# ============================================================================
# Build information
# ============================================================================
LABEL maintainer="SHINGO"
LABEL description="Complete Neovim development environment with all tools pre-installed"
LABEL version="1.0"
LABEL tools="neovim,nodejs,python,go,rust,lazygit"
