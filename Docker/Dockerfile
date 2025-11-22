# ============================================================================
# Neovim Development Environment Docker Image (Minimal Base)
# ============================================================================
# This Dockerfile creates a minimal Neovim development environment.
# Additional tools can be installed via setup-tools.sh after container starts.
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

# ============================================================================
# Create symbolic links for fd-find
# ============================================================================
RUN ln -s $(which fdfind) /usr/local/bin/fd

# ============================================================================
# Install Node.js 20.x (LTS)
# ============================================================================
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Verify Node.js version
RUN node --version && npm --version

# ============================================================================
# Install latest Neovim from official release (required for dropbar.nvim 0.11.0+)
# ============================================================================
RUN curl -L -o nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz && \
    tar -C /opt -xzf nvim-linux64.tar.gz && \
    ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim && \
    rm nvim-linux64.tar.gz

# Verify Neovim version
RUN nvim --version

# ============================================================================
# Install minimal Python packages (only essentials)
# ============================================================================
RUN pip3 install --no-cache-dir --break-system-packages pynvim

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
# Configure Git for better network handling
# ============================================================================
RUN git config --global http.postBuffer 524288000 && \
    git config --global http.lowSpeedLimit 1000 && \
    git config --global http.lowSpeedTime 600

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

# Create a startup script for convenience
RUN echo '#!/bin/bash\n\
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"\n\
echo "🚀 Neovim Docker Environment"\n\
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"\n\
echo ""\n\
echo "📂 Workspace:     /workspace"\n\
echo "⚙️  Config:        /root/.config/nvim"\n\
echo "🔌 Plugins:       /root/.local/share/nvim/lazy"\n\
echo ""\n\
# Check versions\n\
echo "📦 Versions:"\n\
nvim --version | head -n 1\n\
node --version | xargs echo "   Node.js:"\n\
python3 --version | xargs echo "   Python: "\n\
echo ""\n\
# Check if nvim config is mounted\n\
if [ ! -f "/root/.config/nvim/init.lua" ]; then\n\
    echo "⚠️  WARNING: Neovim config not found!"\n\
    echo ""\n\
    echo "Make sure to mount your config directory:"\n\
    echo "  docker-compose run --rm neovim"\n\
    echo ""\n\
else\n\
    echo "✓ Neovim config mounted successfully"\n\
    echo ""\n\
fi\n\
# Check lazy.nvim\n\
if [ -d "/root/.local/share/nvim/lazy/lazy.nvim" ]; then\n\
    echo "✓ Lazy.nvim plugin manager ready"\n\
else\n\
    echo "⚠️  WARNING: Lazy.nvim not found!"\n\
fi\n\
echo ""\n\
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"\n\
echo "💡 First time? Run :Lazy sync inside Neovim to install plugins"\n\
echo "💡 Install dev tools: setup-tools.sh [python|node|go|rust|all]"\n\
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"\n\
echo ""\n\
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
LABEL description="Minimal Neovim development environment - install tools via setup-tools.sh"
LABEL version="2.0"


