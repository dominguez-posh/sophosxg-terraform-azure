# Deploying Sophos XGS Appliance (payg and byol) with terraform in Azure

## Requirements
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 0.12.0
* Terraform Provider AzureRM >= 2.38.0
* Terraform Provider Template >= 2.2.2
* Terraform Provider Random >= 3.0.0

## Overview

Terraform deploys the following components:

* Azure Virtual Network with 2 subnets
* One Sophos-XGS-VM instance with 2 NICs (LAN and WAN)
* The default network can be later used as a hub network in your environment the Addresses can be edited in the `variables.tf`


## Deployment

To deploy the FortiGate-VM to Azure:

1. Clone the repository.
2. Customize variables `variables.tf` file as needed.
      * default is a "byol" licensing. Change it, as you want
      * Change the Name of the dns-name
4. Initialize the providers and modules.

   ```sh
   cd XXXXX
   terraform init
    ```
   
5. Submit the Terraform plan:

   ```sh
   terraform plan
   ```

6. Verify output.
7. Confirm and apply the plan:

   ```sh
   terraform apply
   ```

8. If output is satisfactory, type `yes`.

Output will include the information necessary to log in to the FortiGate-VM instances.
To Show the admin Password type:

   ```sh
   terraform output -raw Password
   ```



## Destroy the instance

To destroy the instance, use the command:

```sh
terraform destroy
```

##Results
Terraform Output:
![image](https://github.com/user-attachments/assets/1dd796d1-bf96-4900-90fd-9f42ce3e733a)

Azure Resources:
![image](https://github.com/user-attachments/assets/0e5c7868-71e8-4dfe-a1f0-895a7ed0284a)



