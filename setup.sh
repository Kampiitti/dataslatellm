#!/bin/bash

# StickLLM Setup Script
# Automates downloading models and llama.cpp binaries

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo -e "${BLUE}╔════════════════════════════════════╗${NC}"
echo -e "${BLUE}║    StickLLM Setup Assistant       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════╝${NC}"
echo

# Detect OS
OS=$(uname -s)
ARCH=$(uname -m)

echo -e "${YELLOW}Detected OS: ${NC}$OS $ARCH"
echo

# Check for required tools
check_tool() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}Error: $1 is not installed${NC}"
        echo -e "${YELLOW}Please install $1 first${NC}"
        exit 1
    fi
}

echo -e "${BLUE}Checking requirements...${NC}"
check_tool curl
check_tool python3

# Check for pip
if ! python3 -m pip --version &> /dev/null; then
    echo -e "${YELLOW}Installing pip...${NC}"
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py --user
    rm get-pip.py
fi

# Install Python dependencies
echo -e "${BLUE}Installing Python dependencies...${NC}"
# macOS Sonoma and later use externally-managed environment
# Use --break-system-packages flag (safe for user installs)
python3 -m pip install --user --break-system-packages requests pyyaml huggingface-hub 2>/dev/null || \
python3 -m pip install --user requests pyyaml huggingface-hub

echo

# Menu for model selection
echo -e "${GREEN}═══════════════════════════════════${NC}"
echo -e "${GREEN}   Step 1: Select Model to Download${NC}"
echo -e "${GREEN}═══════════════════════════════════${NC}"
echo
echo "Choose a model to download:"
echo
echo "  ${CYAN}1)${NC} DeepSeek Coder 6.7B Q5_K_M (~5GB) - Fast, good for testing"
echo "  ${CYAN}2)${NC} DeepSeek Coder 33B Q4_K_M (~20GB) - Powerful, best for architecture"
echo "  ${CYAN}3)${NC} Qwen2.5 Coder 32B Q5_K_M (~22GB) - Excellent reasoning"
echo "  ${CYAN}4)${NC} Download both 6.7B and 33B (recommended for 1TB drive)"
echo "  ${CYAN}5)${NC} Skip model download (I'll do it manually)"
echo

read -p "Enter choice [1-5]: " model_choice

download_model() {
    local repo=$1
    local file=$2
    local name=$3
    
    echo -e "${BLUE}Downloading $name...${NC}"
    echo "This may take a while depending on your internet speed."
    echo
    
    python3 -c "
from huggingface_hub import hf_hub_download
import os

try:
    print('Downloading from HuggingFace...')
    file_path = hf_hub_download(
        repo_id='$repo',
        filename='$file',
        local_dir='$SCRIPT_DIR/models',
        local_dir_use_symlinks=False
    )
    print(f'Downloaded to: {file_path}')
except Exception as e:
    print(f'Error: {e}')
    exit(1)
"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Successfully downloaded $name${NC}"
        echo
    else
        echo -e "${RED}✗ Failed to download $name${NC}"
        echo -e "${YELLOW}You can download manually from https://huggingface.co/$repo${NC}"
        echo
    fi
}

case $model_choice in
    1)
        download_model "TheBloke/deepseek-coder-6.7B-instruct-GGUF" \
                      "deepseek-coder-6.7b-instruct.Q5_K_M.gguf" \
                      "DeepSeek Coder 6.7B"
        ;;
    2)
        download_model "TheBloke/deepseek-coder-33B-instruct-GGUF" \
                      "deepseek-coder-33b-instruct.Q4_K_M.gguf" \
                      "DeepSeek Coder 33B"
        ;;
    3)
        download_model "Qwen/Qwen2.5-Coder-32B-Instruct-GGUF" \
                      "qwen2.5-coder-32b-instruct-q5_k_m.gguf" \
                      "Qwen2.5 Coder 32B"
        ;;
    4)
        download_model "TheBloke/deepseek-coder-6.7B-instruct-GGUF" \
                      "deepseek-coder-6.7b-instruct.Q5_K_M.gguf" \
                      "DeepSeek Coder 6.7B"
        download_model "TheBloke/deepseek-coder-33B-instruct-GGUF" \
                      "deepseek-coder-33b-instruct.Q4_K_M.gguf" \
                      "DeepSeek Coder 33B"
        ;;
    5)
        echo -e "${YELLOW}Skipping model download${NC}"
        echo -e "${YELLOW}Remember to download a model manually to models/${NC}"
        echo
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

