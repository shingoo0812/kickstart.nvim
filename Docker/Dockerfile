# ============================================================================
# Neovim Development Environment Docker Image (Ultra Minimal Base)
# ============================================================================
# This Dockerfile creates an ultra-minimal base environment.
# Node.js, Neovim, and all dev tools are installed via setup-tools.sh
# ============================================================================

FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# ============================================================================
# System packages - ONLY essentials
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
    # Search and file tools
    ripgrep \
    fd-find \
    fzf \
    # Clipboard tools
    xclip \
    xsel \
    # Python 3 (system only)
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    # Build tools
    make \
    cmake \
    ninja-build \
    gettext \
    # C/C++ development
    gcc \
    g++ \
    clang \
    clang-format \
    # Lua
    lua5.4 \
    luarocks \
    # Database clients
    postgresql-client \
    sqlite3 \
    # Version control
    git-lfs \
    # SSL
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen en_US.UTF-8

# Create symbolic links for fd-find
RUN ln -s $(which fdfind) /usr/local/bin/fd

# ============================================================================
# Setup workspace
# ============================================================================
WORKDIR /workspace

# Create Neovim config and data directories
RUN mkdir -p /root/.config/nvim \
             /root/.local/share/nvim \
             /root/.local/state/nvim \
             /root/.cache/nvim

# Configure Git for better network handling
RUN git config --global http.postBuffer 524288000 && \
    git config --global http.lowSpeedLimit 1000 && \
    git config --global http.lowSpeedTime 600


# ============================================================================
# Setup Neovim and lazy
# ============================================================================
COPY /opt/nvim-linux64/bin/nvim /opt/nvim-linux64/bin/nvim 
COPY ~/.local/share/nvim/lazy/lazy.nvim /root/.local/share/nvim/lazy/lazy.nvim

# ============================================================================
# Environment setup
# ============================================================================
ENV PYTHONIOENCODING=utf-8
ENV EDITOR=nvim

# Create a startup script
RUN echo '#!/bin/bash\n\
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"\n\
echo "🚀 Neovim Docker Environment (Ultra Minimal)"\n\
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"\n\
echo ""\n\
echo "📂 Workspace:     /workspace"\n\
echo "⚙️  Config:        /root/.config/nvim"\n\
echo ""\n\
echo "⚠️  First time setup required:"\n\
echo "   Run: setup-tools.sh base    (Install Neovim + Node.js)"\n\
echo "   Then: setup-tools.sh [python|go|rust|all]"\n\
echo ""\n\
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"\n\
echo ""\n\
exec /bin/bash "$@"' > /usr/local/bin/start-env && \
    chmod +x /usr/local/bin/start-env

# ============================================================================
# Entry point
# ============================================================================
ENTRYPOINT ["/usr/local/bin/start-env"]
CMD []

# ============================================================================
# Build information
# ============================================================================
LABEL maintainer="SHINGO"
LABEL description="Ultra minimal base - install everything via setup-tools.sh"
LABEL version="3.0"


