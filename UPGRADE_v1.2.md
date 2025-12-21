# Upgrading to StickLLM v1.2

## What's New in v1.2

- **Adaptive Model Selection**: Automatically detects your system RAM and selects optimal model
- **Smart GPU Offloading**: Dynamically configures GPU layers based on available memory
- **No More Crashes**: Prevents out-of-memory errors on systems with limited RAM
- **Manual Overrides**: Environment variables to force specific configurations
- **Better Multi-Machine Support**: Same USB adapts to different computers automatically

## Upgrading from v1.1 to v1.2

### Option 1: Using Git (Recommended)

If you're already using git:

```bash
cd /Volumes/YourUSB/stickllm
git pull origin main
```

Done! Your models and chat history are preserved.

### Option 2: Manual Update

If you don't have git set up yet:

1. **Backup your important data:**
```bash
cd /Volumes/YourUSB/stickllm
mkdir -p /tmp/stickllm-backup
cp -r chats/ /tmp/stickllm-backup/
cp -r context/ /tmp/stickllm-backup/
```

2. **Download v1.2:**
```bash
cd /Volumes/YourUSB
# Download new version
# Extract to temporary location
```

3. **Copy over your data:**
```bash
cp -r /tmp/stickllm-backup/chats /Volumes/YourUSB/stickllm/
cp -r /tmp/stickllm-backup/context /Volumes/YourUSB/stickllm/
```

4. **Keep your models** (no need to re-download):
Models in `models/` directory don't need to be touched.

### Option 3: Clean Install (if you want to start fresh)

1. Delete old stickllm directory
2. Extract v1.2
3. Run `./setup.sh` to download models again
4. Your old chat history will be gone (unless you backed it up)

## Testing the New Features

### Test Adaptive Selection

Just run normally - you'll see the new detection output:

```bash
./launch.sh
```

You should see:
```
Detecting system resources...
Total RAM: 16GB
Available models: 6.7B
Standard RAM (16GB) - Using 6.7B (optimized)
Selected model: deepseek-coder-6.7b-instruct.Q5_K_M.gguf
Context size: 6144 tokens
GPU layers: 33
```

### Test Manual Override

Force different settings:

```bash
# Try smaller context
STICKLLM_CTX=2048 ./launch.sh

# If you have 33B model, force it
STICKLLM_MODEL=deepseek-coder-33b-instruct.Q4_K_M.gguf ./launch.sh
```

## What Doesn't Change

- ✅ Your chat history (`chats/sessions.db`) - fully compatible
- ✅ Your models - no need to re-download
- ✅ Your context files - all preserved
- ✅ Your configuration - `config.yaml` unchanged

## Troubleshooting

### "Model not found" error

The model detection looks for specific filenames. If you have differently named models:

```bash
# List your models
ls -lh models/

# Use manual override
STICKLLM_MODEL=your-model-name.gguf ./launch.sh
```

### "Server crashes immediately"

The adaptive selection should prevent this, but if it still happens:

```bash
# Force minimal settings
STICKLLM_CTX=2048 STICKLLM_GPU_LAYERS=0 ./launch.sh

# Check logs
cat server.log
```

### Want the old behavior back?

Force specific settings:

```bash
# Exactly like v1.1
STICKLLM_CTX=4096 STICKLLM_GPU_LAYERS=33 ./launch.sh
```

## Setting Up Git for Future Updates

This is the LAST time you should have to manually update!

```bash
cd /Volumes/YourUSB/stickllm

# Initialize git
git init

# Add remote (use your GitHub username)
git remote add origin https://github.com/yourusername/stickllm.git

# Pull latest
git pull origin main

# From now on, updates are just:
git pull
```

See GIT_SETUP.md for detailed instructions.

## Questions?

- Check CHANGELOG.md for full list of changes
- See QUICKREF.md for new command examples
- Read README.md for complete documentation
