# 🧠 StickLLM

> Your AI coding assistant that lives on a USB stick and follows you everywhere.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos%20%7C%20windows-lightgrey.svg)](https://github.com/yourusername/stickllm)

**StickLLM** is a portable AI coding assistant that runs entirely from a USB drive. No installation required, complete privacy, works on any machine.

## ✨ Features

- 🔒 **100% Private** - All processing happens locally, no cloud required
- 🚀 **Truly Portable** - Plug into any computer and start chatting
- 💾 **Persistent Memory** - Conversations follow you across all devices
- 🖥️ **Terminal Interface** - Fast, efficient CLI similar to Claude Code
- 🧠 **Context-Aware** - Load project files for informed responses
- 🔄 **Cross-Platform** - Works on Linux, macOS, and Windows

## 🎯 Why StickLLM?

Unlike cloud-based AI assistants or local tools that require installation on each machine, StickLLM gives you a truly portable AI brain that:

- **No subscriptions** - One-time cost for USB drive only
- **Works offline** - No internet connection required after setup
- **Complete privacy** - Your code never leaves your machine
- **Instant setup** - Just plug in and run `./launch.sh`
- **Follow you everywhere** - Office, home, travel - same AI, same context

**Compare to alternatives:**
- GitHub Copilot: $20/month, cloud-based, requires internet
- ChatGPT Plus: $20/month, web interface, privacy concerns
- Local LLM tools: Require installation on each machine
- Raspberry Pi solutions: Slow, requires separate hardware

**StickLLM: ~$150 one-time cost, works anywhere, completely private**

## 🚀 Quick Start

### 1. Get Hardware
- **1TB USB SSD** (recommended: Samsung T7 Shield, $110-140)

### 2. Download & Extract
```bash
git clone https://github.com/yourusername/stickllm.git /Volumes/YourUSB/stickllm
cd /Volumes/YourUSB/stickllm
```

### 3. Run Setup
```bash
./setup.sh  # Downloads model and llama.cpp
```

### 4. Start Using
```bash
./launch.sh
```

That's it! 🎉

## 📖 Usage

### Interactive Chat
```bash
./launch.sh
```

Commands:
- `/help` - Show commands
- `/context add file.py` - Add file to context
- `/new` - Start new session
- `/exit` - Exit

### Quick Questions
```bash
./launch.sh ask "How do I implement a binary search in Python?"
```

### Resume Sessions
```bash
./launch.sh sessions      # List all sessions
./launch.sh --session 5   # Resume session 5
```

## 💡 Use Cases

### Architecture Discussions
```bash
./launch.sh
/context add docs/architecture.md
You: Let's discuss the database strategy for billion-scale data
```

### Code Review
```bash
/context add src/api/handlers.py
You: Review this code for security issues
```

### Debugging
```bash
/context add error.log
/context add src/problematic_file.py
You: What's causing this error?
```

## 🛠️ Technical Details

### Supported Models
- DeepSeek Coder 6.7B - 33B
- Qwen2.5 Coder 32B
- CodeLlama 13B - 34B
- Any GGUF format model

### System Requirements
- **Minimum**: 8GB RAM, USB 3.0, Python 3.8+
- **Recommended**: 16GB RAM, USB 3.1+, Python 3.10+

### Architecture
```
USB Drive
├── models/          # AI models (5-25GB)
├── runtime/         # llama.cpp binary
├── cli/             # Python application
├── context/         # Your project docs
└── chats/           # All conversations
```

## 📊 Performance

| Model | Size | RAM | Speed | Best For |
|-------|------|-----|-------|----------|
| DeepSeek 6.7B | 5GB | 8GB | Fast (30-50 tok/s) | Quick questions |
| DeepSeek 33B | 20GB | 24GB | Medium (10-20 tok/s) | Architecture |
| Qwen2.5 32B | 22GB | 26GB | Medium (10-20 tok/s) | Complex reasoning |

*Speed varies by CPU*

## 📚 Documentation

- [**Complete Guide**](README_FULL.md) - Full documentation
- [**Setup Guide**](SETUP_SUOCOMMERCE.md) - Detailed setup instructions
- [**Quick Reference**](QUICKREF.md) - Command cheat sheet
- [**Architecture**](ARCHITECTURE.md) - System design
- [**Contributing**](CONTRIBUTING.md) - How to contribute

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Areas we need help:**
- Windows testing
- Additional model support
- Performance optimizations
- Documentation improvements
- Translations

## 📝 Roadmap

- [ ] Cloud-assisted context compression
- [ ] Web UI option
- [ ] RAG for large codebases
- [ ] Git integration
- [ ] Voice input support
- [ ] Multi-model switching

See [CHANGELOG.md](CHANGELOG.md) for version history.

## 🔒 Privacy

- ✅ No telemetry or tracking
- ✅ No cloud API calls
- ✅ Works completely offline
- ✅ You own all data
- ✅ GDPR/compliance friendly

## 📜 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- [llama.cpp](https://github.com/ggerganov/llama.cpp) - Fast LLM inference
- [DeepSeek](https://github.com/deepseek-ai) - Excellent coding models
- [Qwen](https://github.com/QwenLM) - High-quality models

## 💬 Community

- [Discussions](https://github.com/yourusername/stickllm/discussions) - Ask questions, share ideas
- [Issues](https://github.com/yourusername/stickllm/issues) - Report bugs, request features

---

**Star ⭐ this repo if you find it useful!**

Made with ❤️ for developers who value privacy and portability.
