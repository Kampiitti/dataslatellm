#!/bin/bash

# StickLLM Launcher Script
# Detects OS, starts llama.cpp server, and launches CLI

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo -e "${BLUE}╔════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        StickLLM Launcher          ║${NC}"
echo -e "${BLUE}║   Portable AI Coding Assistant    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════╝${NC}"
echo

# Detect OS and architecture
OS=$(uname -s)
ARCH=$(uname -m)

echo -e "${YELLOW}Detected OS: ${NC}$OS"
echo -e "${YELLOW}Architecture: ${NC}$ARCH"
echo

# Set paths based on OS
case "$OS" in
    Linux*)
        RUNTIME_DIR="$SCRIPT_DIR/runtime/linux"
        LLAMA_BIN="$RUNTIME_DIR/llama-server"
        ;;
    Darwin*)
        RUNTIME_DIR="$SCRIPT_DIR/runtime/macos"
        LLAMA_BIN="$RUNTIME_DIR/llama-server"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        echo -e "${RED}Windows detected. Please use launch.bat instead.${NC}"
        exit 1
        ;;
    *)
        echo -e "${RED}Unsupported OS: $OS${NC}"
        exit 1
        ;;
esac

# Check if llama.cpp binary exists
if [ ! -f "$LLAMA_BIN" ]; then
    echo -e "${YELLOW}Binary not found at: $LLAMA_BIN${NC}"
    
    # Check for Homebrew installation as fallback (macOS only)
    if [ "$OS" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
        if brew list llama.cpp >/dev/null 2>&1; then
            LLAMA_BIN="$(brew --prefix)/bin/llama-server"
            echo -e "${GREEN}Found Homebrew installation at: $LLAMA_BIN${NC}"
        elif [ -f "/opt/homebrew/bin/llama-server" ]; then
            LLAMA_BIN="/opt/homebrew/bin/llama-server"
            echo -e "${GREEN}Found Homebrew installation at: $LLAMA_BIN${NC}"
        else
            echo -e "${RED}Error: llama-server not found${NC}"
            echo -e "${YELLOW}Install via Homebrew: brew install llama.cpp${NC}"
            echo -e "${YELLOW}Or run ./setup.sh to download${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Error: llama.cpp server not found${NC}"
        echo -e "${YELLOW}Please run ./setup.sh to download${NC}"
        echo -e "${YELLOW}Or see: https://github.com/ggerganov/llama.cpp${NC}"
        exit 1
    fi
fi

# Make sure binary is executable
chmod +x "$LLAMA_BIN" 2>/dev/null || true

# Adaptive Model Selection
# Auto-detect system resources and choose appropriate model/settings

# Define model paths globally
MODEL_DIR="$SCRIPT_DIR/models"
MODEL_6B="$MODEL_DIR/deepseek-coder-6.7b-instruct.Q5_K_M.gguf"
MODEL_33B_Q4="$MODEL_DIR/deepseek-coder-33b-instruct.Q4_K_M.gguf"
MODEL_33B_Q3="$MODEL_DIR/deepseek-coder-33b-instruct.Q3_K_M.gguf"

detect_system_memory() {
    if [ "$OS" = "Darwin" ]; then
        # macOS - get total RAM in GB
        TOTAL_RAM_GB=$(sysctl -n hw.memsize | awk '{print int($1/1024/1024/1024)}')
    else
        # Linux - get total RAM in GB
        TOTAL_RAM_GB=$(free -g | awk '/^Mem:/{print $2}')
    fi
    echo $TOTAL_RAM_GB
}

detect_available_models() {
    # Use globally defined model paths
    AVAILABLE_MODELS=""
    [ -f "$MODEL_6B" ] && AVAILABLE_MODELS="$AVAILABLE_MODELS 6.7B"
    [ -f "$MODEL_33B_Q4" ] && AVAILABLE_MODELS="$AVAILABLE_MODELS 33B-Q4"
    [ -f "$MODEL_33B_Q3" ] && AVAILABLE_MODELS="$AVAILABLE_MODELS 33B-Q3"
    
    # Fallback: any GGUF file
    if [ -z "$AVAILABLE_MODELS" ]; then
        ANY_MODEL=$(find "$MODEL_DIR" -name "*.gguf" -type f | head -n 1)
        if [ -n "$ANY_MODEL" ]; then
            AVAILABLE_MODELS="UNKNOWN"
        fi
    fi
    
    echo "$AVAILABLE_MODELS"
}

select_optimal_model() {
    local ram_gb=$1
    local available_models=$2
    
    # Model selection logic based on available RAM
    # Conservative estimates to avoid OOM
    
    if [ $ram_gb -ge 32 ]; then
        # 32GB+ RAM - Can run 33B models comfortably
        if [[ "$available_models" == *"33B-Q4"* ]]; then
            MODEL_FILE="$MODEL_33B_Q4"
            CTX_SIZE=8192
            N_GPU_LAYERS=60  # Full offload for 33B
            echo -e "${GREEN}High RAM detected (${ram_gb}GB) - Using 33B Q4 model${NC}"
        elif [[ "$available_models" == *"33B-Q3"* ]]; then
            MODEL_FILE="$MODEL_33B_Q3"
            CTX_SIZE=8192
            N_GPU_LAYERS=60
            echo -e "${GREEN}High RAM detected (${ram_gb}GB) - Using 33B Q3 model${NC}"
        elif [[ "$available_models" == *"6.7B"* ]]; then
            MODEL_FILE="$MODEL_6B"
            CTX_SIZE=8192
            N_GPU_LAYERS=33
            echo -e "${YELLOW}Note: 33B model not found, using 6.7B (consider downloading 33B)${NC}"
        fi
    elif [ $ram_gb -ge 24 ]; then
        # 24GB RAM - Can run 33B with smaller context or 6.7B with large context
        if [[ "$available_models" == *"33B-Q4"* ]]; then
            MODEL_FILE="$MODEL_33B_Q4"
            CTX_SIZE=4096
            N_GPU_LAYERS=40  # Partial offload
            echo -e "${GREEN}Medium-high RAM (${ram_gb}GB) - Using 33B Q4 (hybrid GPU/CPU)${NC}"
        elif [[ "$available_models" == *"6.7B"* ]]; then
            MODEL_FILE="$MODEL_6B"
            CTX_SIZE=8192
            N_GPU_LAYERS=33
            echo -e "${GREEN}Medium-high RAM (${ram_gb}GB) - Using 6.7B (full GPU)${NC}"
        fi
    elif [ $ram_gb -ge 16 ]; then
        # 16GB RAM - Best with 6.7B full GPU, or 33B hybrid
        if [[ "$available_models" == *"6.7B"* ]]; then
            MODEL_FILE="$MODEL_6B"
            CTX_SIZE=6144
            N_GPU_LAYERS=33  # Full GPU offload
            echo -e "${GREEN}Standard RAM (${ram_gb}GB) - Using 6.7B (optimized)${NC}"
        elif [[ "$available_models" == *"33B-Q3"* ]]; then
            MODEL_FILE="$MODEL_33B_Q3"
            CTX_SIZE=2048
            N_GPU_LAYERS=16  # Minimal GPU offload
            echo -e "${YELLOW}Standard RAM (${ram_gb}GB) - Using 33B Q3 (CPU-heavy, will be slower)${NC}"
        fi
    elif [ $ram_gb -ge 8 ]; then
        # 8GB RAM - 6.7B only, minimal settings
        if [[ "$available_models" == *"6.7B"* ]]; then
            MODEL_FILE="$MODEL_6B"
            CTX_SIZE=2048
            N_GPU_LAYERS=20  # Partial GPU offload
            echo -e "${YELLOW}Low RAM (${ram_gb}GB) - Using 6.7B (reduced context)${NC}"
        fi
    else
        # <8GB RAM - Will struggle, use CPU only
        if [[ "$available_models" == *"6.7B"* ]]; then
            MODEL_FILE="$MODEL_6B"
            CTX_SIZE=2048
            N_GPU_LAYERS=0  # CPU only
            echo -e "${RED}Very low RAM (${ram_gb}GB) - Using 6.7B (CPU only, will be slow)${NC}"
        fi
    fi
    
    # Fallback to any available model
    if [ -z "$MODEL_FILE" ]; then
        MODEL_FILE=$(find "$SCRIPT_DIR/models" -name "*.gguf" -type f | head -n 1)
        CTX_SIZE=2048
        N_GPU_LAYERS=0
        echo -e "${YELLOW}Using fallback model: $(basename "$MODEL_FILE")${NC}"
    fi
}

# Detect system resources
echo -e "${BLUE}Detecting system resources...${NC}"
TOTAL_RAM=$(detect_system_memory)
AVAILABLE_MODELS=$(detect_available_models)

echo -e "${YELLOW}Total RAM: ${NC}${TOTAL_RAM}GB"
echo -e "${YELLOW}Available models:${NC}${AVAILABLE_MODELS}"
echo

# Check for manual overrides via environment variables
if [ -n "$STICKLLM_MODEL" ]; then
    echo -e "${BLUE}Manual model override: $STICKLLM_MODEL${NC}"
    MODEL_FILE="$SCRIPT_DIR/models/$STICKLLM_MODEL"
    CTX_SIZE=${STICKLLM_CTX:-4096}
    N_GPU_LAYERS=${STICKLLM_GPU_LAYERS:-33}
else
    # Select optimal configuration
    select_optimal_model $TOTAL_RAM "$AVAILABLE_MODELS"
fi

# Verify model was selected
if [ -z "$MODEL_FILE" ] || [ ! -f "$MODEL_FILE" ]; then
    echo -e "${RED}Error: No suitable model found in $MODEL_DIR${NC}"
    echo -e "${YELLOW}Please download a GGUF model file.${NC}"
    echo -e "${YELLOW}Recommended: DeepSeek Coder 6.7B${NC}"
    echo -e "${YELLOW}Download from: https://huggingface.co/TheBloke/deepseek-coder-6.7B-instruct-GGUF${NC}"
    exit 1
fi

echo -e "${GREEN}Selected model: ${NC}$(basename "$MODEL_FILE")"
echo -e "${GREEN}Context size: ${NC}${CTX_SIZE} tokens"
echo -e "${GREEN}GPU layers: ${NC}${N_GPU_LAYERS}"
echo

# Check if server is already running
if curl -s http://localhost:8080/health > /dev/null 2>&1; then
    echo -e "${YELLOW}Server is already running at http://localhost:8080${NC}"
else
    # Start llama.cpp server in background
    echo -e "${BLUE}Starting llama.cpp server...${NC}"
    
    # Determine number of threads (use half of available cores)
    if command -v nproc > /dev/null 2>&1; then
        N_THREADS=$(($(nproc) / 2))
    elif command -v sysctl > /dev/null 2>&1; then
        N_THREADS=$(($(sysctl -n hw.ncpu) / 2))
    else
        N_THREADS=4
    fi
    
    # Start server with adaptive settings
    "$LLAMA_BIN" \
        -m "$MODEL_FILE" \
        --port 8080 \
        --ctx-size $CTX_SIZE \
        --n-predict 2048 \
        --threads $N_THREADS \
        -ngl $N_GPU_LAYERS \
        --log-disable \
        > "$SCRIPT_DIR/server.log" 2>&1 &
    
    SERVER_PID=$!
    echo $SERVER_PID > "$SCRIPT_DIR/server.pid"
    
    echo -e "${GREEN}Server started (PID: $SERVER_PID)${NC}"
    echo -e "${YELLOW}Waiting for server to initialize...${NC}"
    
    # Wait for server to be ready
    for i in {1..30}; do
        if curl -s http://localhost:8080/health > /dev/null 2>&1; then
            echo -e "${GREEN}Server is ready!${NC}"
            break
        fi
        sleep 1
        echo -n "."
    done
    echo
fi

# Check for Python
if ! command -v python3 > /dev/null 2>&1; then
    echo -e "${RED}Error: Python 3 is not installed${NC}"
    exit 1
fi

# Check for required Python packages
echo -e "${BLUE}Checking Python dependencies...${NC}"
python3 -c "import requests; import yaml" 2>/dev/null || {
    echo -e "${YELLOW}Installing required Python packages...${NC}"
    python3 -m pip install --user requests pyyaml
}

# Launch CLI
echo -e "${GREEN}Launching StickLLM CLI...${NC}"
echo

export PYTHONPATH="$SCRIPT_DIR/cli:$PYTHONPATH"
python3 "$SCRIPT_DIR/cli/stickllm.py" "$@"

# Cleanup function
cleanup() {
    if [ -f "$SCRIPT_DIR/server.pid" ]; then
        PID=$(cat "$SCRIPT_DIR/server.pid")
        if ps -p $PID > /dev/null 2>&1; then
            echo -e "\n${YELLOW}Stopping server (PID: $PID)...${NC}"
            kill $PID
            rm "$SCRIPT_DIR/server.pid"
        fi
    fi
}

# Register cleanup on exit
trap cleanup EXIT
