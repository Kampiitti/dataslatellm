# StickLLM - Portable AI Coding Assistant

> Your AI coding assistant that lives on a USB stick and follows you across machines.

## What is StickLLM?

StickLLM is a fully portable, privacy-focused AI coding assistant that runs entirely from a USB drive. No installation required, no cloud dependencies, complete privacy. Just plug in your USB stick and start coding with AI assistance.

**Key Features:**
- 🔒 **100% Private** - Everything runs locally, no data sent to cloud
- 🚀 **Truly Portable** - Works on any machine, just plug and go
- 💾 **Persistent Memory** - All conversations saved on your USB stick
- 🖥️ **Terminal Interface** - Clean CLI similar to Claude Code
- 🧠 **Context-Aware** - Load project files for better assistance
- 🔄 **Cross-Platform** - Linux, macOS, and Windows support

## Quick Start

### 1. Get a Rugged USB Drive

For best results, use a fast, durable USB SSD (1TB recommended):
- **Samsung T7 Shield** (1TB) - Best value, IP65 rated
- **LaCie Rugged SSD** (1TB) - Military-grade durability
- **SanDisk Extreme Portable** (1TB) - Good middle ground

### 2. Download StickLLM

Copy the entire `stickllm` folder to your USB drive root:

```
/Volumes/YourUSB/stickllm/
```

### 3. Get a Model

Download a GGUF format model and place it in the `models/` folder.

**Recommended models:**

For 1TB drive, you can fit multiple models:

