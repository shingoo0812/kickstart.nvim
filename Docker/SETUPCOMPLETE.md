# 🚀 Neovim Docker環境 完全セットアップガイド

## 📋 目次

1. [前提条件](#前提条件)
2. [初回セットアップ](#初回セットアップ)
3. [ファイルの配置](#ファイルの配置)
4. [ビルドと起動](#ビルドと起動)
5. [トラブルシューティング](#トラブルシューティング)
6. [次回以降の使用](#次回以降の使用)

---

## 前提条件

✅ 以下がインストール済みであること：
- WSL2 (Ubuntu 24.04)
- Docker
- Docker Compose v2.24.5+
- Git

確認方法：
```bash
docker --version
docker-compose --version
git --version
```

---

## 初回セットアップ

### ステップ1: Dockerデーモンの起動

```bash
# Dockerデーモンを起動
sudo service docker start

# 自動起動設定（パスワードなし）
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/service docker start" | sudo tee /etc/sudoers.d/docker-service
echo 'sudo service docker start' >> ~/.bashrc
```

### ステップ2: Docker権限設定

```bash
# ユーザーをdockerグループに追加
sudo usermod -aG docker $USER

# WSLを再起動（PowerShellで実行）
# wsl --shutdown
# wsl

# 確認
docker ps
```

### ステップ3: プロジェクトディレクトリの作成

```bash
# ワークスペースディレクトリを作成
mkdir -p /home/shingo/projects

# テスト用ファイルを作成
echo "print('Hello from Docker Neovim!')" > /home/shingo/projects/test.py
```

---

## ファイルの配置

### ステップ1: 既存ファイルのバックアップ

```bash
cd ~/dotfiles/linux/nvim/Docker

# 既存ファイルをバックアップ
mv Dockerfile Dockerfile.old
mv docker-compose.yml docker-compose.yml.old
```

### ステップ2: 新しいファイルをダウンロード

ダウンロードした以下のファイルを配置：

1. **Dockerfile-complete** → `Dockerfile` にリネーム
2. **docker-compose-complete.yml** → `docker-compose.yml` にリネーム  
3. **env-complete** → `.env` にリネーム

```bash
# 例：ダウンロードフォルダから移動する場合
cd ~/dotfiles/linux/nvim/Docker
cp ~/Downloads/Dockerfile-complete ./Dockerfile
cp ~/Downloads/docker-compose-complete.yml ./docker-compose.yml
cp ~/Downloads/env-complete ./.env
```

### ステップ3: lazy-lock.jsonの準備

```bash
cd ~/dotfiles/linux/nvim

# 既存のlazy-lock.jsonがディレクトリになっている場合は削除
rm -rf lazy-lock.json

# 空のJSONファイルとして作成
echo '{}' > lazy-lock.json

# 確認
ls -la lazy-lock.json
cat lazy-lock.json
```

### ステップ4: .envファイルの編集

```bash
cd ~/dotfiles/linux/nvim/Docker
vim .env
```

内容を確認・修正：
```bash
# ワークスペースのパス（必要に応じて変更）
WORKSPACE_PATH=/home/shingo/projects
```

保存して終了（`:wq`）

---

## ビルドと起動

### ステップ1: Dockerイメージのビルド

```bash
cd ~/dotfiles/linux/nvim/Docker

# ビルド（初回は10-20分程度かかります）
docker-compose build

# ビルドログを確認
# ✅ 各ステップでエラーが出ないこと
# ✅ "Successfully tagged docker-neovim:latest" が表示されること
```

**重要なチェックポイント：**
- Node.js 20.x がインストールされる
- Neovim 0.11+ がインストールされる
- lazy.nvim がcloneされる
- エラーなく完了する

### ステップ2: Neovimの起動

```bash
# Neovimを起動
docker-compose run --rm neovim
```

**起動時の表示：**
```
🚀 Starting Neovim Docker Environment...
📂 Workspace: /workspace
⚙️  Config: /root/.config/nvim
💻 Neovim: NVIM v0.11.x
📦 Node.js: v20.x.x
🐍 Python: Python 3.12.x
```

### ステップ3: プラグインのインストール

Neovimが起動したら：

```vim
" エラーメッセージが表示される場合はEnterで進む
Enter

" Lazyを開く
:Lazy

" 全プラグインをインストール
:Lazy sync
```

**インストールが完了するまで待つ（5-10分程度）**

完了したら：
```vim
:qa
```

で一度終了。

### ステップ4: 再起動して確認

```bash
docker-compose run --rm neovim
```

今度はエラーなく起動するはずです！

---

## 基本的な使い方

### Neovimの起動

```bash
cd ~/dotfiles/linux/nvim/Docker

# Neovimを起動
docker-compose run --rm neovim

# 特定のファイルを開く
docker-compose run --rm neovim /workspace/test.py

# シェルを起動
docker-compose run --rm shell
```

### ファイル編集

Neovim内で：
```vim
" ワークスペース内のファイルを開く
:e /workspace/test.py

" Neo-treeでファイルブラウザ
:Neotree /workspace

" Telescopeでファイル検索
:Telescope find_files cwd=/workspace
```

### エイリアスの設定（オプション）

```bash
# ~/.bashrc または ~/.zshrc に追加
echo 'alias dnvim="cd ~/dotfiles/linux/nvim/Docker && docker-compose run --rm neovim"' >> ~/.bashrc
echo 'alias dnvim-shell="cd ~/dotfiles/linux/nvim/Docker && docker-compose run --rm shell"' >> ~/.bashrc
source ~/.bashrc

# 使い方
dnvim                      # Neovim起動
dnvim /workspace/test.py   # ファイルを開く
dnvim-shell                # シェル起動
```

---

## トラブルシューティング

### ビルド時のネットワークエラー

```bash
# エラー: "Connection timed out"
# 解決: リトライする（Dockerfileにリトライ機能が組み込まれています）

# それでもダメな場合
docker-compose build --no-cache
```

### lazy.nvimがインストールされない

```bash
# コンテナ内で確認
docker-compose run --rm shell
ls -la /root/.local/share/nvim/lazy/lazy.nvim

# ない場合は手動でインストール
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable \
  /root/.local/share/nvim/lazy/lazy.nvim
exit

# Neovim再起動
docker-compose run --rm neovim
```

### 設定ファイルが読み込まれない

```bash
# コンテナ内で確認
docker-compose run --rm shell
ls -la /root/.config/nvim/init.lua

# ない場合はマウントが失敗している
# docker-compose.ymlのvolumesを確認
```

### プラグインのエラー

```vim
" Neovim内で
:checkhealth
:Lazy restore
:Lazy sync
```

### Dockerボリュームのリセット

```bash
# 全て削除して再構築
docker-compose down -v
docker-compose build --no-cache
docker-compose run --rm neovim
```

---

## 次回以降の使用

### 新しいマシンでのセットアップ

```bash
# 1. リポジトリをclone
git clone <your-dotfiles-repo> ~/dotfiles
cd ~/dotfiles/linux/nvim/Docker

# 2. .envファイルを編集（パスを環境に合わせる）
vim .env

# 3. ビルド
docker-compose build

# 4. 起動
docker-compose run --rm neovim

# 5. プラグインインストール
:Lazy sync
```

### 設定の更新

```bash
# Neovim設定を変更（ホスト側で）
vim ~/dotfiles/linux/nvim/init.lua

# 変更はすぐに反映される（再ビルド不要）
docker-compose run --rm neovim
```

### Dockerイメージの更新

```bash
# ツールのバージョンアップなど
cd ~/dotfiles/linux/nvim/Docker
docker-compose build --no-cache
```

---

## ファイル構成

最終的なディレクトリ構成：

```
~/dotfiles/linux/nvim/
├── lua/
│   ├── config/
│   ├── plugins/          # 58個のプラグイン設定
│   └── snippets/
├── init.lua
├── lazy-lock.json        # JSONファイル（重要）
├── README.md
└── Docker/
    ├── Dockerfile        # 完全版
    ├── docker-compose.yml # 完全版
    ├── .env              # 環境変数
    ├── .dockerignore
    └── Makefile
```

---

## チェックリスト

セットアップ完了の確認：

- [ ] `docker ps` が動く
- [ ] `docker-compose build` がエラーなく完了
- [ ] `lazy-lock.json` がファイル（ディレクトリではない）
- [ ] `.env` に正しいパスが設定されている
- [ ] `docker-compose run --rm neovim` でNeovimが起動
- [ ] `:Lazy` でLazy.nvimが開く
- [ ] `:Lazy sync` でプラグインがインストールされる
- [ ] エラーなくNeovimが使える

---

## よくある質問

### Q: ビルドに時間がかかる
A: 初回は10-20分程度かかります。2回目以降はキャッシュが効いて数秒で完了します。

### Q: lazy-lock.jsonが更新されない
A: docker-compose.ymlで`:rw`（読み書き可能）でマウントされているか確認してください。

### Q: プラグインが多すぎて遅い
A: 不要なプラグインを`lua/plugins/`から削除するか、コメントアウトしてください。

### Q: WindowsとWSLの両方で使いたい
A: それぞれ別の`.env`ファイルを用意するか、パスを切り替えてください。

---

## 次のステップ

1. **プラグインのカスタマイズ**：`lua/plugins/`の設定を自分好みに
2. **キーマップの調整**：`init.lua`のキーバインドを変更
3. **LSPの追加**：`:Mason`で必要なLSPサーバーをインストール
4. **dotfilesをGitで管理**：変更をcommit & push

---

**これで完全なDocker環境が完成です！🎉**

問題があれば、トラブルシューティングセクションを参照してください。
