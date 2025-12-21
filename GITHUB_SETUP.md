# 🚀 Setting Up Your StickLLM GitHub Repository

Quick guide to get your StickLLM project on GitHub with proper version control.

## ✅ What's Already Prepared

Your project includes:
- ✅ `.gitignore` - Excludes models, binaries, databases
- ✅ `LICENSE` - MIT License
- ✅ `README.md` - Main documentation with badges
- ✅ `CONTRIBUTING.md` - Contribution guidelines
- ✅ `CHANGELOG.md` - Version history
- ✅ GitHub Actions workflows (CI/CD)
- ✅ Issue templates (bug reports, feature requests)

## 📋 Quick Setup (5 Minutes)

### 1. Create GitHub Repository

Go to https://github.com/new and create a new repository:

```
Repository name: stickllm
Description: Portable AI coding assistant for USB drives - 100% private, truly portable
Public/Private: Public (recommended for open source)
```

**Important**: Don't initialize with README, .gitignore, or license (we have these!)

### 2. Initialize Git in Your Project

```bash
# Navigate to your USB drive
cd /Volumes/YourUSB/stickllm  # Mac
# or
cd /media/yourname/YourUSB/stickllm  # Linux
# or
cd D:\stickllm  # Windows

# Initialize git
git init

# Add all files
git add .

# First commit
git commit -m "Initial commit: StickLLM v1.0.0"

# Add your GitHub remote (replace 'yourusername')
git remote add origin https://github.com/yourusername/stickllm.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### 3. Verify on GitHub

Go to `https://github.com/yourusername/stickllm` and verify:
- ✅ README.md displays with badges
- ✅ Code files are there
- ✅ .gitignore is working (no .gguf files, no binaries)
- ✅ GitHub Actions tab exists

## 🏷️ Creating Your First Release

Once pushed, create v1.0.0 release:

```bash
# Tag the current commit
git tag -a v1.0.0 -m "StickLLM v1.0.0 - Initial release"

# Push the tag
git push origin v1.0.0
```

This will trigger the GitHub Actions release workflow automatically!

## 🔄 Development Workflow

### Creating a Feature Branch

```bash
# Create and switch to feature branch
git checkout -b feature/cloud-sync

# Make changes...
# Edit files...

# Commit changes
git add .
git commit -m "feat: Add cloud-assisted context compression"

# Push to GitHub
git push origin feature/cloud-sync
```

### Opening a Pull Request

1. Go to your GitHub repository
2. Click "Pull requests" > "New pull request"
3. Select your feature branch
4. Fill in description
5. Create pull request

GitHub Actions will automatically:
- Run tests on Linux, macOS, Windows
- Check code formatting
- Verify scripts

### Merging to Main

Once tests pass:
1. Review code changes
2. Click "Merge pull request"
3. Delete the feature branch

## 📊 GitHub Repository Settings

### Recommended Settings

Go to Settings in your GitHub repo:

**General:**
- ✅ Enable Issues
- ✅ Enable Discussions (for Q&A)
- ✅ Disable Wiki (use README instead)

**Branches:**
- Set `main` as default branch
- Add branch protection rules:
  - ✅ Require pull request reviews
  - ✅ Require status checks (GitHub Actions)
  - ✅ No force pushes

**Actions:**
- ✅ Allow all actions (for CI/CD)

### Topics (for discoverability)

Add these topics to your repo:
```
ai, llm, coding-assistant, portable, privacy, usb, 
local-ai, claude-code, github-copilot-alternative,
python, offline-ai, cross-platform
```

## 🔖 Version Management

### Semantic Versioning

