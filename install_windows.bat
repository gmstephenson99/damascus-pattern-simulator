@echo off
REM ============================================================
REM Damascus Pattern Simulator 3D - Windows Installer
REM ============================================================
REM This script installs all required Python dependencies
REM for running the Damascus Pattern Simulator on Windows.
REM
REM Requirements: Python 3.8 or higher must be installed
REM ============================================================

echo.
echo ============================================================
echo  Damascus Pattern Simulator 3D - Windows Installer
echo ============================================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH!
    echo.
    echo Please install Python 3.8 or higher from:
    echo https://www.python.org/downloads/
    echo.
    echo Make sure to check "Add Python to PATH" during installation.
    echo.
    pause
    exit /b 1
)

echo [OK] Python is installed
python --version
echo.

REM Check Python version
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYVER=%%i
echo Detected Python version: %PYVER%
echo.

REM Create virtual environment (optional but recommended)
echo Creating virtual environment...
if exist venv (
    echo [SKIP] Virtual environment already exists
) else (
    python -m venv venv
    echo [OK] Virtual environment created
)
echo.

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat
echo.

REM Upgrade pip
echo Upgrading pip...
python -m pip install --upgrade pip
echo.

REM Install dependencies
echo ============================================================
echo  Installing Required Dependencies
echo ============================================================
echo.
echo This may take several minutes...
echo.

REM Install from requirements.txt if it exists
if exist requirements.txt (
    echo Installing from requirements.txt...
    pip install -r requirements.txt
) else (
    echo Installing dependencies individually...
    
    echo [1/7] Installing numpy...
    pip install numpy
    
    echo [2/7] Installing matplotlib...
    pip install matplotlib
    
    echo [3/7] Installing Pillow...
    pip install Pillow
    
    echo [4/7] Installing open3d...
    pip install open3d
    
    echo [5/7] Installing scipy...
    pip install scipy
    
    echo [6/7] Installing tk (if needed)...
    REM tk usually comes with Python on Windows
    
    echo [7/7] Verifying installation...
    pip list
)

echo.
echo ============================================================
echo  Installation Complete!
echo ============================================================
echo.
echo To run the Damascus Pattern Simulator:
echo   1. Run: run_windows.bat
echo   OR
echo   2. Manually activate venv: venv\Scripts\activate.bat
echo   3. Then run: python damascus_3d_gui.py
echo.
echo ============================================================
pause
