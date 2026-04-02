# Azure Deployment Script for .NET 6 + SQL Server + React
# Prerequisites: Azure CLI installed and logged in (az login)

$resourceGroupName = "my-crud-app-rg"
$location = "eastus"
$sqlServerName = "my-crud-sqlserver-$(Get-Random)"
$databaseName = "testdb"
$sqlAdminUser = "sqladmin"
$sqlAdminPassword = "Password123!" # Change this!
$backendAppName = "my-crud-api-$(Get-Random)"
$frontendAppName = "my-crud-ui-$(Get-Random)"
$appServicePlanName = "my-crud-plan"

Write-Host "Creating Resource Group..." -ForegroundColor Cyan
az group create --name $resourceGroupName --location $location

Write-Host "Creating Azure SQL Server..." -ForegroundColor Cyan
az sql server create --name $sqlServerName --resource-group $resourceGroupName --location $location --admin-user $sqlAdminUser --admin-password $sqlAdminPassword

Write-Host "Configuring SQL Server Firewall (Allow Azure Services)..." -ForegroundColor Cyan
az sql server firewall-rule create --resource-group $resourceGroupName --server $sqlServerName --name AllowAzureServices --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

Write-Host "Creating SQL Database..." -ForegroundColor Cyan
az sql db create --resource-group $resourceGroupName --server $sqlServerName --name $databaseName --service-objective S0

Write-Host "Creating App Service Plan..." -ForegroundColor Cyan
az appservice plan create --name $appServicePlanName --resource-group $resourceGroupName --sku B1 --is-linux

Write-Host "Creating Backend App Service..." -ForegroundColor Cyan
az webapp create --resource-group $resourceGroupName --plan $appServicePlanName --name $backendAppName --runtime "DOTNET|6.0"

Write-Host "Configuring Backend Connection String..." -ForegroundColor Cyan
$connString = "Server=tcp:$sqlServerName.database.windows.net,1433;Initial Catalog=$databaseName;Persist Security Info=False;User ID=$sqlAdminUser;Password=$sqlAdminPassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
az webapp config connection-string set --resource-group $resourceGroupName --name $backendAppName --settings ApiDatabase="$connString" --connection-string-type SQLServer

Write-Host "Creating Frontend (Static Web App is recommended, but using App Service for simplicity in this script)..." -ForegroundColor Cyan
az webapp create --resource-group $resourceGroupName --plan $appServicePlanName --name $frontendAppName --runtime "NODE|16-lts"

Write-Host "Deployment script finished. URL for Backend: https://$backendAppName.azurewebsites.net"
Write-Host "URL for Frontend: https://$frontendAppName.azurewebsites.net"
Write-Host "Next steps: Build and deploy your apps using 'az webapp deployment source config-zip' or GitHub Actions."
