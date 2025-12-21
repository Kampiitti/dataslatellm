@echo off
REM StickLLM Launcher Script for Windows
setlocal enabledelayedexpansion

echo ╔════════════════════════════════════╗
echo ║        StickLLM Launcher          ║
echo ║   Portable AI Coding Assistant    ║
echo ╚════════════════════════════════════╝
echo.

REM Get script directory
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo Detected OS: Windows
echo Architecture: %PROCESSOR_ARCHITECTURE%
echo.

REM Set paths
set "RUNTIME_DIR=%SCRIPT_DIR%runtime\windows"
set "LLAMA_BIN=%RUNTIME_DIR%\llama-server.exe"
set "MODEL_DIR=%SCRIPT_DIR%models"
set "DEFAULT_MODEL=%MODEL_DIR%\deepseek-coder-6.7b-instruct.Q5_K_M.gguf"

REM Check if llama.cpp binary exists
if not exist "%LLAMA_BIN%" (
    echo [ERROR] llama.cpp server not found at: %LLAMA_BIN%
    echo Please download llama.cpp for Windows.
    echo See: https://github.com/ggerganov/llama.cpp/releases
    pause
    exit /b 1
)

REM Find model file
set "MODEL_FILE="
if exist "%DEFAULT_MODEL%" (
    set "MODEL_FILE=%DEFAULT_MODEL%"
) else (
    for %%F in ("%MODEL_DIR%\*.gguf") do (
        set "MODEL_FILE=%%F"
        goto :model_found
    )
)

:model_found
if "%MODEL_FILE%"=="" (
    echo [ERROR] No model files found in %MODEL_DIR%
    echo Please download a GGUF model file.
    echo Recommended: DeepSeek Coder 6.7B
    echo Download from: https://huggingface.co/TheBloke/deepseek-coder-6.7B-instruct-GGUF
    pause
    exit /b 1
)

echo Using model: %MODEL_FILE%
echo.

REM Check if server is already running
curl -s http://localhost:8080/health > nul 2>&1
if %errorlevel% equ 0 (
    echo Server is already running at http://localhost:8080
) else (
    echo Starting llama.cpp server...
    
    REM Determine number of threads
    set /a N_THREADS=%NUMBER_OF_PROCESSORS% / 2
    
    REM Start server in background
    start /b "" "%LLAMA_BIN%" ^
        -m "%MODEL_FILE%" ^
        --port 8080 ^
        --ctx-size 8192 ^
        --n-predict 2048 ^
        --threads !N_THREADS! ^
        --log-disable ^
        > "%SCRIPT_DIR%server.log" 2>&1
    
    echo Server started
    echo Waiting for server to initialize...
    
    REM Wait for server to be ready
    set /a count=0
    :wait_loop
    curl -s http://localhost:8080/health > nul 2>&1
    if %errorlevel% equ 0 (
        echo Server is ready!
        goto :server_ready
    )
    set /a count+=1
    if !count! gtr 30 (
        echo [ERROR] Server failed to start
        exit /b 1
    )
    timeout /t 1 /nobreak > nul
    echo|set /p=.
    goto :wait_loop
)

:server_ready
echo.

REM Check for Python
where python > nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python 3 is not installed
    pause
    exit /b 1
)

REM Check for required Python packages
echo Checking Python dependencies...
python -c "import requests; import yaml" 2>nul
if %errorlevel% neq 0 (
    echo Installing required Python packages...
    python -m pip install --user requests pyyaml
)

REM Launch CLI
echo Launching StickLLM CLI...
echo.

set "PYTHONPATH=%SCRIPT_DIR%cli;%PYTHONPATH%"
python "%SCRIPT_DIR%cli\stickllm.py" %*

endlocal
