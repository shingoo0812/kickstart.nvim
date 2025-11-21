# ============================================================================
# Makefile for Neovim Docker Environment
# ============================================================================
# Convenient commands to manage the Neovim Docker environment
# ============================================================================

.PHONY: help build rebuild up down shell nvim clean prune logs install update backup restore

# Default target
help:
	@echo "Neovim Docker Environment - Available Commands"
	@echo "================================================"
	@echo ""
	@echo "Setup & Build:"
	@echo "  make build       - Build the Docker image"
	@echo "  make rebuild     - Rebuild the image from scratch (no cache)"
	@echo "  make install     - Initial setup (copy .env, build image)"
	@echo ""
	@echo "Run:"
	@echo "  make nvim        - Start Neovim"
	@echo "  make shell       - Open shell in container"
	@echo "  make up          - Start services in background"
	@echo "  make down        - Stop all services"
	@echo ""
	@echo "Maintenance:"
	@echo "  make update      - Update plugins in Neovim"
	@echo "  make clean       - Stop containers and remove volumes"
	@echo "  make prune       - Remove all unused Docker resources"
	@echo "  make logs        - Show container logs"
	@echo ""
	@echo "Backup & Restore:"
	@echo "  make backup      - Backup plugin data to nvim-data-backup.tar.gz"
	@echo "  make restore     - Restore plugin data from backup"
	@echo ""

# Build the Docker image
build:
	@echo "🔨 Building Neovim Docker image..."
	docker-compose build

# Rebuild without cache
rebuild:
	@echo "🔨 Rebuilding Neovim Docker image from scratch..."
	docker-compose build --no-cache

# Initial installation
install:
	@echo "📦 Initial setup..."
	@if [ ! -f .env ]; then \
		echo "📝 Creating .env file from .env.example..."; \
		cp .env.example .env; \
		echo "⚠️  Please edit .env file to set correct paths!"; \
	else \
		echo "✅ .env file already exists"; \
	fi
	@make build

# Start Neovim
nvim:
	@echo "🚀 Starting Neovim..."
	docker-compose run --rm neovim

# Open specific file
open:
	@if [ -z "$(FILE)" ]; then \
		echo "❌ Usage: make open FILE=path/to/file"; \
		exit 1; \
	fi
	@echo "📂 Opening $(FILE)..."
	docker-compose run --rm neovim /workspace/$(FILE)

# Open shell
shell:
	@echo "🐚 Opening shell..."
	docker-compose run --rm shell

# Start services in background
up:
	@echo "▶️  Starting services..."
	docker-compose up -d

# Stop services
down:
	@echo "⏹️  Stopping services..."
	docker-compose down

# Show logs
logs:
	@echo "📋 Showing logs..."
	docker-compose logs -f

# Update Neovim plugins
update:
	@echo "🔄 Updating Neovim plugins..."
	docker-compose run --rm neovim -c "Lazy sync" -c "qa"

# Clean up (remove containers and volumes)
clean:
	@echo "🧹 Cleaning up containers and volumes..."
	@read -p "This will remove all data including installed plugins. Continue? [y/N] " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		docker-compose down -v; \
		echo "✅ Cleanup complete"; \
	else \
		echo "❌ Cleanup cancelled"; \
	fi

# Prune all unused Docker resources
prune:
	@echo "🧹 Pruning unused Docker resources..."
	@read -p "This will remove all unused images, containers, and networks. Continue? [y/N] " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		docker system prune -a --volumes; \
		echo "✅ Prune complete"; \
	else \
		echo "❌ Prune cancelled"; \
	fi

# Backup plugin data
backup:
	@echo "💾 Backing up Neovim plugin data..."
	@PROJECT_NAME=$$(basename $$(pwd)) && \
	VOLUME_NAME=$${PROJECT_NAME}_nvim-data && \
	docker run --rm \
		-v $$VOLUME_NAME:/data \
		-v $$(pwd):/backup \
		ubuntu tar czf /backup/nvim-data-backup.tar.gz -C /data . && \
	echo "✅ Backup saved to nvim-data-backup.tar.gz"

# Restore plugin data from backup
restore:
	@if [ ! -f nvim-data-backup.tar.gz ]; then \
		echo "❌ Backup file not found: nvim-data-backup.tar.gz"; \
		exit 1; \
	fi
	@echo "📥 Restoring Neovim plugin data..."
	@read -p "This will overwrite current plugin data. Continue? [y/N] " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		PROJECT_NAME=$$(basename $$(pwd)) && \
		VOLUME_NAME=$${PROJECT_NAME}_nvim-data && \
		docker run --rm \
			-v $$VOLUME_NAME:/data \
			-v $$(pwd):/backup \
			ubuntu tar xzf /backup/nvim-data-backup.tar.gz -C /data && \
		echo "✅ Restore complete"; \
	else \
		echo "❌ Restore cancelled"; \
	fi

# Show container status
status:
	@echo "📊 Container status:"
	@docker-compose ps

# Show volume information
volumes:
	@echo "💾 Volume information:"
	@docker volume ls | grep neovim

# Open Neovim config in host editor (for quick edits)
config:
	@if [ -n "$$EDITOR" ]; then \
		$$EDITOR ~/.config/nvim/init.lua; \
	else \
		echo "❌ EDITOR environment variable not set"; \
		echo "Set it with: export EDITOR=nvim (or vim, code, etc.)"; \
	fi

# Quick health check
health:
	@echo "🏥 Running Neovim health check..."
	docker-compose run --rm neovim -c "checkhealth" -c "qa"

# Show Docker disk usage
disk:
	@echo "💿 Docker disk usage:"
	@docker system df
