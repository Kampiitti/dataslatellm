# Runtime Binaries

Place llama.cpp server binaries here for each platform.

## Directory Structure

```
runtime/
├── linux/
│   └── llama-server          # Linux x64 binary
├── macos/
│   └── llama-server          # macOS binary (arm64 or x64)
└── windows/
    └── llama-server.exe      # Windows binary
```

## Getting Binaries

### Option 1: Download Pre-built (Easiest)

Visit: https://github.com/ggerganov/llama.cpp/releases

Download the appropriate package:
- **Linux**: `llama-*-linux-x64.zip`
- **macOS ARM (M1/M2)**: `llama-*-macos-arm64.zip`
- **macOS Intel**: `llama-*-macos-x64.zip`
- **Windows**: `llama-*-windows-x64.zip`

Extract and copy the `llama-server` (or `llama-server.exe`) binary to the appropriate subdirectory.

### Option 2: Compile from Source (Best Performance)

```bash
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp

# Linux/macOS
make

# macOS with GPU acceleration
make LLAMA_METAL=1

# NVIDIA GPU
make LLAMA_CUBLAS=1

# Copy to runtime directory
cp llama-server /path/to/stickllm/runtime/linux/
```

## Verification

The launcher script will check for the binary and provide helpful errors if missing.

Test manually:
```bash
# Linux/macOS
./runtime/linux/llama-server --version

# Windows
.\runtime\windows\llama-server.exe --version
```
