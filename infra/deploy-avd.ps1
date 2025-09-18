param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    [Parameter(Mandatory=$true)]
    [string]$Location
)

$ErrorActionPreference = 'Stop'

# Check Azure CLI login
if (-not (az account show 2>$null)) {
    Write-Host "Logging in to Azure..."
    az login | Out-Null
}

# Check if resource group exists
$rgExists = az group exists --name $ResourceGroupName | ConvertFrom-Json
if (-not $rgExists) {
    Write-Host "Creating resource group $ResourceGroupName in $Location..."
    az group create --name $ResourceGroupName --location $Location | Out-Null
}

# Deploy the Bicep template with parameters file
Write-Host "Deploying avd.bicep to resource group $ResourceGroupName using avd.parameters.jsonc..."
az deployment group create --resource-group $ResourceGroupName --template-file "$(Join-Path $PSScriptRoot 'avd.bicep')" --parameters "@$(Join-Path $PSScriptRoot 'avd.parameters.jsonc')"

Write-Host "Deployment complete."
