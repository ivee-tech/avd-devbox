# Azure DevOps Pipelines for AVD Deployment

This repository contains Azure DevOps pipelines for deploying Azure Virtual Desktop (AVD) infrastructure and virtual machines.

## Pipeline Files

### 1. AVD Host Pool Infrastructure Pipeline
**File:** `azure-pipelines-avd.yml`
- **Purpose:** Deploys the AVD host pool, workspace, and application groups
- **Triggers:** Changes to `infra/avd.bicep`, `infra/avd.parameters.jsonc`, or `infra/deploy-avd.ps1`
- **Stages:**
  - Validate AVD Infrastructure
  - Deploy AVD Infrastructure

### 2. AVD VM Deployment Pipeline (Bash/Azure CLI)
**File:** `azure-pipelines-avd-vm.yml`
- **Purpose:** Deploys AVD virtual machines using Azure CLI
- **Triggers:** Changes to `infra/avd-vm.bicep`, `infra/avd-vm.parameters.jsonc`, or `infra/deploy-avd-vm.ps1`
- **Stages:**
  - Validate AVD VM Infrastructure
  - Deploy AVD VM
  - Post-Deployment Configuration

### 3. AVD VM Deployment Pipeline (PowerShell)
**File:** `azure-pipelines-avd-vm-powershell.yml`
- **Purpose:** Deploys AVD virtual machines using PowerShell scripts
- **Triggers:** Same as above
- **Stages:**
  - Validate AVD VM Infrastructure
  - Deploy AVD VM
  - Post-Deployment Verification

## Prerequisites

### 1. Azure DevOps Service Connection
Create an Azure Resource Manager service connection in your Azure DevOps project:
1. Go to Project Settings → Service connections
2. Create a new Azure Resource Manager connection
3. Update the `serviceConnectionName` variable in each pipeline file

### 2. Key Vault Setup
For secure password management, set up an Azure Key Vault:
1. Create an Azure Key Vault (e.g., `kv-avd-secrets`)
2. Add a secret for the VM admin password (e.g., `vm-admin-password`)
3. Grant the service principal access to the Key Vault
4. Update the `keyVaultName` and `adminPasswordSecret` variables in the VM pipeline files

### 3. Azure DevOps Environment
Create a deployment environment named 'Development' in Azure DevOps:
1. Go to Pipelines → Environments
2. Create a new environment named 'Development'
3. Configure approvals and checks as needed

## Configuration

### Variables to Update

In each pipeline file, update these variables according to your environment:

```yaml
variables:
  - name: resourceGroupName
    value: 'rg-opc-dev-001'  # Your resource group name
  - name: location
    value: 'australiaeast'   # Your Azure region
  - name: vmName
    value: 'vmopcdev-1'      # Your VM name
  - name: serviceConnectionName
    value: 'Azure-DevOps-Service-Connection'  # Your service connection name
  - name: keyVaultName
    value: 'kv-avd-secrets'  # Your Key Vault name
  - name: adminPasswordSecret
    value: 'vm-admin-password'  # Your secret name
```

### Parameter Files

Ensure your parameter files are configured correctly:
- `infra/avd.parameters.jsonc` - AVD host pool parameters
- `infra/avd-vm.parameters.jsonc` - VM deployment parameters

## Deployment Order

1. **First:** Run the AVD Host Pool pipeline (`azure-pipelines-avd.yml`)
   - This creates the host pool, workspace, and application groups
   
2. **Second:** Run one of the AVD VM pipelines
   - `azure-pipelines-avd-vm.yml` (Azure CLI/Bash approach)
   - OR `azure-pipelines-avd-vm-powershell.yml` (PowerShell approach)

## Pipeline Features

### Security Features
- Uses Azure Key Vault for sensitive data
- Service connection for secure Azure authentication
- Environment-based deployment approvals

### Validation Features
- Bicep template validation before deployment
- What-if analysis for infrastructure changes
- Post-deployment verification

### Monitoring Features
- Detailed logging and output
- Deployment status verification
- Resource configuration validation

## Usage

1. Import the desired pipeline YAML files into your Azure DevOps project
2. Configure the variables and service connections
3. Set up the Key Vault and secrets
4. Create the 'Development' environment
5. Run the AVD Host Pool pipeline first
6. Run the AVD VM pipeline to add VMs to the host pool

## Troubleshooting

### Common Issues

1. **Service Connection Authentication:**
   - Ensure the service principal has Contributor access to the resource group
   - Verify the service connection is properly configured

2. **Key Vault Access:**
   - Grant the service principal 'Key Vault Secrets User' role
   - Ensure the Key Vault allows access from Azure DevOps

3. **Resource Group:**
   - The pipelines will create the resource group if it doesn't exist
   - Ensure proper permissions for resource group creation

4. **Pipeline Triggers:**
   - Pipelines trigger on changes to specific paths
   - Manual runs are always available from the Azure DevOps UI

## Customization

You can customize the pipelines by:
- Adding additional validation stages
- Including integration tests
- Adding notification steps
- Implementing blue-green deployments
- Adding manual approval gates

## Support

For issues or questions:
1. Check the pipeline logs for detailed error messages
2. Verify all prerequisites are met
3. Ensure all variables are correctly configured
4. Review the Bicep templates and parameter files