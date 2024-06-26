targetScope='subscription'

param resourceGroupName string
param adminUsername string
param vmName string
param resourceGroupLocation string = 'South Central US'

resource newRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}

module main './main.bicep' = {
  name: 'main'
  scope: newRG
  params: {
    adminUsername: adminUsername
    vmName: vmName
    location: resourceGroupLocation
  }
}
