@echo off
REM StickLLM Windows Setup Script
setlocal enabledelayedexpansion

echo ╔════════════════════════════════════╗
echo ║    StickLLM Setup Assistant       ║
echo ╚════════════════════════════════════╝
echo.

REM Check for Python
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in PATH
    echo Please install Python 3.8+ from python.org
    pause
    exit /b 1
)

echo Checking Python version...
python --version

echo.
echo Installing Python dependencies...
python -m pip install --user requests pyyaml huggingface-hub
if %errorlevel% neq 0 (
    echo [WARNING] Failed to install some dependencies
    echo This might be okay if they're already installed
)

echo.
echo ═══════════════════════════════════
echo    Step 1: Select Model
echo ═══════════════════════════════════
echo.
echo Choose a model to download:
echo.
echo   1) DeepSeek Coder 6.7B Q5_K_M (~5GB) - Fast, good for testing
echo   2) DeepSeek Coder 33B Q4_K_M (~20GB) - Powerful, best for architecture
echo   3) Qwen2.5 Coder 32B Q5_K_M (~22GB) - Excellent reasoning
echo   4) Download both 6.7B and 33B (recommended for 1TB drive)
echo   5) Skip model download (I'll do it manually)
echo.

set /p model_choice="Enter choice [1-5]: "

if "%model_choice%"=="1" goto download_6b
if "%model_choice%"=="2" goto download_33b
if "%model_choice%"=="3" goto download_qwen
if "%model_choice%"=="4" goto download_both
if "%model_choice%"=="5" goto skip_model
echo Invalid choice
pause
exit /b 1

:download_6b
echo.
echo Downloading DeepSeek Coder 6.7B...
python -c "from huggingface_hub import hf_hub_download; import os; hf_hub_download(repo_id='TheBloke/deepseek-coder-6.7B-instruct-GGUF', filename='deepseek-coder-6.7b-instruct.Q5_K_M.gguf', local_dir='models', local_dir_use_symlinks=False)"
if %errorlevel% equ 0 (
    echo [SUCCESS] Downloaded DeepSeek 6.7B
) else (
    echo [ERROR] Download failed
    echo You can download manually from:
    echo https://huggingface.co/TheBloke/deepseek-coder-6.7B-instruct-GGUF
)
goto llama_download

:download_33b
echo.
echo Downloading DeepSeek Coder 33B...
echo This is a large file (~20GB), it will take a while...
python -c "from huggingface_hub import hf_hub_download; import os; hf_hub_download(repo_id='TheBloke/deepseek-coder-33B-instruct-GGUF', filename='deepseek-coder-33b-instruct.Q4_K_M.gguf', local_dir='models', local_dir_use_symlinks=False)"
if %errorlevel% equ 0 (
    echo [SUCCESS] Downloaded DeepSeek 33B
) else (
    echo [ERROR] Download failed
)
goto llama_download

:download_qwen
echo.
echo Downloading Qwen2.5 Coder 32B...
echo This is a large file (~22GB), it will take a while...
python -c "from huggingface_hub import hf_hub_download; import os; hf_hub_download(repo_id='Qwen/Qwen2.5-Coder-32B-Instruct-GGUF', filename='qwen2.5-coder-32b-instruct-q5_k_m.gguf', local_dir='models', local_dir_use_symlinks=False)"
if %errorlevel% equ 0 (
    echo [SUCCESS] Downloaded Qwen 32B
) else (
    echo [ERROR] Download failed
)
goto llama_download

:download_both
echo.
echo Downloading both models...
echo.
echo [1/2] Downloading DeepSeek 6.7B...
python -c "from huggingface_hub import hf_hub_download; import os; hf_hub_download(repo_id='TheBloke/deepseek-coder-6.7B-instruct-GGUF', filename='deepseek-coder-6.7b-instruct.Q5_K_M.gguf', local_dir='models', local_dir_use_symlinks=False)"
echo.
echo [2/2] Downloading DeepSeek 33B (this will take longer)...
python -c "from huggingface_hub import hf_hub_download; import os; hf_hub_download(repo_id='TheBloke/deepseek-coder-33B-instruct-GGUF', filename='deepseek-coder-33b-instruct.Q4_K_M.gguf', local_dir='models', local_dir_use_symlinks=False)"
goto llama_download

:skip_model
echo.
echo Skipping model download
echo Remember to download a model manually to the models\ folder
goto llama_download

:llama_download
echo.
echo ═══════════════════════════════════
echo    Step 2: Download llama.cpp
echo ═══════════════════════════════════
echo.
echo Please download llama.cpp for Windows:
echo.
echo 1. Visit: https://github.com/ggerganov/llama.cpp/releases
echo 2. Download: llama-[version]-windows-x64.zip
echo 3. Extract llama-server.exe to runtime\windows\
echo.
echo Press any key when you've downloaded the binary...
pause >nul

if exist "runtime\windows\llama-server.exe" (
    echo [SUCCESS] Found llama-server.exe
) else (
    echo [WARNING] Could not find runtime\windows\llama-server.exe
    echo Please download it manually before running launch.bat
)

:complete
echo.
echo ═══════════════════════════════════
echo        Setup Complete!
echo ═══════════════════════════════════
echo.
echo What's next:
echo.
echo 1. Make sure you have a model in models\
dir /b models\*.gguf 2>nul
if %errorlevel% equ 0 (
    echo    [OK] Models found:
    dir /b models\*.gguf
) else (
    echo    [!] No models found - download one manually
)
echo.
echo 2. Make sure you have llama-server.exe
if exist "runtime\windows\llama-server.exe" (
    echo    [OK] llama-server.exe found
) else (
    echo    [!] llama-server.exe missing - download manually
)
echo.
echo 3. Ready to launch!
echo    Run: launch.bat
echo.
pause
