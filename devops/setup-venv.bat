@echo off
echo Creating Python virtual environment...

:: Check if venv folder exists
if exist ..\venv (
    echo Virtual environment already exists.
    set /p DELETE_VENV="Do you want to delete and recreate it? (Y/N): "
    if /i "%DELETE_VENV%"=="Y" (
        echo Removing existing virtual environment...
        rmdir /s /q ..\venv
        echo Creating new virtual environment...
        python -m venv ..\venv
    )
) else (
    echo Creating new virtual environment...
    python -m venv ..\venv
)

:: Activate virtual environment
echo Activating virtual environment...
call ..\venv\Scripts\activate

:: Install requirements
echo Installing requirements...
pip install -r ..\requirements.txt

echo Virtual environment setup complete!
echo To activate the virtual environment manually, run: venv\Scripts\activate
pause 