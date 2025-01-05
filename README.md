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