Follow [Semver](https://semver.org/):
- `MAJOR.MINOR.PATCH` (e.g., 1.0.0)
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

### Updating Version

1. Update `cli/version.py`:
```python
VERSION = "1.1.0"
```

2. Update `CHANGELOG.md`:
```markdown
## [1.1.0] - 2024-01-15
### Added
- Cloud-assisted context compression
### Fixed
- Windows path issue
```

3. Commit, tag, and push:
```bash
git add .
git commit -m "chore: Bump version to 1.1.0"
git tag -a v1.1.0 -m "StickLLM v1.1.0"
git push && git push --tags
```

## 🤝 Collaboration

### Adding Collaborators

Settings > Collaborators > Add people

Give access to:
- Teammates
- Contributors you trust

### Managing Issues

**Enable issue templates:** Already set up!
- Bug reports
- Feature requests

**Labels to create:**
```
bug, enhancement, documentation, help-wanted, 
good-first-issue, priority-high, windows, macos, linux
```

### Discussions

Enable Discussions for:
- Q&A
- Show and tell
- Ideas
- General chat

## 📈 GitHub Insights

### Metrics to Track

- ⭐ Stars (measure interest)
- 🍴 Forks (people adapting it)
- 👀 Watchers (active followers)
- 📊 Traffic (views, clones)
- 📝 Issues (user engagement)
- 🔀 Pull requests (contributions)

### README Badges

Already included:
```markdown
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
```

Add more later:
- GitHub stars
- Contributors count
- Latest release
- Build status

## 🎓 Git Best Practices

### Commit Messages

Use conventional commits:
```
feat: Add new feature
fix: Bug fix
docs: Documentation only
style: Code style (formatting)
refactor: Code restructure
test: Add tests
chore: Maintenance
```

### Branch Naming

```
feature/cloud-sync
fix/windows-path-issue
docs/update-readme
refactor/context-loading
```

### When to Commit

- After completing a logical unit of work
- Before switching tasks
- At the end of the day
- When tests pass

### What NOT to Commit

Already in .gitignore:
- ❌ Model files (*.gguf)
- ❌ Binaries (llama-server)
- ❌ Databases (sessions.db)
- ❌ Logs
- ❌ __pycache__

## 🔒 Security

### Never Commit

- API keys
- Passwords
- Private keys
- Personal data
- Model files (use setup script)

### GitHub Secrets

For CI/CD, use GitHub Secrets:
Settings > Secrets and variables > Actions

## 📱 GitHub Mobile

Install GitHub mobile app to:
- Review pull requests
- Respond to issues
- Get notifications
- Track activity

## 🎯 Next Steps

After setup:

1. ✅ Write a great README
2. ✅ Add topics for discoverability
3. ✅ Enable Discussions
4. ✅ Share on social media
5. ✅ Submit to awesome lists
6. ✅ Write blog post
7. ✅ Create demo video

## 🚀 Marketing Your Project

### Where to Share

- Reddit: r/LocalLLaMA, r/selfhosted, r/privacy
- Hacker News: Show HN
- Twitter/X: #LocalAI #PrivacyFirst
- Dev.to: Write tutorial
- YouTube: Demo video
- Product Hunt: Launch

### What to Highlight

- 🔒 **100% Private** (no cloud)
- 🚀 **Truly Portable** (USB drive)
- 💰 **Zero Monthly Cost** (vs subscriptions)
- 🎯 **Different from RPi** (software vs hardware)

## ❓ Troubleshooting

### Large File Error

If you accidentally commit models:
```bash
git rm --cached models/*.gguf
git commit -m "Remove large model files"
git push
```

### Authentication Issues

Use SSH instead of HTTPS:
```bash
git remote set-url origin git@github.com:yourusername/stickllm.git
```

### Merge Conflicts

```bash
# Pull latest changes
git pull origin main

# Resolve conflicts in files
# Edit conflicted files

# Mark as resolved
git add .
git commit -m "Resolve merge conflict"
```

## 📚 Resources

- [GitHub Docs](https://docs.github.com)
- [Git Book](https://git-scm.com/book)
- [Conventional Commits](https://www.conventionalcommits.org)
- [Semver](https://semver.org)

---

**You're all set!** Your StickLLM project is now properly version controlled and ready for collaboration. 🎉
