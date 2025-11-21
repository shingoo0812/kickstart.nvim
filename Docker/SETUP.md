
# Neovim Docker環境の配置方法

## 📁 推奨ディレクトリ構成

```
kickstart.nvim/                    # あなたのNeovimリポジトリ
├── .git/
├── .github/
├── lua/
│   ├── config/
│   ├── plugins/                   # 58個のプラグイン設定
│   └── snippets/
├── init.lua
├── lazy-lock.json
├── README.md
├── .gitignore                     # 更新が必要
└── docker/                        # ← 新規追加
    ├── Dockerfile
    ├── docker-compose.yml
    ├── .env.example
    ├── .dockerignore
    ├── Makefile
    └── README.md
```

## 🚀 セットアップ手順

### 1. dockerディレクトリを作成
```bash
cd ~/AppData/Local/nvim
mkdir docker
cd docker

# 作成したファイルを配置
# （neovim-docker-config.tar.gz を展開）
```

### 2. .gitignoreを更新
```bash
# ~/AppData/Local/nvim/.gitignore に追加
echo "" >> ../.gitignore
echo "# Docker environment" >> ../.gitignore
echo "docker/.env" >> ../.gitignore
echo "docker/*.log" >> ../.gitignore
```

### 3. docker-compose.ymlのパス調整
```yaml
# docker/docker-compose.yml を編集
volumes:
  # 相対パスで親ディレクトリを参照
  - ..:/root/.config/nvim:ro  # <- この行を変更
```

### 4. Gitにコミット
```bash
cd ~/AppData/Local/nvim
git add docker/
git add .gitignore
git commit -m "Add Docker environment for portable Neovim setup"
git push
```

## 💡 新しいマシンでの使い方

```bash
# 1. リポジトリをクローン
git clone https://github.com/shingoo0812/kickstart.nvim.git ~/.config/nvim
# または Windows: C:/Users/YourName/AppData/Local/nvim

# 2. Docker環境をセットアップ
cd ~/.config/nvim/docker
cp .env.example .env
# .envを編集（パスを設定）

# 3. ビルドと起動
make install
make nvim
```

## 📝 READMEの更新提案

メインのREADME.mdに以下のセクションを追加：

```markdown
## 🐳 Docker環境での使用

ローカルに依存せず、どの環境でも同じNeovim環境を使用できます。

### 前提条件
- Docker Desktop (Windows/Mac) または Docker Engine (Linux)

### セットアップ
\`\`\`bash
cd docker
cp .env.example .env
# .envを編集してパスを設定
make install
\`\`\`

### 使い方
\`\`\`bash
make nvim        # Neovimを起動
make shell       # シェルを開く
make update      # プラグイン更新
\`\`\`

詳細は[docker/README.md](docker/README.md)を参照。
```

---

## ⚖️ 別リポジトリにする場合との比較

### 別リポジトリのメリット
- Docker環境を独立して管理
- 複数のNeovim設定で共用可能
- リポジトリサイズが小さい

### 別リポジトリのデメリット
- 2つのリポジトリをクローン必要
- 設定とDockerのバージョン同期が面倒
- 初期セットアップが複雑

### 結論
**個人使用なら同じリポジトリ、複数人で共有するなら別リポジトリ**がベストです。

SHINGOさんの場合、個人のdotfiles管理なので**同じリポジトリに入れるのが最適**です。
