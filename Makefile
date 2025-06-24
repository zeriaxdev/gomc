# Go parameters
GO = go
APP_NAME = go-app

# Build parameters - Default to host OS/ARCH, allow overrides
HOST_GOOS := $(shell $(GO) env GOOS)
HOST_GOARCH := $(shell $(GO) env GOARCH)
GOOS ?= $(HOST_GOOS)
ARCH ?= $(HOST_GOARCH)

# Determine binary suffix for Windows
ifeq ($(GOOS), windows)
    BINARY_SUFFIX = .exe
else
    BINARY_SUFFIX =
endif

# Target directories
BUILD_DIR = bin
BINARY_NAME = $(APP_NAME)-$(GOOS)-$(ARCH)$(BINARY_SUFFIX)
OUTPUT_PATH = $(BUILD_DIR)/$(BINARY_NAME)

# Cross-compilation flag (disable CGO for simplicity in cross-compiling)
CGO_FLAG = CGO_ENABLED=0
# Enable CGO only if building for the host OS/ARCH
ifeq ($(GOOS)-$(ARCH), $(HOST_GOOS)-$(HOST_GOARCH))
	CGO_FLAG = CGO_ENABLED=1
endif

.PHONY: all build build-linux-amd64 build-linux-arm64 build-darwin-amd64 build-darwin-arm64 build-windows-amd64 build-windows-arm64 run dev clean install-air check-air init

all: build

# Build the application for the specified GOOS/ARCH
build: check-air
	@echo "Building for GOOS=$(GOOS) GOARCH=$(ARCH)... (CGO: $(if $(CGO_FLAG),1,0))"
	@mkdir -p $(BUILD_DIR)
	$(CGO_FLAG) GOOS=$(GOOS) GOARCH=$(ARCH) $(GO) build -o $(OUTPUT_PATH) .
	@echo "Build complete: $(OUTPUT_PATH)"

# Specific build targets
build-linux-amd64: 
	$(MAKE) build GOOS=linux ARCH=amd64
build-linux-arm64: 
	$(MAKE) build GOOS=linux ARCH=arm64
build-darwin-amd64: 
	$(MAKE) build GOOS=darwin ARCH=amd64
build-darwin-arm64: 
	$(MAKE) build GOOS=darwin ARCH=arm64
build-windows-amd64: 
	$(MAKE) build GOOS=windows ARCH=amd64
build-windows-arm64: 
	$(MAKE) build GOOS=windows ARCH=arm64

# Run the application directly using go run
run:
	@echo "Running the application using go run (PORT env var can be used)..."
	$(GO) run .

# Run the application in development mode with hot reload using air
# Installs air if not present
dev: check-air .air.toml
	@echo "Starting development server with hot reload..."
	air

# Check if air is installed, install if not
check-air:
	@if ! command -v air &> /dev/null; then \
		echo "air not found. Installing air..."; \
		$(MAKE) install-air; \
	fi

# Install air
install-air:
	@echo "Installing air tool..."
	$(GO) install github.com/air-verse/air@latest
	@echo "air installed successfully to $(shell go env GOPATH)/bin. Make sure this is in your PATH."


# Clean the build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "Clean complete."

# Initialize go mod if go.mod doesn't exist
init:
	@if [ ! -f go.mod ]; then \
		echo "go.mod not found. Initializing module..."; \
		$(GO) mod init example.com/$(APP_NAME); \
		$(GO) mod tidy; \
	else \
		echo "go.mod already exists."; \
	fi 