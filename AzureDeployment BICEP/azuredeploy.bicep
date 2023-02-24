param appServiceBaseName string
param appServiceBaseSkuName string
param webAppName string
param webAppInsightsName string
param environmentName string
param location string = resourceGroup().location

resource appServiceBase 'Microsoft.Web/serverfarms@2015-08-01' = {
  name: appServiceBaseName
  location: location
  sku: {
    name: appServiceBaseSkuName
  }
  tags: {
    displayName: 'appServiceBase'
  }
  dependsOn: []
}

resource webApp 'Microsoft.Web/sites@2015-08-01' = {
  name: webAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServiceBase.id
    siteConfig: {
      netFrameworkVersion: 'v6.0'
      httpsOnly: true
      //ftpsState: 'FtpsOnly'
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: environmentName
        }
        //{
        //  name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
        //  value: '~2'
        //}
      ]
    }
  }
}

resource webAppInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: webAppInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type:'web'
    Flow_Type: 'Redfield'
  }
}
