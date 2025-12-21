# Changelog

All notable changes to StickLLM will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Cloud-assisted context compression
- Web UI option
- RAG integration for large codebases
- Git integration for automatic context
- Multi-model switching without restart

## [1.2.1] - 2024-12-21

### Fixed
- Variable scoping bug preventing automatic 33B model selection on 24GB+ systems
- Model paths now defined globally so adaptive selection works correctly

## [1.2.0] - 2024-12-21

### Added
- Adaptive model selection based on system RAM
- Automatic GPU layer offloading configuration
- Dynamic context size adjustment for available memory
- Support for 33B models with hybrid GPU/CPU processing
- Manual override via environment variables (STICKLLM_MODEL, STICKLLM_CTX, STICKLLM_GPU_LAYERS)
- Better resource detection for macOS and Linux

### Changed
- Improved model selection logic to prevent OOM crashes
- Context size now adapts to available system memory
- Enhanced launch script with detailed resource reporting

### Fixed
- GPU out-of-memory crash on M4 Pro with 16GB RAM
- Model loading failures with insufficient memory

## [1.1.0] - 2024-12-20

### Changed
- Internal improvements and bug fixes

## [1.0.0] - 2024-12-19

### Added
- Initial release of StickLLM
- Python CLI with terminal interface
- Session management with SQLite
- Context file loading system
- Cross-platform launcher scripts (Linux, macOS, Windows)
- Automated setup script
- Support for multiple GGUF models (DeepSeek, Qwen, CodeLlama)
- Configurable AI personas
- Background server management
- Real-time streaming responses
- Complete documentation suite

### Features
- Fully portable USB drive deployment
- No installation required
- 100% local processing (complete privacy)
- Persistent conversations across devices
- Project-aware context loading
- ANSI colored terminal output
- Session resume capability

### Documentation
- README.md - Complete user guide
- SETUP_SUOCOMMERCE.md - Customized setup guide
- ARCHITECTURE.md - System architecture diagrams
- STRUCTURE.md - Directory structure guide
- QUICKREF.md - Quick reference card
- LICENSE - MIT License

[Unreleased]: https://github.com/yourusername/stickllm/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/yourusername/stickllm/releases/tag/v1.0.0
