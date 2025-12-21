# StickLLM Setup for Suocommerce Development

This guide walks through setting up StickLLM specifically for your Suocommerce architecture and development work.

## Step 1: Purchase USB Drive

**Recommended: Samsung T7 Shield 1TB** (~$110-140)
- IP65 rated (water/dust resistant)
- Drop resistant to 3 meters
- Fast USB 3.2 Gen 2 (read: 1,050 MB/s)
- Perfect balance of durability and performance

Alternative: LaCie Rugged SSD 1TB if you need military-grade protection.

## Step 2: Initial Setup

### Download and Copy Files

1. Copy the entire `stickllm` folder to your USB drive root
2. Rename your USB drive to something memorable: "SUOCOMMERCE-AI" or similar

### Download Models

For your architecture work, I recommend having both models:

**Primary: DeepSeek Coder 33B (for deep reasoning)**
```bash
cd /Volumes/SUOCOMMERCE-AI/stickllm/models

# Download 33B model
huggingface-cli download TheBloke/deepseek-coder-33B-instruct-GGUF \
    deepseek-coder-33b-instruct.Q4_K_M.gguf \
    --local-dir .
```

**Secondary: DeepSeek Coder 6.7B (for quick questions)**
```bash
# Download 6.7B model
huggingface-cli download TheBloke/deepseek-coder-6.7B-instruct-GGUF \
    deepseek-coder-6.7b-instruct.Q5_K_M.gguf \
    --local-dir .
```

This gives you:
- 33B for strategic architecture discussions (~20GB)
- 6.7B for fast code help (~5GB)
- Still leaves ~975GB free on 1TB drive

### Get llama.cpp Binary

**macOS (if using Mac):**
```bash
cd /Volumes/SUOCOMMERCE-AI/stickllm/runtime
mkdir -p macos

# Download latest release
# Visit: https://github.com/ggerganov/llama.cpp/releases
# Download llama-*-macos-arm64.zip (M1/M2) or llama-*-macos-x64.zip (Intel)
# Extract llama-server to runtime/macos/

# Or compile for best performance:
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
make LLAMA_METAL=1  # Use Metal GPU acceleration
cp llama-server /Volumes/SUOCOMMERCE-AI/stickllm/runtime/macos/
```

**Linux:**
```bash
cd /Volumes/SUOCOMMERCE-AI/stickllm/runtime
mkdir -p linux

# Download from releases or compile
make
cp llama-server /Volumes/SUOCOMMERCE-AI/stickllm/runtime/linux/
```

## Step 3: Customize for Suocommerce

### Add Your Architecture Documentation

```bash
cd /Volumes/SUOCOMMERCE-AI/stickllm/context/suocommerce

# Add these files (examples already provided):
# - architecture.md (overview)
# - commandos-overview.md (detailed component breakdown)
# - tech-stack.md (technology decisions)
# - integration-decisions.md (CRM/ERP integration notes)
```

### Update Config

Edit `cli/config.yaml` to set defaults:

```yaml
models:
  default: deepseek-coder-33b  # Use big model by default

contexts:
  suocommerce:
    description: "Suocommerce architecture and product development"
    files:
      - context/suocommerce/architecture.md
      - context/suocommerce/commandos-overview.md
      - context/suocommerce/tech-stack.md
    persona: architect

personas:
  architect: |
    You are a senior software architect working on Suocommerce's CommandOS.
    You understand the separation between technology-level capabilities and product-level features.
    You think in terms of:
    - Network-level AI integration vs application-level features
    - Producer-consumer architectures for billion-scale data
    - Privacy-by-design with time-windowed learning
    - Meta-learning and evolving AI prompts
    When discussing architecture, always ask "What's the underlying technical capability?"
    You favor hybrid approaches combining specialized databases (ClickHouse, Weaviate, Redis, PostgreSQL).
```

## Step 4: Test on Each Machine

### Work Machine
```bash
cd /Volumes/SUOCOMMERCE-AI/stickllm
./launch.sh chat

# Test it works
You: /context add context/suocommerce/architecture.md
You: Explain the difference between technology-level and product-level thinking
```

### Home Machine
Same process - just plug in USB and run `./launch.sh`

### Travel Laptop
Same process - your entire AI brain follows you

## Step 5: Typical Workflows

### Architecture Discussion Session

```bash
./launch.sh chat

# Load Suocommerce context
/context add context/suocommerce/architecture.md

# Start discussion
You: I'm thinking about how to implement the lazy automation feature for call routing. 
     Should this be part of Agent AI or AIRI?

# AI will respond with full context of your architecture
```

### Code Review

```bash
./launch.sh chat

# Add the file to review
/context add ~/suocommerce/src/airi/call_processor.py

You: Review this code for potential bottlenecks in billion-scale scenarios
```

### Quick Technical Question

```bash
# Use the fast model for quick answers
./launch.sh ask "What's the best way to implement time-windowed data in ClickHouse?"
```

### Integration Planning

```bash
./launch.sh chat

/context add context/suocommerce/integration-decisions.md

You: We're considering Make.com vs n8n for workflow automation. 
     Given our producer-consumer architecture and privacy requirements, 
     which should we use where?
```

## Step 6: Maintenance

### Keep Chats Organized

Sessions are automatically saved. View them:
```bash
./launch.sh sessions
```

Resume important discussions:
```bash
./launch.sh chat --session 42
```

### Update Models (Optional)

As new models release, download and test:
```bash
cd /Volumes/SUOCOMMERCE-AI/stickllm/models

# Try new Qwen model
huggingface-cli download Qwen/Qwen2.5-Coder-32B-Instruct-GGUF \
    qwen2.5-coder-32b-instruct-q5_k_m.gguf \
    --local-dir .

# Edit launch.sh to use new model
```

### Backup Conversations

Your conversations are in `chats/sessions.db` - periodically backup:
```bash
cp chats/sessions.db chats/sessions.backup.$(date +%Y%m%d).db
```

## Expected Performance

### Model Load Times (USB 3.1 SSD)
- First load: ~20-30 seconds
- Subsequent loads (if server kept running): instant

### Response Speed (depends on CPU)
- 6.7B model: ~30-50 tokens/sec (fast responses)
- 33B model: ~10-20 tokens/sec (thoughtful responses)

### Context Window
- Can handle up to 8,192 tokens (about 6,000 words)
- Enough for full architecture doc + conversation

## Tips for Suocommerce Development

1. **Start sessions with context**: Always load architecture.md first
2. **Use personas**: The "architect" persona is optimized for your thinking style
3. **Separate models**: Use 6.7B for quick coding, 33B for architecture
4. **Document decisions**: Add new docs to context/ as your architecture evolves
5. **Resume sessions**: Continue architecture discussions across days

## Troubleshooting

### "Server failed to start"
- Check if 8080 is in use: `lsof -i :8080`
- Try smaller model if low on RAM
- Check server.log for errors

### Slow on old laptop
- Use 6.7B model instead of 33B
- Reduce context: `--ctx-size 4096` in launch.sh
- Close other applications

### USB not mounting
- Ensure USB 3.0+ port
- Check drive isn't corrupted
- Reformat if needed (backup first!)

## Next Steps

Once comfortable:
1. Add more Suocommerce documentation to context/
2. Experiment with different personas for different tasks
3. Create custom contexts for specific projects
4. Consider adding second model (Qwen2.5) for comparison

---

Your portable AI architect is ready! 🚀

Now you can discuss CommandOS architecture whether you're at the office, home, or traveling.
