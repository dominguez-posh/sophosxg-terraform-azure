// Create Virtual Network

resource "azurerm_virtual_network" "hubvnetwork" {
  name                = "vnet_hub01"
  address_space       = [var.vnetcidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_subnet" "wansubnet" {
  name                 = "snet_hub01_wan"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.hubvnetwork.name
  address_prefixes     = [var.publiccidr]
}

resource "azurerm_subnet" "lansubnet" {
  name                 = "snet_hub01_lan"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.hubvnetwork.name
  address_prefixes     = [var.privatecidr]
}


// Allocated Public IP
resource "azurerm_public_ip" "SFOSPublicIp" {
  name                = "pip_sophosxgs"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = var.sfos_dnsname


  tags = {
    environment = var.environment_tag
  }
}

//  Network Security Group
resource "azurerm_network_security_group" "wannetworknsg" {
  name                = "nsg_hub01_wan"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "TCP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_network_security_group" "lannetworknsg" {
  name                = "nsg_hub01_lan"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "All"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_network_security_rule" "outgoing_wan" {
  name                        = "egress"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  network_security_group_name = azurerm_network_security_group.wannetworknsg.name
}

resource "azurerm_network_security_rule" "outgoing_lan" {
  name                        = "egress-private"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  network_security_group_name = azurerm_network_security_group.lannetworknsg.name
}

// FGT Network Interface port1
resource "azurerm_network_interface" "sfoswanport1" {
  name                = "nic_sophosxgs_wan"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.wansubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.xgswanip
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.SFOSPublicIp.id
  }

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_network_interface" "sfoslanport1" {
  name                = "nic_sophosxgs_lan"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  #enable_ip_forwarding = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.lansubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.xgslanip

  }

  tags = {
    environment = var.environment_tag
  }
}
# Connect the security group to the network interfaces
resource "azurerm_network_interface_security_group_association" "port1nsg" {
  depends_on                = [azurerm_network_interface.sfoswanport1]
  network_interface_id      = azurerm_network_interface.sfoswanport1.id
  network_security_group_id = azurerm_network_security_group.wannetworknsg.id
}

resource "azurerm_network_interface_security_group_association" "port2nsg" {
  depends_on                = [azurerm_network_interface.sfoslanport1]
  network_interface_id      = azurerm_network_interface.sfoslanport1.id
  network_security_group_id = azurerm_network_security_group.lannetworknsg.id
}