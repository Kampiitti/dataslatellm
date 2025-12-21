# Git Setup for StickLLM v1.2

## Why Git Now?

From v1.2 onwards, you can update StickLLM with just `git pull` instead of re-downloading everything. Your models and chat history stay untouched.

## Quick Setup (5 Minutes)

### 1. Initialize Git on Your USB Drive

```bash
cd /Volumes/YourUSB/stickllm

# Initialize git
git init

# Add the .gitignore (excludes models, chats, logs)
git add .gitignore

# Make first commit
git add .
git commit -m "StickLLM v1.2 - Adaptive model selection"
```

### 2. Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `stickllm`
3. Make it **Private** (your personal version)
4. Don't initialize with README (we have one)
5. Click "Create repository"

### 3. Connect to GitHub

```bash
# Add your GitHub remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/stickllm.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### 4. Future Updates

When v1.3 releases:

```bash
cd /Volumes/YourUSB/stickllm
git pull origin main
```

Done! Models and chats automatically preserved.

## What Gets Synced vs What Stays Local

### Synced to GitHub (Version Controlled):
- ✅ Code (CLI, scripts)
- ✅ Documentation
- ✅ Configuration templates
- ✅ Context examples

### Stays on Your USB Only (Gitignored):
- 🔒 Models (*.gguf files) - Too large for git
- 🔒 Chat history (chats/ directory) - Private
- 🔒 Runtime binaries (llama-server) - Platform-specific
- 🔒 Logs and temporary files

## Alternative: Fork the Official Repo

If there's an official StickLLM repo:

```bash
# Fork it on GitHub, then:
git clone https://github.com/YOUR_USERNAME/stickllm.git /Volumes/YourUSB/stickllm
cd /Volumes/YourUSB/stickllm

# Add official repo as upstream
git remote add upstream https://github.com/official/stickllm.git

# Future updates:
git fetch upstream
git merge upstream/main
```

## Customizing for Suocommerce

You can maintain your own branch with Suocommerce-specific customizations:

```bash
# Create Suocommerce branch
git checkout -b suocommerce

# Add your custom context files
cp ~/suocommerce-docs/* context/suocommerce/
git add context/suocommerce/
git commit -m "Add Suocommerce context"

# Push your branch
git push -u origin suocommerce

# Switch between versions:
git checkout main           # Official version
git checkout suocommerce    # Your customized version
```

## Troubleshooting

### "Models are being tracked by git"

They shouldn't be if .gitignore is working:

```bash
# Check what's being tracked
git status

# If models show up, they're not ignored:
git rm --cached models/*.gguf
git commit -m "Remove models from tracking"
```

### "Too large to push"

Accidentally committed models:

```bash
# Remove from history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch models/*.gguf" \
  --prune-empty --tag-name-filter cat -- --all

# Force push
git push origin --force --all
```

## Best Practices

1. **Commit often** when making changes
2. **Never commit** models or chat history
3. **Use branches** for experiments
4. **Pull before editing** on different machines
5. **Push regularly** to back up code changes

## Need Help?

See full GIT_SETUP.md for detailed instructions and workflows.
