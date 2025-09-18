$rgName = 'rg-opc-dev-001'
$location = 'australiaeast'
# deploy AVD
.\deploy-avd.ps1 -ResourceGroupName $rgName -Location $location

$adminPassword = "AAAbbb12345!@#" | ConvertTo-SecureString -AsPlainText -Force
.\deploy-avd-vm.ps1 -ResourceGroupName $rgName -VmName $vmName -AdminPassword $adminPassword -WhatIf
