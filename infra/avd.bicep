param hostPoolName string
param hostPoolFriendlyName string
param workspaceName string
param workspaceFriendlyName string
param applicationGroupName string
param applicationGroupFriendlyName string


module hostPool 'br/public:avm/res/desktop-virtualization/host-pool:0.8.0' = {
  name: 'hostPoolDeployment'
  params: {
    name: hostPoolName
    friendlyName: hostPoolFriendlyName
    hostPoolType: 'Pooled'
    loadBalancerType: 'BreadthFirst'
    preferredAppGroupType: 'Desktop'
    startVMOnConnect: true
  }
}

module workspace 'br/public:avm/res/desktop-virtualization/workspace:0.9.0' = {
  name: 'workspaceDeployment'
  params: {
    name: workspaceName
    friendlyName: workspaceFriendlyName
    applicationGroupReferences: [
      applicationGroup.outputs.resourceId
    ]
  }
}

module applicationGroup 'br/public:avm/res/desktop-virtualization/application-group:0.4.0' = {
  name: 'applicationGroupDeployment'
  params: {
    // Required parameters
    applicationGroupType: 'Desktop'
    hostpoolName: hostPoolName
    name: applicationGroupName
    friendlyName: applicationGroupFriendlyName
    roleAssignments: [
      {
        principalId: '13f08f22-ffbc-43bb-99e8-a088873d29e4' // [Dev] AVD OPC Users
        roleDefinitionIdOrName: 'Desktop Virtualization User'
      }
    ]
  }
}
