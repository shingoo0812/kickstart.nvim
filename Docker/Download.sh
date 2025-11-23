#!/bin/bash
# ============================================================================
# Pre-download script for Docker build
# ============================================================================
# This script downloads large files before Docker build to avoid network issues
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="${SCRIPT_DIR}/cache"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Pre-downloading files for Docker build"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Create cache directory
mkdir -p "${CACHE_DIR}"

# ============================================================================
# Download Neovim
# ============================================================================
NVIM_VERSION="v0.10.2"
NVIM_FILE="${CACHE_DIR}/nvim-linux64.tar.gz"

if [ -f "${NVIM_FILE}" ]; then
    echo "✓ Neovim already downloaded: ${NVIM_FILE}"
else
    echo "Downloading Neovim ${NVIM_VERSION}..."
    curl -L -o "${NVIM_FILE}" \
        "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz"
    echo "✓ Neovim downloaded"
fi

# ============================================================================
# Download Go
# ============================================================================
GO_VERSION="1.23.4"
GO_FILE="${CACHE_DIR}/go${GO_VERSION}.linux-amd64.tar.gz"

if [ -f "${GO_FILE}" ]; then
    echo "✓ Go already downloaded: ${GO_FILE}"
else
    echo "Downloading Go ${GO_VERSION}..."
    wget -O "${GO_FILE}" \
        "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
    echo "✓ Go downloaded"
fi

# ============================================================================
# Clone Lazy.nvim
# ============================================================================
LAZY_DIR="${CACHE_DIR}/lazy.nvim"

if [ -d "${LAZY_DIR}" ]; then
    echo "✓ Lazy.nvim already cloned: ${LAZY_DIR}"
else
    echo "Cloning Lazy.nvim..."
    git clone --filter=blob:none --depth=1 \
        https://github.com/folke/lazy.nvim.git --branch=stable \
        "${LAZY_DIR}"
    echo "✓ Lazy.nvim cloned"
fi

# ============================================================================
# Download LazyGit
# ============================================================================
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
LAZYGIT_FILE="${CACHE_DIR}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

if [ -f "${LAZYGIT_FILE}" ]; then
    echo "✓ LazyGit already downloaded: ${LAZYGIT_FILE}"
else
    echo "Downloading LazyGit ${LAZYGIT_VERSION}..."
    curl -Lo "${LAZYGIT_FILE}" \
        "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    echo "✓ LazyGit downloaded"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  All files downloaded successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Cache directory: ${CACHE_DIR}"
ls -lh "${CACHE_DIR}"
echo ""
echo "Now you can run: make build"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
