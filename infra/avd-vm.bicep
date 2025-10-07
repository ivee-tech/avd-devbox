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

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2024-04-03' existing = {
  name: hostPoolName
}

var registrationToken = first(hostPool.listRegistrationTokens().value).token

module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.20.0' = {
  name: 'virtualMachineDeployment'
  params: {
    // Required parameters
    // autoShutdownConfig.dailyRecurrenceTime expects a string (HHmm); previously set as an int causing a type error
    autoShutdownConfig: {
      dailyRecurrenceTime: '1900'
    }
    adminUsername: adminUsername
    availabilityZone: -1
    imageReference: {
      publisher: 'microsoftwindowsdesktop'
      offer: 'windows-11'
      sku: 'win11-24h2-avd'
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
        storageAccountType: 'Standard_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_D4ads_v5'
    // Non-required parameters
    adminPassword: adminPassword
    extensionAadJoinConfig: {
      enabled: false // temporarily disabled due to mdmId issues in personal env, deploy extension manually
      settings: {
        mdmId: intuneMdmId
      }
      tags: {}
    }
    extensionHostPoolRegistration: {
      configurationFunction: 'Configuration.ps1\\AddSessionHost'
      enabled: true
      hostPoolName: hostPoolName
      modulesUrl: modulesUrl
      registrationInfoToken: registrationToken
      // registrationInfoToken: hostPool.properties.registrationInfo.token
      tags: {}
    }
    location: location
    managedIdentities: {
      systemAssigned: true
    }
    vTpmEnabled: true
    secureBootEnabled: true
    securityType: 'TrustedLaunch'
  }
}
