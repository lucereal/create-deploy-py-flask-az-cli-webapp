@echo off
setlocal

:: Load configuration
if exist config.bat (
    call config.bat
) else (
    echo Error: config.bat not found. Please copy config.template.bat to config.bat and update the values.
    exit /b 1
)

:: Display all variables
echo.
echo Current configuration:
echo ---------------------
echo Subscription ID: %SUBSCRIPTION_ID%
echo Resource Group:  %RESOURCE_GROUP%
echo Location:       %LOCATION%
echo App Name:       %APP_NAME%

echo.

:: Prompt for confirmation
set /p CONTINUE="Do you want to continue with these settings? (Y/N): "
if /i "%CONTINUE%" neq "Y" (
    echo Operation cancelled by user.
    exit /b 0
)

:: Validate required variables
if "%SUBSCRIPTION_ID%"=="" (
    echo Error: SUBSCRIPTION_ID not set in config.bat
    exit /b 1
)
if "%RESOURCE_GROUP%"=="" (
    echo Error: RESOURCE_GROUP not set in config.bat
    exit /b 1
)
if "%LOCATION%"=="" (
    echo Error: LOCATION not set in config.bat
    exit /b 1
)
if "%APP_NAME%"=="" (
    echo Error: APP_NAME not set in config.bat
    exit /b 1
)


echo Selecting subscription...
call az account set --subscription %SUBSCRIPTION_ID%

:: Deploy the application code
echo Creating deployment package...
powershell Compress-Archive -Path ..\* -DestinationPath ..\deploy.zip -Force

echo Deploying application code...
call az webapp deploy ^
  --name %APP_NAME% ^
  --resource-group %RESOURCE_GROUP% ^
  --type zip ^
  --src-path ..\deploy.zip

:: Clean up deployment package
del .\deploy.zip

echo Deployment complete!
pause 