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

:: Create deployment package with confirmation
set /p CREATE_ZIP="Do you want to create the deployment package? (Y/N): "
if /i "%CREATE_ZIP%"=="Y" (
    echo Creating deployment package...
    python create_zip.py
) else (
    echo Skipping deployment package creation.
)

:: Deploy with confirmation
set /p DEPLOY="Do you want to deploy the application code? (Y/N): "
if /i "%DEPLOY%"=="Y" (
    echo Deploying application code...
    call az webapp deploy ^
      --name %APP_NAME% ^
      --resource-group %RESOURCE_GROUP% ^
      --type zip ^
      --src-path ..\deploy.zip
) else (
    echo Skipping deployment.
)

:: Clean up deployment package if it exists
@REM if exist ..\deploy.zip (
@REM     del ..\deploy.zip
@REM )

echo Deployment complete!
pause 