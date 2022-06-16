# Terraform_K8S_Cluster
List of commands to execute correctly this script on ACloudGuru:

 - **az login**

You need to enter the command bellow, to find appropriates information for the following steps.

 - az group show --name **#ResourceGroupName** **/or/** az group list
 
Create the "main.tf" file with the configuration in the GitHub Repo. When you dit it, you need to replace information inside of it like the ResourceGroupName at line 19. 
Then you need to enter the command bellow :

 - **terraform init**

Then :

 - terraform import azurerm_resource_group.rg
   /subscriptions/**#subscriptionID**/resourceGroups/
   **#ResourceGroupName**

And after that you can run : 

 - **terraform plan** 
 - **terraform apply --auto-approve**

To know the IP of the VM you can run the following command :
 - **az network public-ip list | grep ipAddress**
