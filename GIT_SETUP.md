# Git Setup Guide for StickLLM

This guide walks you through publishing StickLLM to GitHub.

## Prerequisites

1. **GitHub Account** - Create one at github.com if you don't have one
2. **Git Installed** - Check with `git --version`
3. **SSH or HTTPS** - For pushing to GitHub

## Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `stickllm` (or your preferred name)
3. Description: `Portable AI coding assistant that runs from USB`
4. Choose **Public** (recommended) or Private
5. **DO NOT** initialize with README, .gitignore, or license (we have these)
6. Click "Create repository"

## Step 2: Initialize Local Repository

Navigate to your project folder:

```bash
cd /path/to/stickllm

# Initialize git
git init

# Add all files
git add .

# First commit
git commit -m "Initial commit: StickLLM v1.0.0

- Python CLI with terminal interface
- Session management with SQLite
- Context file loading
- Cross-platform support
- Automated setup
- Complete documentation"
```

## Step 3: Connect to GitHub

GitHub will show you commands. Use these:

```bash
# Add remote (replace with YOUR username)
git remote add origin https://github.com/YOURUSERNAME/stickllm.git

# Or if you use SSH:
git remote add origin git@github.com:YOURUSERNAME/stickllm.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 4: Create Version Tag

```bash
# Tag version 1.0.0
git tag -a v1.0.0 -m "StickLLM v1.0.0 - Initial Release"

# Push tags
git push origin --tags
```

## Step 5: Create a Release on GitHub

1. Go to your repo: `https://github.com/YOURUSERNAME/stickllm`
2. Click "Releases" → "Create a new release"
3. Choose tag: `v1.0.0`
4. Release title: `v1.0.0 - Initial Release`
5. Description:
```markdown
## 🎉 First Release of StickLLM!

Portable AI coding assistant that runs entirely from a USB drive.

### ✨ Features
- 100% local processing (complete privacy)
- Works on any machine without installation
- Persistent conversations across devices
- Context-aware project discussions
- Cross-platform (Linux, macOS, Windows)

### 📦 What's Included
- Python CLI application
- Automated setup script
- Support for multiple models
- Complete documentation

### 🚀 Quick Start
1. Download and extract to USB drive
2. Run `./setup.sh`
3. Run `./launch.sh`

See README.md for full documentation.

### 📊 System Requirements
- 8GB+ RAM (16GB recommended)
- 1TB USB SSD
- Python 3.8+
```

6. Click "Publish release"

## Step 6: Set Up Branch Protection (Optional)

For collaborative development:

1. Settings → Branches
2. Add rule for `main` branch
3. Enable:
   - Require pull request reviews
   - Require status checks to pass

## Step 7: Add Topics

Add GitHub topics for discoverability:
1. Click ⚙️ (gear icon) next to "About"
2. Add topics:
   - `ai`
   - `llm`
   - `coding-assistant`
   - `portable`
   - `privacy`
   - `usb`
   - `python`
   - `llama-cpp`
   - `local-first`

## Git Workflow for Future Development

### Daily Development

```bash
# Start working on a feature
git checkout -b feature/cloud-sync

# Make changes
git add .
git commit -m "Add cloud sync functionality"

# Push to GitHub
git push origin feature/cloud-sync
```

### Create Pull Request

1. Go to GitHub repo
2. Click "Pull requests" → "New pull request"
3. Select your branch
4. Write description
5. Create PR
6. Review and merge

### Merge to Main

```bash
# After PR is approved
git checkout main
git pull origin main
git merge feature/cloud-sync
git push origin main

# Tag new version
git tag -a v1.1.0 -m "Add cloud sync"
git push origin --tags
```

## Branch Strategy

Recommended branches:

```
main        - Production-ready code
develop     - Integration branch
feature/*   - New features
bugfix/*    - Bug fixes
hotfix/*    - Urgent fixes
```

Example:
```bash
# Create develop branch
git checkout -b develop
git push -u origin develop

# Feature branch from develop
git checkout develop
git checkout -b feature/web-ui
# ... work on feature ...
git push origin feature/web-ui
# Create PR to merge into develop
```

## Version Numbering

Follow Semantic Versioning (semver):

- **Major** (1.0.0 → 2.0.0): Breaking changes
- **Minor** (1.0.0 → 1.1.0): New features, backwards compatible
- **Patch** (1.0.0 → 1.0.1): Bug fixes

Examples:
```bash
# Bug fix
git tag -a v1.0.1 -m "Fix Windows path issue"

# New feature
git tag -a v1.1.0 -m "Add web UI option"

# Breaking change
git tag -a v2.0.0 -m "Refactor CLI API"
```

## Useful Git Commands

```bash
# Check status
git status

# See commit history
git log --oneline --graph

# Create new branch
git checkout -b feature-name

# Switch branches
git checkout main

# Update from GitHub
git pull origin main

# See changes
git diff

# Undo last commit (keep changes)
git reset --soft HEAD~1

# See all branches
git branch -a

# Delete local branch
git branch -d feature-name

# Delete remote branch
git push origin --delete feature-name
```

## .gitignore Explained

Already created for you. It excludes:
- Downloaded models (*.gguf) - too large for git
- Binary files (llama-server)
- Database files (sessions.db)
- Logs and temp files
- Python cache files

Users will download these via setup script.

## GitHub Actions (Optional)

You could add automated testing:

Create `.github/workflows/test.yml`:
```yaml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        python-version: ['3.8', '3.9', '3.10', '3.11']
    
    steps:
    - uses: actions/checkout@v2
    - name: Set up Python
      uses: actions/setup-python@v2
      with:
        python-version: ${{ matrix.python-version }}
    - name: Install dependencies
      run: |
        pip install -r cli/requirements.txt
    - name: Run tests
      run: |
        python -m pytest tests/
```

## Next Steps

After pushing to GitHub:

1. ✅ Add a nice README with screenshots
2. ✅ Create first release (v1.0.0)
3. ✅ Share on Reddit (r/Python, r/MachineLearning, r/SelfHosted)
4. ✅ Post on Hacker News
5. ✅ Tweet about it
6. ✅ Write a blog post

## Collaboration Tips

- Write clear commit messages
- Keep commits focused (one logical change per commit)
- Use branches for new features
- Review PRs carefully
- Update CHANGELOG.md
- Tag releases properly
- Respond to issues promptly

## Need Help?

- Git book: https://git-scm.com/book
- GitHub guides: https://guides.github.com
- Git cheatsheet: https://education.github.com/git-cheat-sheet-education.pdf

---

Ready to share your creation with the world! 🚀
