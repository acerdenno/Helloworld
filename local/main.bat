@echo off
setlocal

REM Check if at least one argument is provided
if "%~1"=="" (
    echo Usage: main.bat [list|run job_name]
    echo.
    echo list   - Lists all available jobs
    echo run    - Runs the specified job (requires job_name)
    exit /b 1
)

REM Read secrets file
for /f "tokens=1,2 delims==" %%a in (secrets.txt) do (
    set "%%a=%%b"
)

REM Check if user and server are set
if "%user%"=="" (
    echo Error: User not specified in secrets file.
    exit /b 1
)
if "%server%"=="" (
    echo Error: Server not specified in secrets file.
    exit /b 1
)

REM Handle the command argument
set "command=%~1"

REM List all available jobs
if "%command%"=="list" (
    echo Listing all jobs...
    list
    exit /b 0
)

REM Run the specified job
if "%command%"=="run" (
    if "%~2"=="" (
        echo Error: Job name not specified.
        echo Usage: main.bat run job_name
        exit /b 1
    )

    set "job_name=%~2"

    REM Check if the job directory exists
    if not exist "job_dir\" (
        echo Error: job_dir directory does not exist.
        exit /b 1
    )

    REM Check if the job_name.config and job_name.script files exist
    if not exist "job_dir\%job_name%.config" (
        echo Error: Configuration file for job "%job_name%" does not exist.
        exit /b 1
    )
    if not exist "job_dir\%job_name%.script" (
        echo Error: Script file for job "%job_name%" does not exist.
        exit /b 1
    )

    echo Running job "%job_name%"...
    run %job_name%

    REM Check if run command succeeded
    if %ERRORLEVEL% neq 0 (
        echo Error: Failed to run job "%job_name%".
        exit /b %ERRORLEVEL%
    )

    echo Job "%job_name%" is being processed.
    exit /b 0
)

REM Show usage if command is not recognized
echo Error: Invalid command "%command%".
echo Usage: main.bat [list|run job_name]
echo.
echo list   - Lists all available jobs
echo run    - Runs the specified job (requires job_name)
exit /b 1
