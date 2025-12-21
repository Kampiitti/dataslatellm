# StickLLM - Complete Project Index

## 📖 Start Here

1. **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** ⭐
   - Complete project overview
   - What it is, why it's special
   - Cost breakdown and next steps

2. **[README.md](README.md)**
   - Full user documentation
   - Setup instructions
   - Usage guide and troubleshooting

3. **[SETUP_SUOCOMMERCE.md](SETUP_SUOCOMMERCE.md)**
   - Customized setup for Suocommerce use case
   - Recommended models and configuration
   - Typical workflows

## 📚 Additional Documentation

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Visual diagrams and system architecture
- **[STRUCTURE.md](STRUCTURE.md)** - Directory structure explained
- **[QUICKREF.md](QUICKREF.md)** - Quick reference card for daily use
- **[LICENSE](LICENSE)** - MIT License

## 🚀 Core Application Files

### Launch Scripts
- **[launch.sh](launch.sh)** - Linux/macOS launcher
- **[launch.bat](launch.bat)** - Windows launcher
- **[setup.sh](setup.sh)** - Automated setup script

### Python CLI
- **[cli/stickllm.py](cli/stickllm.py)** - Main application (600 lines)
- **[cli/config.yaml](cli/config.yaml)** - Configuration file
- **[cli/requirements.txt](cli/requirements.txt)** - Python dependencies

### Context Files
- **[context/suocommerce/architecture.md](context/suocommerce/architecture.md)** - Example Suocommerce docs

### Placeholder Directories
- **[models/README.md](models/README.md)** - Model download instructions
- **[runtime/README.md](runtime/README.md)** - Binary download instructions
- **chats/** - Auto-created for conversation storage

## 🎯 Quick Setup Path

1. Read: [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) (5 min)
2. Copy entire project to USB drive
3. Run: `./setup.sh` (downloads model + llama.cpp)
4. Run: `./launch.sh` (start chatting!)

## 📊 Project Stats

- **Total Files**: 18 source files
- **Documentation**: 6 comprehensive guides
- **Code**: ~600 lines Python
- **Platforms**: Linux, macOS, Windows
- **License**: MIT (use freely!)

## 🔍 File Organization

```
stickllm/
├── Documentation (6 files)
│   ├── PROJECT_SUMMARY.md    ⭐ Start here
│   ├── README.md             📖 Main docs
│   ├── SETUP_SUOCOMMERCE.md     🎯 Custom setup
│   ├── ARCHITECTURE.md       📊 Diagrams
│   ├── STRUCTURE.md          📁 Directory guide
│   └── QUICKREF.md           ⚡ Quick ref
│
├── Launchers (3 files)
│   ├── launch.sh             🐧 Linux/Mac
│   ├── launch.bat            🪟 Windows
│   └── setup.sh              🔧 Automated setup
│
├── Application (3 files)
│   └── cli/
│       ├── stickllm.py       🐍 Main app
│       ├── config.yaml       ⚙️ Config
│       └── requirements.txt  📦 Deps
│
├── Context (1 file)
│   └── context/suocommerce/
│       └── architecture.md   📝 Example docs
│
└── Placeholders (6 files)
    ├── models/README.md      💾 Model guide
    └── runtime/README.md     🔧 Binary guide
```

## 💡 What This Is

StickLLM is a portable AI coding assistant that:
- Runs entirely from a USB drive
- Works on any machine without installation
- Maintains conversation history across devices
- Provides complete privacy (all local processing)
- Costs nothing to run (no subscriptions)

## 🎯 Perfect For

- Developers working across multiple machines
- Privacy-conscious teams
- Offline work scenarios
- Anyone wanting AI without cloud dependencies
- Technical architecture discussions (like Suocommerce)

## 🚦 Status

✅ **Production Ready**
- Fully functional
- Tested architecture
- Complete documentation
- Ready to deploy

## 📞 Support

- Check README.md troubleshooting section
- Review server logs: `cat server.log`
- Test server health: `curl http://localhost:8080/health`

---

**Ready to get started?** Open [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)!
