# Contributing to StickLLM

Thanks for your interest in contributing! This project aims to make AI coding assistance truly portable and private.

## How to Contribute

### Reporting Bugs
- Use GitHub Issues
- Include your OS, Python version, and model used
- Provide steps to reproduce
- Include relevant logs from `server.log`

### Suggesting Features
- Open an issue with the `enhancement` label
- Describe the use case
- Explain why it fits the project's goals

### Pull Requests

1. Fork the repo
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Test on your USB drive across different machines if possible
5. Commit with clear messages: `git commit -m 'Add amazing feature'`
6. Push: `git push origin feature/amazing-feature`
7. Open a Pull Request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/stickllm.git
cd stickllm

# Install dev dependencies
pip install -r cli/requirements.txt

# Test locally (without USB)
./launch.sh
```

## Code Style

- Follow PEP 8
- Use type hints where possible
- Add docstrings to functions
- Keep it simple - this runs on USB drives!

## Testing

- Test on multiple platforms (Linux, macOS, Windows)
- Verify with different models (6.7B, 33B)
- Check memory usage
- Ensure USB portability works

## Areas We Need Help

- [ ] Windows testing and improvements
- [ ] ARM Linux support (Raspberry Pi compatibility)
- [ ] Additional model support
- [ ] Performance optimizations
- [ ] Documentation improvements
- [ ] Translation to other languages
- [ ] Web UI (optional alternative to CLI)
- [ ] Cloud sync features

## Project Goals

Keep these in mind:
- **Privacy First**: Everything local by default
- **True Portability**: Must work from USB without installation
- **Simplicity**: Easy to use, minimal dependencies
- **Cross-Platform**: Linux, macOS, Windows

## Questions?

Open an issue or discussion on GitHub!
