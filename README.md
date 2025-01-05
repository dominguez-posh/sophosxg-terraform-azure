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

## Deployment

To deploy the FortiGate-VM to Azure:

1. Clone the repository.
2. Customize variables `variables.tf` file as needed.
3. Initialize the providers and modules.

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

