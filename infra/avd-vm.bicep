param vmName string
param location string = resourceGroup().location
param vnetName string
param subnetName string
param hostPoolName string
param adminUsername string = 'localAdminUser'
@secure()
param adminPassword string

var subnetResourceId = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
var intuneMdmId = '0000000a-0000-0000-c000-000000000000'
var modulesUrl = 'https://wvdportalstorageblob.blob.${environment().suffixes.storage}/galleryartifacts/Configuration_3-10-2021.zip'


resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2025-04-01-preview' existing = {
  name: hostPoolName
}

module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.20.0' = {
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    adminUsername: adminUsername
    availabilityZone: -1
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: vmName
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: subnetResourceId
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      caching: 'ReadWrite'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_D2s_v3'
    // Non-required parameters
    adminPassword: adminPassword
    extensionAadJoinConfig: {
      enabled: true
      settings: {
        mdmId: intuneMdmId
      }
      tags: {
      }
    }
    extensionHostPoolRegistration: {
      configurationFunction: 'Configuration.ps1\\AddSessionHost'
      enabled: true
      hostPoolName: hostPoolName
      modulesUrl: modulesUrl
      registrationInfoToken: listRegistrationToken(hostPool.id, hostPool.apiVersion).token
      tags: {
      }
    }
    location: location
    managedIdentities: {
      systemAssigned: true
    }
  }
}