# Download llama.cpp binary
echo
echo -e "${GREEN}═══════════════════════════════════${NC}"
echo -e "${GREEN}   Step 2: Download llama.cpp${NC}"
echo -e "${GREEN}═══════════════════════════════════${NC}"
echo

get_latest_release() {
    # Try to get latest release tag, fall back to known version if API fails
    local tag=$(curl -s https://api.github.com/repos/ggerganov/llama.cpp/releases/latest 2>/dev/null | \
        python3 -c "import sys, json; data = json.load(sys.stdin); print(data.get('tag_name', 'b4315'))" 2>/dev/null)
    
    # If tag is empty or API failed, use known working version
    if [ -z "$tag" ] || [ "$tag" = "None" ]; then
        echo "b4315"
    else
        echo "$tag"
    fi
}

download_llamacpp() {
    local platform=$1
    local arch=$2
    local dest=$3
    
    echo -e "${BLUE}Downloading llama.cpp for $platform...${NC}"
    
    LATEST_TAG=$(get_latest_release)
    echo "Version: $LATEST_TAG"
    
    DOWNLOAD_URL="https://github.com/ggerganov/llama.cpp/releases/download/${LATEST_TAG}/llama-${LATEST_TAG}-bin-${platform}.zip"
    
    echo "Downloading from: $DOWNLOAD_URL"
    
    mkdir -p "/tmp/stickllm-setup"
    cd "/tmp/stickllm-setup"
    
    if curl -L -o "llama.zip" "$DOWNLOAD_URL" 2>/dev/null; then
        echo "Extracting..."
        unzip -q "llama.zip" 2>/dev/null
        
        # Find the extracted directory
        EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "llama-*" | head -n 1)
        
        if [ -n "$EXTRACTED_DIR" ]; then
            # Copy the entire directory to preserve library dependencies
            rm -rf "$dest"
            mkdir -p "$(dirname "$dest")"
            cp -r "$EXTRACTED_DIR" "$dest"
            
            # Make binaries executable
            chmod +x "$dest"/llama-* 2>/dev/null
            chmod +x "$dest"/bin/* 2>/dev/null
            
            # Find and verify the server binary
            if [ -f "$dest/llama-server" ]; then
                echo -e "${GREEN}✓ Installed to $dest/${NC}"
                echo -e "${GREEN}✓ Binary: $dest/llama-server${NC}"
            elif [ -f "$dest/bin/llama-server" ]; then
                # Some releases put binaries in bin/
                cp "$dest/bin"/* "$dest/" 2>/dev/null
                echo -e "${GREEN}✓ Installed to $dest/${NC}"
            else
                echo -e "${RED}✗ Could not find llama-server in download${NC}"
                cd "$SCRIPT_DIR"
                rm -rf "/tmp/stickllm-setup"
                return 1
            fi
        else
            echo -e "${RED}✗ Could not find extracted directory${NC}"
            cd "$SCRIPT_DIR"
            rm -rf "/tmp/stickllm-setup"
            return 1
        fi
        
        cd "$SCRIPT_DIR"
        rm -rf "/tmp/stickllm-setup"
        return 0
    else
        echo -e "${RED}✗ Download failed${NC}"
        cd "$SCRIPT_DIR"
        rm -rf "/tmp/stickllm-setup"
        return 1
    fi
}

case "$OS" in
    Linux*)
        echo "Downloading for Linux x64..."
        download_llamacpp "linux-x64" "x64" "$SCRIPT_DIR/runtime/linux" || {
            echo -e "${YELLOW}Automatic download failed. Manual installation options:${NC}"
            echo "1. Visit: https://github.com/ggerganov/llama.cpp/releases"
            echo "2. Download: llama-*-bin-linux-x64.zip"
            echo "3. Extract to: $SCRIPT_DIR/runtime/linux/"
        }
        ;;
    Darwin*)
        if [ "$ARCH" = "arm64" ]; then
            echo "Downloading for macOS ARM64 (M1/M2/M3/M4)..."
            download_llamacpp "macos-arm64" "arm64" "$SCRIPT_DIR/runtime/macos" || {
                echo -e "${YELLOW}Automatic download failed. Checking for Homebrew...${NC}"
                
                # Check if Homebrew llama.cpp is available
                if command -v brew >/dev/null 2>&1; then
                    if brew list llama.cpp >/dev/null 2>&1; then
                        echo -e "${GREEN}Found Homebrew llama.cpp installation${NC}"
                        echo "Creating symlink..."
                        mkdir -p "$SCRIPT_DIR/runtime/macos"
                        ln -sf "$(brew --prefix)/bin/llama-server" "$SCRIPT_DIR/runtime/macos/llama-server"
                        echo -e "${GREEN}✓ Using Homebrew version${NC}"
                    else
                        echo -e "${YELLOW}Installing via Homebrew...${NC}"
                        brew install llama.cpp && \
                        mkdir -p "$SCRIPT_DIR/runtime/macos" && \
                        ln -sf "$(brew --prefix)/bin/llama-server" "$SCRIPT_DIR/runtime/macos/llama-server" && \
                        echo -e "${GREEN}✓ Installed via Homebrew${NC}"
                    fi
                else
                    echo -e "${YELLOW}Manual installation needed:${NC}"
                    echo "Option 1 - Install via Homebrew (recommended):"
                    echo "  brew install llama.cpp"
                    echo ""
                    echo "Option 2 - Manual download:"
                    echo "  1. Visit: https://github.com/ggerganov/llama.cpp/releases"
                    echo "  2. Download: llama-*-bin-macos-arm64.zip"
                    echo "  3. Extract entire folder to: $SCRIPT_DIR/runtime/macos/"
                fi
            }
        else
            echo "Downloading for macOS x64 (Intel)..."
            download_llamacpp "macos-x64" "x64" "$SCRIPT_DIR/runtime/macos" || {
                echo -e "${YELLOW}Automatic download failed. Manual installation:${NC}"
                echo "1. Visit: https://github.com/ggerganov/llama.cpp/releases"
                echo "2. Download: llama-*-bin-macos-x64.zip"
                echo "3. Extract to: $SCRIPT_DIR/runtime/macos/"
            }
        fi
        ;;
    *)
        echo -e "${YELLOW}Automatic download not supported for $OS${NC}"
        echo -e "${YELLOW}Please download manually from:${NC}"
        echo "https://github.com/ggerganov/llama.cpp/releases"
        ;;
esac

echo

# Summary
echo -e "${GREEN}═══════════════════════════════════${NC}"
echo -e "${GREEN}        Setup Complete!            ${NC}"
echo -e "${GREEN}═══════════════════════════════════${NC}"
echo

echo -e "${BLUE}What's next:${NC}"
echo
echo "1. Check that you have a model in models/"
ls -lh models/*.gguf 2>/dev/null && echo -e "${GREEN}   ✓ Model found${NC}" || echo -e "${YELLOW}   ! No model found - download one${NC}"
echo

echo "2. Check that you have llama.cpp binary"
case "$OS" in
    Linux*)
        [ -f "runtime/linux/llama-server" ] && echo -e "${GREEN}   ✓ Linux binary found${NC}" || echo -e "${YELLOW}   ! Linux binary missing${NC}"
        ;;
    Darwin*)
        [ -f "runtime/macos/llama-server" ] && echo -e "${GREEN}   ✓ macOS binary found${NC}" || echo -e "${YELLOW}   ! macOS binary missing${NC}"
        ;;
esac
echo

echo "3. Ready to launch!"
echo -e "   Run: ${CYAN}./launch.sh${NC}"
echo

echo -e "${BLUE}Optional: Add Suocommerce documentation${NC}"
echo "   Add your project docs to: context/suocommerce/"
echo "   Example architecture.md is already there"
echo

echo -e "${GREEN}Happy coding! 🚀${NC}"
