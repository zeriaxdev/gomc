# Simple Go Web Application Boilerplate

This is a basic Go web application boilerplate that serves a simple HTML page.
It includes a Makefile for common development and build tasks, including cross-compilation and hot-reloading.

## Features

- Simple HTTP server serving static files.
- Serves `web/index.html` at the root path (`/`).
- Listens on port 3000 by default, configurable via the `PORT` environment variable.
- Makefile for easy building, running, and development.
- Supports building for Linux, macOS (Darwin), and Windows for `amd64` and `arm64` architectures.
- Hot reloading for development using [Air](https://github.com/air-verse/air).

## Prerequisites

- Go (version 1.18 or later recommended)
- Make
- (Optional, for `make dev`) Access to install Go packages (`go install ...`)

## Getting Started

1.  **Clone the repository (if applicable):**

    ```bash
    # git clone <repository-url>
    # cd <repository-directory>
    ```

2.  **Initialize Go module:**
    This command initializes the Go module (`go.mod` and `go.sum`) if it doesn't exist.
    ```bash
    make init
    ```

## Usage

### Development (with Hot Reloading)

To run the application in development mode with automatic rebuilding and restarting when Go or HTML files change, use:

```bash
make dev
```

This command will first check if the `air` tool is installed. If not, it will attempt to install it using `go install github.com/air-verse/air@latest`. Ensure that your `$GOPATH/bin` is in your system's `PATH`.

The server will start on port 3000 (or the port specified in `.air.toml`). Note that `make dev` always runs natively on your current system.

### Building

The Makefile provides targets to build the application for different Operating Systems (`GOOS`) and Architectures (`ARCH`). By default, `make build` builds for your current system.

- **Build for your current system (Host OS/ARCH):**

  ```bash
  make build
  ```

  The binary will be created in the `bin/` directory, named like `bin/go-app-<os>-<arch>` (e.g., `bin/go-app-darwin-arm64` or `bin/go-app-linux-amd64.exe`).

- **Build for a specific target:**

  You can override `GOOS` and `ARCH`:

  ```bash
  # Build for Linux AMD64
  make build GOOS=linux ARCH=amd64

  # Build for Windows ARM64
  make build GOOS=windows ARCH=arm64
  ```

  The binary will be named accordingly (e.g., `bin/go-app-linux-amd64`, `bin/go-app-windows-arm64.exe`).

- **Convenience Targets:**

  Common targets are provided:

  ```bash
  make build-linux-amd64
  make build-linux-arm64
  make build-darwin-amd64  # macOS Intel
  make build-darwin-arm64  # macOS Apple Silicon
  make build-windows-amd64
  make build-windows-arm64
  ```

  **Note on CGO:** CGO is automatically disabled (`CGO_ENABLED=0`) when cross-compiling (when `GOOS`/`ARCH` is different from your host system) to avoid potential compilation issues. It's enabled only for native builds.

### Running the Application

- **Run using `go run` (Recommended for local execution):**

  This command compiles and runs the application directly without creating a persistent binary in `bin/`.

  ```bash
  make run
  ```

  To specify a different port:

  ```bash
  PORT=9000 make run
  ```

- **Running a specific built binary:**

  After building for a specific target (e.g., `make build-linux-amd64`), you can execute the binary directly:

  ```bash
  # Example for Linux AMD64 build
  ./bin/go-app-linux-amd64

  # Example for Windows AMD64 build (from PowerShell/CMD)
  .\bin\go-app-windows-amd64.exe

  # With a custom port
  PORT=9000 ./bin/go-app-linux-amd64
  ```

  _Remember you can only run binaries compiled for your current operating system and architecture._

### Cleaning

To remove the build artifacts (the `bin` directory):

```bash
make clean
```

## Project Structure

```
.
├── .air.toml       # Configuration for the Air hot-reloading tool
├── Makefile        # Defines build, run, and development tasks
├── go.mod          # Go module definition (created by 'make init')
├── go.sum          # Go module checksums (created by 'make init')
├── main.go         # Main application source code
├── web/
│   └── index.html  # Simple HTML page served by the application
└── README.md       # This file
```
