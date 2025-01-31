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
echo App Plan Name:  %APP_NAME%-plan
echo.

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

:: Prompt for confirmation
set /p CONTINUE="Do you want to continue with these settings? (Y/N): "
if /i "%CONTINUE%" neq "Y" (
    echo Operation cancelled by user.
    exit /b 0
)


:: Select subscription
echo.
echo Selecting subscription...
call az account set --subscription %SUBSCRIPTION_ID%

:: Create resource group
set /p CREATE_RG="Create Resource Group %RESOURCE_GROUP%? (Y/N): "
if /i "%CREATE_RG%"=="Y" (
    echo Creating resource group...
    call az group create --name %RESOURCE_GROUP% --location %LOCATION%
)

:: Create App Service Plan
set /p CREATE_PLAN="Create App Service Plan? (Y/N): "
if /i "%CREATE_PLAN%"=="Y" (
    echo Creating App Service Plan...
    call az appservice plan create ^
        --resource-group %RESOURCE_GROUP% ^
        --name "%APP_NAME%-plan" ^
        --location %LOCATION% ^
        --sku F1 ^
        --is-linux
)

:: Create Web App with VNET integration
set /p CREATE_WEBAPP="Create Web App with VNET integration? (Y/N): "
if /i "%CREATE_WEBAPP%"=="Y" (
    echo Creating Web App...
    call az webapp create ^
        --resource-group %RESOURCE_GROUP% ^
        --plan "%APP_NAME%-plan" ^
        --name %APP_NAME% ^
        --https-only true ^
        --runtime "PYTHON:3.12"

    echo Configuring app settings...
    call az webapp config appsettings set ^
        --resource-group %RESOURCE_GROUP% ^
        --name %APP_NAME% ^
        --settings SCM_DO_BUILD_DURING_DEPLOYMENT=1
)

echo Resource creation complete!
pause