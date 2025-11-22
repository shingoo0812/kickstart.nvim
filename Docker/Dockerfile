# ------------------------------------------------------------
# Neovim dev image for: Python, C++, C#, Lua, Node/TypeScript
# - Mason will manage LSPs / formatters at runtime (do NOT npm -g a lot)
# - Includes compilers, dotnet sdk, nodejs, lua, python essentials
# ------------------------------------------------------------
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TERM=xterm-256color \
    PYTHONUNBUFFERED=1 \
    EDITOR=nvim

# Create non-root user
ARG USER=dev
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} ${USER} || true && \
    useradd -m -u ${UID} -g ${GID} -s /usr/bin/zsh ${USER} || true

# -------- base packages ---------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl wget gnupg lsb-release apt-transport-https \
    build-essential git make cmake ninja-build unzip tar gzip \
    locales sudo procps \
    # search / file tools
    ripgrep fd-find fzf \
    # clipboard (useful when running GUI clients under WSL/X11)
    xclip xsel \
    # python
    python3 python3-venv python3-pip python3-dev \
    # lua
    lua5.4 luarocks \
    # C/C++ toolchains
    gcc g++ clang clang-format \
    # db clients
    sqlite3 postgresql-client \
    # git lfs
    git-lfs \
    # minimal fonts/tools for terminals if needed
    fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

# fd binary link (Debian package name fdfind)
RUN ln -s $(which fdfind) /usr/local/bin/fd || true

# ---------------- Node.js 20 (set npm jobs small for builds) ----------------
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && apt-get install -y nodejs --no-install-recommends && \
    npm config set fund false && npm config set audit false && \
    rm -rf /var/lib/apt/lists/*

# ---------------- Neovim (official release tarball) ----------------
ARG NVIM_VERSION=v0.10.2
RUN curl -L -o /tmp/nvim-linux64.tar.gz \
      https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz && \
    tar -C /opt -xzf /tmp/nvim-linux64.tar.gz && \
    ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim && \
    rm /tmp/nvim-linux64.tar.gz

# -------- Python essentials (keep minimal) -------------------------------
RUN pip3 install --no-cache-dir \
    pynvim \
    debugpy \
    black \
    isort

# -------- LuaRocks example (optional) ------------------------------------
RUN luarocks --version || true
# (You can install lua tools via luarocks when needed)

# -------- .NET SDK (C#) ---------------------------------------------------
# Use Microsoft apt repo for dotnet (Ubuntu 24.04)
RUN curl -fsSL https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -o /tmp/packages-microsoft-prod.deb && \
    dpkg -i /tmp/packages-microsoft-prod.deb && \
    rm /tmp/packages-microsoft-prod.deb && \
    apt-get update && apt-get install -y dotnet-sdk-8.0 --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# -------- Optional: install basic tooling (lazygit) -----------------------
ARG LAZYGIT_VER=0.46.1
RUN curl -sL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VER}/lazygit_${LAZYGIT_VER}_Linux_x86_64.tar.gz" -o /tmp/lazygit.tar.gz && \
    tar -xzf /tmp/lazygit.tar.gz -C /tmp && \
    install /tmp/lazygit /usr/local/bin/lazygit && \
    rm -rf /tmp/lazygit* || true

# -------- Git config optimization (single place) -------------------------
RUN git config --system http.postBuffer 524288000 && \
    git config --system http.lowSpeedLimit 1000 && \
    git config --system http.lowSpeedTime 600

# -------- Create workspace & default nvim dirs for root+dev user ---------
RUN mkdir -p /workspace /root/.config/nvim /root/.local/share/nvim /root/.cache/nvim && \
    chown -R ${USER}:${USER} /workspace /root/.config /root/.local /root/.cache

WORKDIR /workspace

# -------- Switch to non-root user for normal use --------------------------
USER ${USER}
ENV HOME=/home/${USER}
RUN mkdir -p ${HOME}/.config/nvim ${HOME}/.local/share/nvim ${HOME}/.cache/nvim

# -------- Helper script to start nvim (so you can mount configs) ----------
COPY --chown=${USER}:${USER} --chmod=0755 <<'EOT' /usr/local/bin/start-nvim
#!/bin/bash
echo "Neovim dev container: workspace=/workspace"
echo "If you use Mason, run :Mason in Neovim to install LSPs"
exec nvim "$@"
EOT

# make start-nvim executable (COPY already set + permissions)
# ENTRYPOINT and default CMD
ENTRYPOINT ["/usr/local/bin/start-nvim"]
CMD []

