# Models Directory

Place your GGUF model files here.

## Recommended Models

### Quick Start (Good for testing)
- DeepSeek Coder 6.7B Q5_K_M (~5GB)
  https://huggingface.co/TheBloke/deepseek-coder-6.7B-instruct-GGUF

### Production Use
- DeepSeek Coder 33B Q4_K_M (~20GB) - Best for architecture discussions
- Qwen2.5 Coder 32B Q5_K_M (~22GB) - Great for complex reasoning
- CodeLlama 34B Q5_K_M (~24GB) - Solid all-rounder

## Download Instructions

Using huggingface-cli:
```bash
pip install huggingface-hub

huggingface-cli download TheBloke/deepseek-coder-6.7B-instruct-GGUF \
    deepseek-coder-6.7b-instruct.Q5_K_M.gguf \
    --local-dir ./
```

Or download directly from HuggingFace website.

## Model Naming

Keep filenames simple:
- deepseek-coder-6.7b-instruct.Q5_K_M.gguf
- deepseek-coder-33b-instruct.Q4_K_M.gguf

The launcher will auto-detect any .gguf file in this directory.
