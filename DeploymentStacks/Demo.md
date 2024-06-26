# Deployment Stacks Example / Demo Experience
## Review Bicep File Deployments
- DeploymentStacks\main.bicep
- DeploymentStacks\main-subscription.bicep

## Deploy Virtual Machine the classic way
```bash
az group create \
--name RegularDeploymentsRG \
--location southcentralus \
--output none
```
```bash
az deployment group create \
--resource-group RegularDeploymentsRG \
--template-file ./DeploymentStacks/main.bicep \
--parameters "{ \"adminUsername\": { \"value\": \"azureuser\" },\"vmName\": { \"value\": \"ProdRegDep\" }  }" \
--output none
```

## Show Deployed Resources / Deployment Information
 - Azure Portal

## Admin Tasked with Saving Money
### Administrator has Contributor Access to All Scopes

> "Virtual Machines have been declared expensive, the easiest path to saving money is to delete all virtual machines... except for mine of course" - Administrator

```bash
# Check Virtual Machines
az vm list --query "[?name != \`DemoAdminVM\`].{resource:resourceGroup, name:name}" --output table

# Delete VMs
for vmsToDelete in $(az vm list --query "[?name != \`DemoAdminVM\`].id" -o tsv); do
    echo deleting $vmsToDelete
    az vm delete --ids $vmsToDelete --force-deletion true --yes
    echo done deleting
done
```

## Deploy Virtual Machine using Deployment Stacks
```bash
az group create \
--name StackDeploymentRG \
--location southcentralus \
--output none
```

- Notice: --deny-settings-mode
- Notice: --name is required (and is how we will reference the stack in the future)
```bash
az stack group create \
    --name "RGStackDep" \
    --resource-group StackDeploymentRG \
    --template-file \
    ./DeploymentStacks/main.bicep \
    --parameters "{ \"adminUsername\": { \"value\": \"azureuser\" },\"vmName\": { \"value\": \"ProdStackDep\" }  }" \
    --deny-settings-mode 'denyWriteAndDelete' \
    --output none
```

## Show Deployed Resources / Deployment Information
 - Azure Portal (looks the same)
 - Get the stack
 ```bash
 az stack group show --name RGStackDep --resource-group StackDeploymentRG --output table
 ```


## Admin Tasked with Saving Money (DENIED), then succeeds deleting the resource group
```bash
# Check Virtual Machines
az vm list --query "[?name != \`DemoAdminVM\`].{resource:resourceGroup, name:name}" --output table

# Delete VMs
for vmsToDelete in $(az vm list --query "[?name != \`DemoAdminVM\`].id" -o tsv); do
    echo deleting $vmsToDelete
    az vm delete --ids $vmsToDelete --force-deletion true --yes
    echo done deleting
done

# [Angerly] Deletes Resource Group instead 
az group delete --name StackDeploymentRG --force-deletion-types Microsoft.Compute/virtualMachines --yes
```

## Deploy Virtual Machine using Deployment Stacks from the Subscription scope
- Notice: --deny-settings-mode
- Notice: --deny-settings-apply-to-child-scopes
- Notice: --deny-settings-excluded-actions
- Notice: Just like with normal subscription level deployments, we will need to specify the --location. 

```bash
az stack sub create \
    --name "SubStackDep" \
    --location 'South Central US' \
    --template-file ./DeploymentStacks/main-subscription.bicep \
    --parameters "{ \"adminUsername\": { \"value\": \"azureuser\" },\"vmName\": { \"value\": \"ProdStackDep\" },\"resourceGroupName\": { \"value\": \"StackDeploymentSub\" } }"\
    --deny-settings-mode 'denyWriteAndDelete' \
    --deny-settings-apply-to-child-scopes \
    --deny-settings-excluded-actions Microsoft.Resources/tags/* \
    --output none
```

## Admin Tasked with Saving Money (DENIED)
```bash
# Check Virtual Machines
az vm list --query "[?name != \`DemoAdminVM\`].{resource:resourceGroup, name:name}" --output table

# Delete VMs
for vmsToDelete in $(az vm list --query "[?name != \`DemoAdminVM\`].id" -o tsv); do
    echo deleting $vmsToDelete
    az vm delete --ids $vmsToDelete --force-deletion true --yes
    echo done deleting
done

# [Angerly] tries deleting Resource Group instead 
az group delete --name StackDeploymentSub --force-deletion-types Microsoft.Compute/virtualMachines --yes

# [Very upset] the admin then simply updates the tags on this resource
for vmsToDelete in $(az vm list --query "[?name != \`DemoAdminVM\`].id" -o tsv); do
    echo UpdatingTags $vmsToDelete
    az tag create --resource-id $vmsToDelete --tags AdminNote="WHY CAN'T I DELETE THIS?" -o none
    echo done UpdatingTags
done
```

## Clean Up Resources using stacks
- Delete the stack
- To Authorize others to have ownership of the stack use the "--deny-settings-excluded-principals" parameter and pass the relevant principals during the az stack * create command. 
```bash
az stack sub delete --name SubStackDep --delete-all true --yes
```
