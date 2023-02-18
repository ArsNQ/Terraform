resource "azurerm_network_interface" "nic_master" {
    count               = var.nb_master
    name                = "nic-k8s-master-${count.index}"
    location            = data.azurerm_resource_group.rg_main.location
    resource_group_name = data.azurerm_resource_group.rg_main.name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.public_ip_master[count.index].id
    }
}

resource "azurerm_public_ip" "public_ip_master" {
    count               = var.nb_master
    name                = "pip-k8s-master-${count.index}"
    location            = data.azurerm_resource_group.rg_main.location
    resource_group_name = data.azurerm_resource_group.rg_main.name
    allocation_method   = "Static"
    ip_version          = "IPv4"
}

resource "azurerm_linux_virtual_machine" "vm_master" {
    count               = var.nb_master
    name                = "vm-k8s-master-${count.index}"
    resource_group_name = data.azurerm_resource_group.rg_main.name
    location            = data.azurerm_resource_group.rg_main.location
    size                = var.profil_master
    admin_username      = "adminazure"
    computer_name       = "master-${count.index}"
    network_interface_ids = [
        azurerm_network_interface.nic_master[count.index].id,
    ]
    
    admin_ssh_key {
        username   = "adminazure"
        public_key = var.ssh_key_pub
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts-gen2"
        version   = "latest"
    }
}