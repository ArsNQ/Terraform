resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-k8s"
  location            = data.azurerm_resource_group.rg_main.location
  resource_group_name = data.azurerm_resource_group.rg_main.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.rg_main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoiate" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-k8s"
  location            = data.azurerm_resource_group.rg_main.location
  resource_group_name = data.azurerm_resource_group.rg_main.name
  security_rule {
    name                       = "Allow-All"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
