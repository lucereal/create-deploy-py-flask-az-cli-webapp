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
echo VNET Name:      %APP_NAME%-vnet
echo Subnet Name:    %APP_NAME%-subnet
echo ASE Name:       %APP_NAME%-ase
echo VNET Range:     10.0.0.0/16
echo Subnet Range:   10.0.0.0/24
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

:: Create Virtual Network and Subnet
set /p CREATE_VNET="Create Virtual Network and Subnet? (Y/N): "
if /i "%CREATE_VNET%"=="Y" (
    echo Creating Virtual Network and Subnet...
    call az network vnet create ^
        --resource-group %RESOURCE_GROUP% ^
        --name "%APP_NAME%-vnet" ^
        --address-prefixes 10.0.0.0/16 ^
        --subnet-name "%APP_NAME%-subnet" ^
        --subnet-prefixes 10.0.0.0/24

    echo Delegating subnet to Microsoft.Web/hostingEnvironments...
    call az network vnet subnet update ^
        --resource-group %RESOURCE_GROUP% ^
        --vnet-name "%APP_NAME%-vnet" ^
        --name "%APP_NAME%-subnet" ^
        --delegations Microsoft.Web/serverFarms
)

:: Create App Service Environment
set /p CREATE_ASE="Create App Service Environment (takes 20-30 minutes)? (Y/N): "
if /i "%CREATE_ASE%"=="Y" (
    echo Creating App Service Environment...
    call az appservice ase create ^
        --name "%APP_NAME%-ase" ^
        --resource-group %RESOURCE_GROUP% ^
        --vnet-name "%APP_NAME%-vnet" ^
        --subnet "%APP_NAME%-subnet" ^
        --kind asev3
)

:: Create App Service Plan
set /p CREATE_PLAN="Create App Service Plan? (Y/N): "
if /i "%CREATE_PLAN%"=="Y" (
    echo Creating App Service Plan...
    call az appservice plan create ^
        --resource-group %RESOURCE_GROUP% ^
        --name "%APP_NAME%-plan" ^
        --location %LOCATION% ^
        --sku B1 ^
        --is-linux
)

:: Create Web App with VNET integration
set /p CREATE_WEBAPP="Create Web App with VNET integration? (Y/N): "
if /i "%CREATE_WEBAPP%"=="Y" (
    echo Creating Web App...
    call az webapp create ^
        --resource-group %RESOURCE_GROUP% ^
        --plan "%APP_NAME%-plan" ^
        --vnet "%APP_NAME%-vnet" ^
        --subnet "%APP_NAME%-subnet" ^
        --name %APP_NAME% ^
        --https-only true ^
        --multicontainer-config-file ../docker-compose.yml ^
        --multicontainer-config-type COMPOSE

)

echo Resource creation complete!
pause