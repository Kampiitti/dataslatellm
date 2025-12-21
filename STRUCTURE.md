# StickLLM Directory Structure

```
stickllm/
│
├── 📄 README.md                    # Main documentation
├── 📄 SETUP_SUOCOMMERCE.md            # Setup guide for Suocommerce use case
├── 📄 QUICKREF.md                  # Quick reference card
├── 📄 LICENSE                      # MIT License
│
├── 🚀 launch.sh                    # Launch script (Linux/Mac)
├── 🚀 launch.bat                   # Launch script (Windows)
├── 🔧 setup.sh                     # Automated setup script
│
├── 📁 cli/                         # Command-line interface
│   ├── stickllm.py                 # Main CLI application
│   ├── config.yaml                 # Configuration file
│   └── requirements.txt            # Python dependencies
│
├── 📁 models/                      # AI model files (GGUF format)
│   └── README.md                   # Model download instructions
│   └── [your .gguf files here]
│
├── 📁 runtime/                     # Platform-specific binaries
│   ├── linux/
│   │   └── [llama-server binary]
│   ├── macos/
│   │   └── [llama-server binary]
│   └── windows/
│       └── [llama-server.exe]
│
├── 📁 context/                     # Project documentation & context
│   └── suocommerce/
│       ├── architecture.md         # Example architecture doc
│       └── [add your docs here]
│
└── 📁 chats/                       # Conversation history
    └── sessions.db                 # SQLite database (auto-created)
```

## After Setup, You'll Have:

```
stickllm/
├── models/
│   ├── deepseek-coder-6.7b-instruct.Q5_K_M.gguf     (~5GB)
│   └── deepseek-coder-33b-instruct.Q4_K_M.gguf     (~20GB)
│
├── runtime/
│   └── [your-platform]/
│       └── llama-server                              (~50-100MB)
│
├── context/
│   └── suocommerce/
│       ├── architecture.md
│       ├── commandos-overview.md
│       └── tech-stack.md
│
└── chats/
    └── sessions.db                                   (grows over time)
```

## Total Size Breakdown

| Component | Size | Notes |
|-----------|------|-------|
| Base files | <1MB | Scripts, docs, config |
| llama.cpp binary | ~50-100MB | Per platform |
| Small model (6.7B) | ~5GB | Fast responses |
| Large model (33B) | ~20GB | Deep reasoning |
| Context docs | ~1MB | Your project documentation |
| Chat history | Grows | SQLite database |
| **Minimal setup** | **~6GB** | One small model |
| **Recommended setup** | **~25GB** | Both models |
| **Available space (1TB)** | **~975GB** | For your work files |

## Key Files Explained

### Launch Scripts
- **launch.sh** / **launch.bat** - Detects OS, starts llama.cpp server, launches CLI
- Auto-detects available models and platform

### CLI Application
- **stickllm.py** - Main Python application with terminal interface
- Handles chat sessions, context management, server communication
- Similar UX to Claude Code

### Configuration
- **config.yaml** - Personas, model settings, context presets
- Customize for your workflow

### Models
- GGUF format (quantized for efficiency)
- Larger = better quality but slower
- Q4/Q5 = quantization level (4-bit, 5-bit)

### Context
- Add project documentation here
- Automatically loaded into AI conversations
- Helps AI understand your specific codebase/architecture

### Chats
- SQLite database stores all conversations
- Sessions can be resumed
- Full history maintained across devices
