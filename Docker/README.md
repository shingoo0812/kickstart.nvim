# Neovim Docker Development Environment

完全なNeovim開発環境をDockerで構築します。Windows、Linux、macOSで動作します。

## 📋 目次

- [特徴](#特徴)
- [前提条件](#前提条件)
- [セットアップ](#セットアップ)
- [使い方](#使い方)
- [カスタマイズ](#カスタマイズ)
- [トラブルシューティング](#トラブルシューティング)

## ✨ 特徴

このDocker環境には以下が含まれています：

### コアツール
- ✅ Neovim (最新版)
- ✅ Lazy.nvim (プラグインマネージャー)
- ✅ Git & LazyGit
- ✅ ripgrep, fd-find, fzf

### 言語サポート
- ✅ **Python**: pylsp, black, isort, flake8, mypy, debugpy
- ✅ **JavaScript/TypeScript**: typescript-language-server, prettier, eslint
- ✅ **Go**: gopls, delve
- ✅ **Rust**: rust-analyzer
- ✅ **C/C++**: clangd, clang-format
- ✅ **Lua**: lua-lsp
- ✅ **その他**: bash, yaml, dockerfile, vim LSP servers

### 開発ツール
- ✅ Tree-sitter
- ✅ DAP (Debug Adapter Protocol)
- ✅ Mason.nvim用の各種ツール
- ✅ PostgreSQL & SQLite クライアント

## 📦 前提条件

- Docker Desktop (Windows/Mac) または Docker Engine (Linux)
- Docker Compose v2.0以上
- 既存のNeovim設定ファイル（`~/.config/nvim` または `~/AppData/Local/nvim`）

## 🚀 セットアップ

### 1. リポジトリのクローン or ファイルのダウンロード

```bash
# Gitリポジトリとしてクローン（推奨）
git clone <your-dotfiles-repo> ~/dotfiles
cd ~/dotfiles/neovim-docker

# または、手動でファイルを配置
mkdir -p ~/neovim-docker
cd ~/neovim-docker
# Dockerfile, docker-compose.yml, .env.example をコピー
```

### 2. 環境変数の設定

```bash
# .env.example を .env にコピー
cp .env.example .env

# .env を編集してパスを設定
# Windows の場合
NVIM_CONFIG_PATH=C:/Users/YourName/AppData/Local/nvim
WORKSPACE_PATH=C:/Users/YourName/projects

# Linux/Mac の場合
NVIM_CONFIG_PATH=~/.config/nvim
WORKSPACE_PATH=~/projects

ケース1: 全部WSL内で完結
bash# WSL内のファイル構成
/home/shingo/
├── .config/nvim/          ← Neovim設定
│   ├── lua/
│   ├── init.lua
│   └── docker/
└── projects/              ← プロジェクト
    ├── my-app/
    └── houdini-tools/
bash# .env
NVIM_CONFIG_PATH=/home/shingo/.config/nvim
WORKSPACE_PATH=/home/shingo/projects
bash# WSLで起動
cd ~/.config/nvim/docker
docker-compose run --rm neovim

ケース2: Neovim設定はWSL、プロジェクトはWindows
bash# ファイル配置
WSL: /home/shingo/.config/nvim/    ← Neovim設定
Windows: C:/Users/shing/projects/   ← プロジェクト
bash# .env
NVIM_CONFIG_PATH=/home/shingo/.config/nvim
WORKSPACE_PATH=/mnt/c/Users/shing/projects  # ← /mnt/c/で始まる

ケース3: 全部Windows（WSLは使わない）
bash# PowerShellで起動
cd C:\Users\shing\AppData\Local\nvim\docker
docker-compose run --rm neovim
bash# .env
NVIM_CONFIG_PATH=C:/Users/shing/AppData/Local/nvim
WORKSPACE_PATH=C:/Users/shing/projects
```


### 3. Dockerイメージのビルド

```bash
# イメージをビルド（初回のみ、5-10分程度）
docker-compose build

# または、バックグラウンドでビルド
docker-compose build --no-cache
```

## 💻 使い方

### 基本的な起動

```bash
# Neovimを起動
docker-compose run --rm neovim

# 特定のファイルを開く
docker-compose run --rm neovim /workspace/myproject/main.py

# 複数ファイルを開く
docker-compose run --rm neovim /workspace/file1.py /workspace/file2.py

# Neovimをバックグラウンドで実行
docker-compose up -d neovim
```

### シェルアクセス

```bash
# コンテナ内でbashを起動
docker-compose run --rm shell

# 実行中のコンテナに接続
docker exec -it neovim-dev bash
```

### プラグインのインストール

初回起動時にLazy.nvimが自動的にプラグインをインストールします。

```bash
# Neovim起動後、コマンドモードで
:Lazy sync

# Mason でLSPサーバーをインストール
:Mason

# プラグインの更新
:Lazy update
```

## 🎨 カスタマイズ

### 追加のパッケージをインストール

`Dockerfile`を編集して必要なパッケージを追加：

```dockerfile
# 例: C#開発用ツール
RUN apt-get update && apt-get install -y \
    dotnet-sdk-8.0 \
    && rm -rf /var/lib/apt/lists/*

# 例: 追加のPythonパッケージ
RUN pip3 install --no-cache-dir --break-system-packages \
    pandas \
    numpy \
    requests
```

再ビルド：
```bash
docker-compose build --no-cache
```

### ボリュームマウントの追加

`docker-compose.yml`の`volumes`セクションに追加：

```yaml
volumes:
  - ~/.ssh:/root/.ssh:ro  # SSHキー（読み取り専用）
  - ~/.gitconfig:/root/.gitconfig:ro  # Git設定
  - ~/Documents:/documents:ro  # ドキュメント
```

### 環境変数の追加

`.env`ファイルまたは`docker-compose.yml`の`environment`セクションに追加：

```yaml
environment:
  - OPENAI_API_KEY=${OPENAI_API_KEY}
  - DATABASE_URL=${DATABASE_URL}
```

## 🔧 各OSでの注意点

### Windows

#### パスの指定
Windowsの絶対パスを使用：
```env
NVIM_CONFIG_PATH=C:/Users/shing/AppData/Local/nvim
WORKSPACE_PATH=C:/Users/shing/projects
```

#### WSL2との併用
WSL2を使用している場合：
```bash
# WSL2内から実行
cd ~/neovim-docker
docker-compose run --rm neovim

# Windowsのファイルをマウント
WORKSPACE_PATH=/mnt/c/Users/shing/projects
```

#### クリップボード
Windowsではクリップボード共有に制限があります。WSL2経由での使用を推奨。

### Linux

#### X11転送（GUI Neovim用）
GUI版のNeovimを使いたい場合：

```yaml
# docker-compose.yml に追加
volumes:
  - /tmp/.X11-unix:/tmp/.X11-unix
environment:
  - DISPLAY=${DISPLAY}
```

```bash
# X11アクセスを許可
xhost +local:docker
```

### macOS

#### ファイルパーミッション
macOSでボリュームマウント時にパーミッションエラーが出る場合：

```bash
# Docker Desktop の設定で File Sharing にディレクトリを追加
# Preferences > Resources > File Sharing
```

## 📝 便利なエイリアス

`~/.bashrc` または `~/.zshrc` に追加：

```bash
# Neovim Dockerのエイリアス
alias dnvim='docker-compose -f ~/neovim-docker/docker-compose.yml run --rm neovim'
alias dnvim-shell='docker-compose -f ~/neovim-docker/docker-compose.yml run --rm shell'
alias dnvim-build='docker-compose -f ~/neovim-docker/docker-compose.yml build'

# 使用例
dnvim myfile.py
dnvim-shell
```

## 🐛 トラブルシューティング

### プラグインがインストールされない

```bash
# コンテナ内で手動インストール
docker-compose run --rm shell
nvim
:Lazy sync
```

### 設定ファイルが見つからない

```bash
# パスを確認
docker-compose run --rm shell
ls -la /root/.config/nvim

# マウントが正しいか確認
docker-compose config
```

### LSPが動かない

```bash
# Masonでインストール状況を確認
:Mason
:LspInfo

# 手動でLSPサーバーをインストール
:MasonInstall pyright typescript-language-server
```

### パフォーマンスが悪い

```yaml
# docker-compose.yml でリソース制限を調整
deploy:
  resources:
    limits:
      cpus: '4'
      memory: 8G
```

### ボリュームのリセット

```bash
# 全ボリュームを削除して再作成
docker-compose down -v
docker-compose build --no-cache
docker-compose run --rm neovim
```

## 📂 ディレクトリ構造

```
neovim-docker/
├── Dockerfile              # メインのDockerfile
├── docker-compose.yml      # Docker Compose設定
├── .env                    # 環境変数（要作成）
├── .env.example            # 環境変数のテンプレート
└── README.md              # このファイル
```

## 🔄 更新とメンテナンス

### イメージの更新

```bash
# 最新のベースイメージで再ビルド
docker-compose build --no-cache

# 不要なイメージを削除
docker image prune -a
```

### ボリュームのバックアップ

```bash
# プラグインデータのバックアップ
docker run --rm -v neovim-docker_nvim-data:/data -v $(pwd):/backup ubuntu tar czf /backup/nvim-data-backup.tar.gz -C /data .

# リストア
docker run --rm -v neovim-docker_nvim-data:/data -v $(pwd):/backup ubuntu tar xzf /backup/nvim-data-backup.tar.gz -C /data
```

## 📚 参考リンク

- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 🤝 コントリビューション

改善提案やバグ報告は Issue または Pull Request でお願いします。

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

---

**作成者**: SHINGO  
**最終更新**: 2024
