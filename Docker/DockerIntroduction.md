# Docker環境構築まとめ

## 🎯 最終的に動いた構成

- **OS**: WSL2 (Ubuntu 24.04)
- **Docker**: 28.2.2
- **Docker Compose**: v2.24.5 (スタンドアロン版、`docker-compose`コマンド)

## 📋 セットアップ手順

### 1. Dockerデーモンの起動と自動起動設定

```bash
# Dockerデーモンを起動
sudo service docker start

# WSL起動時に自動でDockerを起動（パスワードなし）
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/service docker start" | sudo tee /etc/sudoers.d/docker-service
echo 'sudo service docker start' >> ~/.bashrc
```

### 2. Docker Composeのインストール

```bash
# Docker Compose v2をダウンロード
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 実行権限を付与
sudo chmod +x /usr/local/bin/docker-compose

# 確認
/usr/local/bin/docker-compose --version
```

### 3. Docker権限設定

```bash
# ユーザーをdockerグループに追加
sudo usermod -aG docker $USER

# WSLを再起動（PowerShellで実行）
# wsl --shutdown
# wsl

# 確認
docker ps
```

### 4. 環境変数の設定

```bash
# DOCKER_HOST設定が邪魔していた場合は削除
unset DOCKER_HOST

# ~/.bashrcに追記して永続化（必要に応じて）
echo 'unset DOCKER_HOST' >> ~/.bashrc
```

## 🚀 使い方

### Neovim Docker環境のビルドと起動

```bash
# プロジェクトディレクトリに移動
cd ~/dotfiles/linux/nvim/Docker

# .envファイルを作成
cp .env.example .env
vim .env  # パスを編集

# イメージをビルド
docker-compose build

# Neovimを起動
docker-compose run --rm neovim

# シェルを起動
docker-compose run --rm shell
```

### .envファイルの設定例（WSL）

```bash
# WSL Linuxの場合
WORKSPACE_PATH=/home/shingo/projects
```

※ `NVIM_CONFIG_PATH`は不要（`docker-compose.yml`で`..`を使用しているため）

## 📝 重要なポイント

### コマンドの違い

```bash
# ✅ 使えるコマンド
docker-compose build              # ハイフン（スタンドアロン版）
/usr/local/bin/docker-compose    # フルパス

# ❌ 使えないコマンド
docker compose build              # スペース（pluginがないため）
```

### トラブルシューティング

```bash
# Dockerデーモンが動いているか確認
sudo service docker status

# 権限エラーが出る場合
sudo usermod -aG docker $USER
# その後、WSLを完全再起動

# PATHが通っていない場合
/usr/local/bin/docker-compose --version
```

## 🔄 WSL再起動後の手順

```bash
# 1. Dockerデーモン起動（自動起動設定済みなら不要）
sudo service docker start

# 2. 確認
docker ps

# 3. Neovim起動
cd ~/dotfiles/linux/nvim/Docker
docker-compose run --rm neovim
```

## ✅ 動作確認

```bash
# 全てエラーなく動けばOK
docker ps
docker-compose --version
docker-compose build
docker-compose run --rm neovim --version
```

これで完了です！