**Fast & Efficient (Quick responses):**
- [DeepSeek Coder 6.7B Q5_K_M](https://huggingface.co/TheBloke/deepseek-coder-6.7B-instruct-GGUF/blob/main/deepseek-coder-6.7b-instruct.Q5_K_M.gguf) (~4.8GB)

**Powerful (Better reasoning):**
- [DeepSeek Coder 33B Q4_K_M](https://huggingface.co/TheBloke/deepseek-coder-33B-instruct-GGUF/blob/main/deepseek-coder-33b-instruct.Q4_K_M.gguf) (~20GB)
- [Qwen2.5 Coder 32B Q5_K_M](https://huggingface.co/Qwen/Qwen2.5-Coder-32B-Instruct-GGUF/blob/main/qwen2.5-coder-32b-instruct-q5_k_m.gguf) (~22GB)

**Balanced:**
- [CodeLlama 13B Q5_K_M](https://huggingface.co/TheBloke/CodeLlama-13B-Instruct-GGUF/blob/main/codellama-13b-instruct.Q5_K_M.gguf) (~9.3GB)

Download directly from HuggingFace or use `huggingface-cli`:

```bash
# Install huggingface-cli
pip install huggingface-hub

# Download model
huggingface-cli download TheBloke/deepseek-coder-6.7B-instruct-GGUF \
    deepseek-coder-6.7b-instruct.Q5_K_M.gguf \
    --local-dir ./models/
```

### 4. Get llama.cpp Binary

Download the llama.cpp server binary for your platform:

**Option A: Download Pre-built Binary**

Visit [llama.cpp releases](https://github.com/ggerganov/llama.cpp/releases) and download:
- **Linux**: `llama-*-linux-x64.zip` → Extract `llama-server` to `runtime/linux/`
- **macOS**: `llama-*-macos-arm64.zip` (M1/M2) or `llama-*-macos-x64.zip` (Intel) → Extract to `runtime/macos/`
- **Windows**: `llama-*-windows-x64.zip` → Extract `llama-server.exe` to `runtime/windows/`

**Option B: Compile from Source** (for best performance)

```bash
# Clone llama.cpp
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp

# Build with optimizations
make LLAMA_CUBLAS=1  # For NVIDIA GPU support
# or
make LLAMA_METAL=1   # For Apple Silicon GPU support
# or just
make                 # CPU only

# Copy binary to StickLLM
cp llama-server /path/to/usb/stickllm/runtime/linux/
```

### 5. First Run

```bash
# Navigate to your USB drive
cd /Volumes/YourUSB/stickllm

# Make launcher executable (Linux/Mac)
chmod +x launch.sh

# Start StickLLM
./launch.sh

# Windows users: just double-click launch.bat
```

## Usage

### Interactive Chat

Start a conversational session:

```bash
./launch.sh chat
```

Commands within chat:
- `/help` - Show available commands
- `/new` - Start a new conversation
- `/context` - Show loaded context files
- `/context add file.py` - Add a file to context
- `/context clear` - Clear all context
- `/exit` - Exit chat

### One-Shot Questions

Ask a quick question without entering interactive mode:

```bash
./launch.sh ask "How do I implement a binary search in Python?"
```

### Session Management

List all past conversations:

```bash
./launch.sh sessions
```

Resume a specific conversation:

```bash
./launch.sh chat --session 5
```

## Directory Structure

```
stickllm/
├── models/                          # GGUF model files
│   └── deepseek-coder-6.7b.gguf
├── runtime/                         # Platform-specific binaries
│   ├── linux/
│   │   └── llama-server
│   ├── macos/
│   │   └── llama-server
│   └── windows/
│       └── llama-server.exe
├── cli/                             # Python CLI application
│   ├── stickllm.py
│   ├── config.yaml
│   └── requirements.txt
├── context/                         # Project context files
│   └── suocommerce/                    # Example: Suocommerce project docs
│       ├── architecture.md
│       └── tech-stack.md
├── chats/                           # Conversation history
│   └── sessions.db
├── launch.sh                        # Linux/Mac launcher
└── launch.bat                       # Windows launcher
```

## Advanced Configuration

### Custom Personas

Edit `cli/config.yaml` to add custom AI personas:

```yaml
personas:
  security_expert: |
    You are a cybersecurity expert focused on identifying vulnerabilities,
    security best practices, and secure coding patterns.
  
  performance_optimizer: |
    You are a performance optimization specialist who identifies bottlenecks,
    suggests algorithmic improvements, and optimizes for speed and memory.
```

### Context Presets

Create context presets for different projects:

```yaml
contexts:
  my_project:
    description: "My awesome project"
    files:
      - context/my_project/architecture.md
      - context/my_project/api_spec.yaml
    persona: architect
```

Load a preset in chat:
```
/context load my_project
```

### Server Configuration

Adjust server settings in the launch script:

```bash
# Edit launch.sh

# Increase context window
--ctx-size 16384    # Default: 8192

# More tokens in responses
--n-predict 4096    # Default: 2048

# More CPU threads
--threads 16        # Default: auto-detected
```

## Use Cases

### 1. Architecture Review

```bash
./launch.sh chat

You: /context add context/suocommerce/commandos-architecture.md
You: Review this architecture for scalability issues

# AI provides detailed analysis with project context
```

### 2. Code Review

```bash
You: /context add src/api/handlers.py
You: Review this code for bugs and improvements

# AI reviews with full file context
```

### 3. Quick Coding Questions

```bash
./launch.sh ask "What's the best way to handle concurrent requests in Python?"
```

### 4. Debugging Help

```bash
You: /context add error.log
You: /context add src/database.py
You: This error keeps happening, what could be causing it?
```

## Tips for Best Results

1. **Add Context Files** - Load relevant files before asking questions
2. **Use Specific Models** - Bigger models (33B) for architecture, smaller (6.7B) for quick questions
3. **Organize Context** - Keep project docs in `context/` folder
4. **Resume Sessions** - Use `--session` to continue previous conversations
5. **USB Speed Matters** - Use USB 3.1+ for faster model loading

## Troubleshooting

### Server Won't Start

Check `server.log` for errors:
```bash
cat server.log
```

Common issues:
- **Port 8080 in use**: Kill existing process or change port in config
- **Insufficient RAM**: Use smaller quantized model (Q4 instead of Q5)
- **Corrupted model**: Re-download model file

### Slow Performance

- Use smaller model (6.7B instead of 33B)
- Reduce context window: `--ctx-size 4096`
- Ensure USB drive is USB 3.0 or higher
- Close other applications to free RAM

### Python Errors

Install dependencies manually:
```bash
pip install -r cli/requirements.txt
```

## Model Size Guide

| Model | Size | RAM Needed | Speed | Quality |
|-------|------|------------|-------|---------|
| DeepSeek 6.7B Q4 | ~4GB | 6GB | Fast | Good |
| DeepSeek 6.7B Q5 | ~5GB | 7GB | Fast | Better |
| CodeLlama 13B Q4 | ~8GB | 10GB | Medium | Good |
| DeepSeek 33B Q4 | ~20GB | 24GB | Slower | Excellent |
| Qwen2.5 32B Q5 | ~22GB | 26GB | Slower | Excellent |

## Privacy & Security

- **100% Local**: No data ever leaves your machine
- **No Telemetry**: No tracking, no analytics
- **Your Data**: All chats stored on your USB drive
- **Offline**: Works completely offline once set up

## Contributing

Ideas for improvements:
- [ ] Web UI option
- [ ] RAG integration for larger codebases
- [ ] Git integration for automatic context
- [ ] Multiple model switching without restart
- [ ] Code execution sandbox

## Credits

Built with:
- [llama.cpp](https://github.com/ggerganov/llama.cpp) - Fast LLM inference
- Various open-source models (DeepSeek, Qwen, Meta)

## License

MIT License - Use however you want!

---

**Happy Coding! 🚀**

Need help? Open an issue or check the troubleshooting section above.
