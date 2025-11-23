# ============================================================================
# Neovim Development Environment - Makefile
# ============================================================================
# Usage:
#   make build    - Build the complete Docker image
#   make save     - Save image to tar.gz file
#   make load     - Load image from tar.gz file
#   make run      - Run Neovim with mounted config
#   make shell    - Run bash shell
#   make clean    - Remove Docker image
#   make help     - Show this help
# ============================================================================

# Variables
IMAGE_NAME := neovim-dev
IMAGE_TAG := latest
IMAGE_FULL := $(IMAGE_NAME):$(IMAGE_TAG)
EXPORT_FILE := $(IMAGE_NAME).tar.gz
NVIM_CONFIG := $(shell cd .. && pwd)
WORKSPACE := $(HOME)/projects

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# ============================================================================
# Main targets
# ============================================================================

.PHONY: help
help:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BLUE)  Neovim Development Environment - Makefile$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(GREEN)Build & Distribution:$(NC)"
	@echo "  make build       - Build complete Docker image"
	@echo "  make save        - Save image to $(EXPORT_FILE)"
	@echo "  make load        - Load image from $(EXPORT_FILE)"
	@echo ""
	@echo "$(GREEN)Run:$(NC)"
	@echo "  make run         - Run Neovim with mounted config"
	@echo "  make shell       - Run bash shell"
	@echo "  make run-file    - Run Neovim with specific file (FILE=path/to/file)"
	@echo ""
	@echo "$(GREEN)Maintenance:$(NC)"
	@echo "  make clean       - Remove Docker image"
	@echo "  make rebuild     - Clean and rebuild"
	@echo "  make info        - Show image information"
	@echo ""
	@echo "$(GREEN)Workflow:$(NC)"
	@echo "  make check       - Check requirements"
	@echo "  make all         - Build and save (distribution package)"
	@echo ""

.PHONY: check
check:
	@echo "$(BLUE)Checking requirements...$(NC)"
	@command -v docker >/dev/null 2>&1 || { echo "$(RED)✗ Docker not found$(NC)"; exit 1; }
	@echo "$(GREEN)✓ Docker found: $$(docker --version)$(NC)"
	@[ -f "Dockerfile" ] || { echo "$(RED)✗ Dockerfile not found$(NC)"; exit 1; }
	@echo "$(GREEN)✓ Dockerfile found$(NC)"
	@[ -d "$(NVIM_CONFIG)" ] || { echo "$(YELLOW)⚠ Neovim config not found at $(NVIM_CONFIG)$(NC)"; }
	@echo "$(GREEN)✓ All checks passed$(NC)"

# ============================================================================
# Build targets
# ============================================================================

.PHONY: build
build: check
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BLUE)  Building $(IMAGE_FULL)...$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(YELLOW)⚠ This may take 20-30 minutes...$(NC)"
	@docker build -t $(IMAGE_FULL) .
	@echo ""
	@echo "$(GREEN)✓ Build completed successfully!$(NC)"
	@echo "$(BLUE)Image: $(IMAGE_FULL)$(NC)"
	@echo "$(BLUE)Size:  $$(docker images $(IMAGE_NAME) --format '{{.Size}}')$(NC)"

.PHONY: rebuild
rebuild: clean build

# ============================================================================
# Distribution targets
# ============================================================================

.PHONY: save
save:
	@echo "$(BLUE)Saving $(IMAGE_FULL) to $(EXPORT_FILE)...$(NC)"
	@docker save $(IMAGE_FULL) | gzip > $(EXPORT_FILE)
	@echo "$(GREEN)✓ Image saved to $(EXPORT_FILE)$(NC)"
	@echo "$(BLUE)Size: $$(du -h $(EXPORT_FILE) | cut -f1)$(NC)"
	@echo ""
	@echo "$(YELLOW)Distribution package created!$(NC)"
	@echo "Transfer $(EXPORT_FILE) to target machine and run:"
	@echo "  make load"

.PHONY: load
load:
	@if [ ! -f "$(EXPORT_FILE)" ]; then \
		echo "$(RED)✗ $(EXPORT_FILE) not found$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)Loading $(EXPORT_FILE)...$(NC)"
	@docker load < $(EXPORT_FILE)
	@echo "$(GREEN)✓ Image loaded successfully!$(NC)"
	@docker images $(IMAGE_NAME)

.PHONY: all
all: build save
	@echo ""
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)  Distribution package ready!$(NC)"
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "File: $(EXPORT_FILE)"
	@echo "Size: $$(du -h $(EXPORT_FILE) | cut -f1)"

# ============================================================================
# Run targets
# ============================================================================

.PHONY: run
run:
	@echo "$(BLUE)Starting Neovim...$(NC)"
	@docker run -it --rm \
		-v $(NVIM_CONFIG):/root/.config/nvim:ro \
		-v $(NVIM_CONFIG)/lazy-lock.json:/root/.config/nvim/lazy-lock.json:rw \
		-v $(WORKSPACE):/workspace \
		--name neovim-dev-container \
		$(IMAGE_FULL)

.PHONY: run-file
run-file:
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)✗ Usage: make run-file FILE=path/to/file$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)Opening $(FILE)...$(NC)"
	@docker run -it --rm \
		-v $(NVIM_CONFIG):/root/.config/nvim:ro \
		-v $(NVIM_CONFIG)/lazy-lock.json:/root/.config/nvim/lazy-lock.json:rw \
		-v $(WORKSPACE):/workspace \
		--name neovim-dev-container \
		$(IMAGE_FULL) $(FILE)

.PHONY: shell
shell:
	@echo "$(BLUE)Starting bash shell...$(NC)"
	@docker run -it --rm \
		-v $(NVIM_CONFIG):/root/.config/nvim:ro \
		-v $(NVIM_CONFIG)/lazy-lock.json:/root/.config/nvim/lazy-lock.json:rw \
		-v $(WORKSPACE):/workspace \
		--entrypoint /bin/bash \
		--name neovim-dev-shell \
		$(IMAGE_FULL)

# ============================================================================
# Maintenance targets
# ============================================================================

.PHONY: clean
clean:
	@echo "$(YELLOW)Removing $(IMAGE_FULL)...$(NC)"
	@docker rmi $(IMAGE_FULL) 2>/dev/null || true
	@echo "$(GREEN)✓ Cleaned$(NC)"

.PHONY: clean-all
clean-all: clean
	@echo "$(YELLOW)Removing $(EXPORT_FILE)...$(NC)"
	@rm -f $(EXPORT_FILE)
	@echo "$(GREEN)✓ All cleaned$(NC)"

.PHONY: info
info:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BLUE)  Image Information$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "Image:       $(IMAGE_FULL)"
	@echo "Config:      $(NVIM_CONFIG)"
	@echo "Workspace:   $(WORKSPACE)"
	@echo "Export file: $(EXPORT_FILE)"
	@echo ""
	@docker images $(IMAGE_NAME) 2>/dev/null || echo "$(YELLOW)⚠ Image not built yet$(NC)"

# ============================================================================
# Special targets
# ============================================================================

.DEFAULT_GOAL := help

.PHONY: .check-image
.check-image:
	@docker images -q $(IMAGE_FULL) >/dev/null 2>&1 || { \
		echo "$(RED)✗ Image $(IMAGE_FULL) not found$(NC)"; \
		echo "$(YELLOW)Run 'make build' or 'make load' first$(NC)"; \
		exit 1; \
	}

run shell run-file: .check-image
