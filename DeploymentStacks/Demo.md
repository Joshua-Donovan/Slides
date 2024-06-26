```[tasklist]
- [ ] Review Bicep File Deployment
- In VSCODE

# Deploy Virtual Machine the classic way
```bash
az group create --name RegularDeploymentsRG --location southcentralus --output none
```
```bash
az deployment group create --resource-group RegularDeploymentsRG --template-file C:/DEMO/DeploymentStacks/main.bicep --parameters "{ \"adminUsername\": { \"value\": \"azureuser\" },\"vmName\": { \"value\": \"ProdRegDep\" }  }" --output none
```

```bash
# don't use this password in real life...
MyAwesomeAndSuperSecurePassword123
```

# Show Deployed Resources / Deployment Information
 - Azure Portal

# Admin Tasked with Saving Money
### Administrator has Contributor Access to All Scopes

> "Virtual Machines have been declared expensive, the easiest path to saving money is to delete all virtual machines... except for mine of course" - Administrator

```powershell
ssh -i "C:\DEMO\DeploymentStacks\DemoAdminVM_key.pem" azureuser@40.124.173.157
```

```bash
# Check Virtual Machines
az vm list --query "[?name != \`DemoAdminVM\`].{resource:resourceGroup, name:name, ids:id}" --output table

# Delete VMs
for vmsToDelete in $(az vm list --query "[?name != \`DemoAdminVM\`].id" -o tsv); do
    echo deleting $vmsToDelete
    az vm delete --ids $vmsToDelete --force-deletion true --yes y
    echo done deleting
done
```

# Deploy Virtual Machine using Deployment Stacks

# Show Deployed Resources / Deployment Information
 - Azure Portal

# Admin Tasked with Saving Money (DENIED), then succeeds deleting the resource group

# Deploy Virtual Machine using Deployment Stacks from the Subscription scope

# Admin Tasked with Saving Money (DENIED), and also denied deleting the resource group

# Clean Up Resources using stacks
```