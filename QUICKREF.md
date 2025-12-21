# StickLLM Quick Reference

## First Time Setup
```bash
cd /path/to/usb/stickllm
./setup.sh              # Downloads model and llama.cpp
```

## Daily Use

### Start Interactive Chat
```bash
./launch.sh                          # Auto-selects best model for your RAM
./launch.sh --name "My Project"      # Start with custom name
./launch.sh --session 5              # Resume session 5
```

### Manual Model Override (New in v1.2!)
```bash
# Force 33B model even on 16GB system
STICKLLM_MODEL=deepseek-coder-33b-instruct.Q4_K_M.gguf ./launch.sh

# Force smaller context to save memory
STICKLLM_CTX=2048 ./launch.sh

# Combine settings
STICKLLM_MODEL=deepseek-coder-33b-instruct.Q4_K_M.gguf STICKLLM_CTX=2048 ./launch.sh
```

### Quick Questions
```bash
./launch.sh ask "your question here"
```

### List Past Sessions
```bash
./launch.sh sessions
```

## Adaptive Model Selection (v1.2)

| Your RAM | Auto-Selected Model | Context | Performance |
|----------|---------------------|---------|-------------|
| 32GB+ | 33B (if available) | 8192 | Best quality |
| 24GB | 33B or 6.7B | 4096-8192 | Great |
| 16GB | 6.7B | 6144 | Fast & good |
| 8GB | 6.7B | 2048 | Usable |

## In-Chat Commands

| Command | Description |
|---------|-------------|
| `/help` | Show help |
| `/exit` | Exit chat |
| `/new` | Start new session |
| `/rename <name>` | Rename current session |
| `/session` | Show current session info |
| `/context` | Show loaded files |
| `/context add file.py` | Add file to context |
| `/context clear` | Clear context |

## Common Workflows

### Architecture Discussion
```bash
./launch.sh
/context add context/suocommerce/architecture.md
```

### Code Review
```bash
./launch.sh
/context add path/to/code.py
```

### Debug Help
```bash
/context add error.log
/context add src/problem_file.py
```

## File Locations

```
stickllm/
â”œâ”€â”€ models/              # Your GGUF models
â”œâ”€â”€ context/suocommerce/    # Project documentation
â”œâ”€â”€ chats/sessions.db    # All conversations
â””â”€â”€ runtime/             # llama.cpp binaries
```

## Tips

- Load context files before asking questions
- Use `--session` to continue discussions
- Bigger models (33B) for architecture, smaller (6.7B) for quick help
- Keep project docs in `context/` folder

## Troubleshooting

### Server won't start
```bash
cat server.log          # Check errors
lsof -i :8080          # Check if port in use
```

### Out of memory
- Use smaller model (6.7B instead of 33B)
- Close other applications
- Check available RAM: `free -h` (Linux) or Activity Monitor (Mac)

### Slow performance
- Ensure USB 3.0+ connection
- Use smaller model
- Reduce `--ctx-size` in launch.sh

## Model Quick Reference

| Model | Size | RAM | Speed | Best For |
|-------|------|-----|-------|----------|
| DeepSeek 6.7B Q5 | 5GB | 7GB | Fast | Quick questions |
| DeepSeek 33B Q4 | 20GB | 24GB | Medium | Architecture |
| Qwen2.5 32B Q5 | 22GB | 26GB | Medium | Complex reasoning |

## Getting Help

- Check README.md for full documentation
- Check SETUP_SUOCOMMERCE.md for detailed setup
- View logs: `cat server.log`
- Check server health: `curl http://localhost:8080/health`
