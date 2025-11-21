# ============================================================================
# Neovim Development Environment Docker Image
# ============================================================================
# This Dockerfile creates a complete Neovim development environment
# with all necessary LSP servers, formatters, linters, and tools
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
    # Neovim dependencies
    neovim \
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
    # Node.js and npm (for LSP servers)
    nodejs \
    npm \
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

# ============================================================================
# Create symbolic links for fd-find
# ============================================================================
RUN ln -s $(which fdfind) /usr/local/bin/fd

# ============================================================================
# Install latest Neovim from official release (optional - if you want latest)
# ============================================================================
# Uncomment below to use latest Neovim instead of Ubuntu package
# RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && \
#     tar -C /opt -xzf nvim-linux64.tar.gz && \
#     ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim && \
#     rm nvim-linux64.tar.gz

# ============================================================================
# Install Python packages (for Python LSP, formatters, and tools)
# ============================================================================
RUN pip3 install --no-cache-dir --break-system-packages \
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
    pynvim \
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
    neovim \
    tree-sitter-cli

# ============================================================================
# Install Go (for Go LSP and DAP)
# ============================================================================
ENV GO_VERSION=1.23.4
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz

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
# Install Lua LSP
# ============================================================================
RUN luarocks install --server=https://luarocks.org/dev lua-lsp

# ============================================================================
# Install additional CLI tools
# ============================================================================
# LazyGit
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz lazygit && \
    install lazygit /usr/local/bin && \
    rm lazygit lazygit.tar.gz

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
# Install Lazy.nvim plugin manager (will auto-install on first run)
# ============================================================================
# Note: Plugins will be installed on first Neovim launch from mounted config
RUN git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable \
    /root/.local/share/nvim/lazy/lazy.nvim

# ============================================================================
# Environment setup
# ============================================================================
ENV PYTHONIOENCODING=utf-8
ENV EDITOR=nvim

# Create a startup script for convenience
RUN echo '#!/bin/bash\n\
echo "🚀 Starting Neovim Docker Environment..."\n\
echo "📂 Workspace: /workspace"\n\
echo "⚙️  Config: /root/.config/nvim"\n\
echo ""\n\
# Check if nvim config is mounted\n\
if [ ! -f "/root/.config/nvim/init.lua" ]; then\n\
    echo "⚠️  Warning: Neovim config not found!"\n\
    echo "Make sure to mount your config directory:"\n\
    echo "  -v ~/.config/nvim:/root/.config/nvim:ro"\n\
    echo ""\n\
fi\n\
# Launch Neovim\n\
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
LABEL description="Complete Neovim development environment with LSP, formatters, and tools"
LABEL version="1.0"
