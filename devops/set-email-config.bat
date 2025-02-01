@echo off
setlocal

:: Load configuration
if exist config.bat (
    call config.bat
) else (
    echo Error: config.bat not found. Please copy config.template.bat to config.bat and update the values.
    exit /b 1
)

:: Display current configuration
echo.
echo Current configuration:
echo ---------------------
echo Resource Group:  %RESOURCE_GROUP%
echo App Name:       %APP_NAME%
echo SMTP Server:    %SMTP_SERVER%
echo SMTP Port:      %SMTP_PORT%
echo SMTP Username:  %SMTP_USERNAME%
echo SMTP Password:  %SMTP_PASSWORD%
echo Test Email:     %TEST_TO_EMAIL%
echo.

:: Validate required variables
if "%RESOURCE_GROUP%"=="" (
    echo Error: RESOURCE_GROUP not set in config.bat
    exit /b 1
)
if "%APP_NAME%"=="" (
    echo Error: APP_NAME not set in config.bat
    exit /b 1
)
if "%SMTP_SERVER%"=="" (
    echo Error: SMTP_SERVER not set in config.bat
    exit /b 1
)
if "%SMTP_PORT%"=="" (
    echo Error: SMTP_PORT not set in config.bat
    exit /b 1
)
if "%SMTP_USERNAME%"=="" (
    echo Error: SMTP_USERNAME not set in config.bat
    exit /b 1
)
if "%SMTP_PASSWORD%"=="" (
    echo Error: SMTP_PASSWORD not set in config.bat
    exit /b 1
)
if "%TEST_TO_EMAIL%"=="" (
    echo Error: TEST_TO_EMAIL not set in config.bat
    exit /b 1
)

:: Prompt for confirmation
set /p CONTINUE="Do you want to continue with these settings? (Y/N): "
if /i "%CONTINUE%" neq "Y" (
    echo Operation cancelled by user.
    exit /b 0
)

echo Setting up email configuration for Azure Web App...
call az webapp config appsettings set ^
    --resource-group %RESOURCE_GROUP% ^
    --name %APP_NAME% ^
    --settings ^
    SMTP_SERVER=%SMTP_SERVER% ^
    SMTP_PORT=%SMTP_PORT% ^
    SMTP_USERNAME=%SMTP_USERNAME% ^
    SMTP_PASSWORD="%SMTP_PASSWORD%" ^
    TEST_TO_EMAIL=%TEST_TO_EMAIL%

echo Email configuration complete.
pause 