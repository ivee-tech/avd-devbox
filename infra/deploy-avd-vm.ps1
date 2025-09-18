param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    [Parameter(Mandatory=$false)]
    [string]$VmName,
    [Parameter(Mandatory=$false)]
    [SecureString]$AdminPassword,
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

# # Check Azure CLI login
# if (-not (az account show | Out-Null)) {
#     Write-Host "Logging in to Azure..."
#     az login | Out-Null
# }

# Check if resource group exists
$rgExists = az group exists --name $ResourceGroupName | ConvertFrom-Json
if (-not $rgExists) {
    Write-Host "Creating resource group $ResourceGroupName in $Location..."
    az group create --name $ResourceGroupName --location $Location | Out-Null
}

# Build parameter override string
$paramOverride = ""
if ($VmName) {
    $paramOverride += " vmName=$VmName"
}
if (-not $AdminPassword) {
    Write-Host "Enter admin password:"
    $AdminPassword = Read-Host -AsSecureString
}
# Convert SecureString to plain text for Azure CLI
$plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($AdminPassword))
if ($plainPassword) {
    $paramOverride += "adminPassword=$plainPassword"
}

# Run Azure CLI what-if for pre-deployment validation
Write-Host "Running Azure CLI what-if to preview changes..."
az deployment group create --resource-group $ResourceGroupName --template-file "$(Join-Path $PSScriptRoot 'avd-vm.bicep')" --parameters "@$(Join-Path $PSScriptRoot 'avd-vm.parameters.jsonc')"$paramOverride --what-if

# If not WhatIf, perform actual deployment
if (-not $WhatIf) {
    Write-Host "Deploying avd-vm.bicep to resource group $ResourceGroupName using avd-vm.parameters.jsonc..."
    az deployment group create --resource-group $ResourceGroupName --template-file "$(Join-Path $PSScriptRoot 'avd-vm.bicep')" --parameters "@$(Join-Path $PSScriptRoot 'avd-vm.parameters.jsonc')"$paramOverride
    Write-Host "Deployment complete."
} else {
    Write-Host "What-if completed. No resources were deployed."
}
