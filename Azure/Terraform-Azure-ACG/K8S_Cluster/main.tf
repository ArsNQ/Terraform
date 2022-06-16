terraform {

    required_version = ">=0.12"

    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "~>2.0"
      }
    }
  }

  provider "azurerm" {
    skip_provider_registration = "true"
    features {}
  }

  resource "azurerm_resource_group" "rg" {
    name     = "1-eb95c5b4-playground-sandbox"
    location = "eastus"
  }

  resource "azurerm_virtual_network" "rg" {
    name                = "K8SCluster_VNet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
  }

  resource "azurerm_subnet" "rg" {
    name                 = "K8SCluster_Subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.rg.name
    address_prefixes     = ["10.0.2.0/24"]
  }

# Deploy Public IP
  resource "azurerm_public_ip" "rg" {
    count               = 3
    name                = "Public_NIC_${count.index}"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method   = "Static"
    sku                 = "Basic"
  }

# Deploy NIC
  resource "azurerm_network_interface" "rg" {
    count               = 3
    name                = "K8SCluster_NIC_${count.index}"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
      name                          = "K8SCluster_IPConfiguration"
      subnet_id                     = azurerm_subnet.rg.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = element(azurerm_public_ip.rg.*.id, count.index)
    }
  }

  resource "azurerm_managed_disk" "rg" {
    count                = 3
    name                 = "K8SCluster_Managed_DataDisk_${count.index}"
    location             = azurerm_resource_group.rg.location
    resource_group_name  = azurerm_resource_group.rg.name
    storage_account_type = "Standard_LRS"
    create_option        = "Empty"
    disk_size_gb         = "1023"
  }

  resource "azurerm_availability_set" "avset" {
    name                         = "K8SCluster_AvaibilitySet"
    location                     = azurerm_resource_group.rg.location
    resource_group_name          = azurerm_resource_group.rg.name
    platform_fault_domain_count  = 2
    platform_update_domain_count = 2
    managed                      = true
  }

  resource "azurerm_virtual_machine" "rg" {
    count                 = 3
    name                  = "K8SCluster_VirtualMachine_${count.index}"
    location              = azurerm_resource_group.rg.location
    availability_set_id   = azurerm_availability_set.avset.id
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids = [element(azurerm_network_interface.rg.*.id, count.index)]
    vm_size               = "B2s"

    storage_image_reference {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18_04-LTS-gen2"
      version   = "latest"
    }

    storage_os_disk {
      name              = "K8SCluster_OS_DataDisk_${count.index}"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }

    # Optional data disks
    storage_data_disk {
      name              = "K8SCluster_Storage_DataDisk_${count.index}"
      managed_disk_type = "Standard_LRS"
      create_option     = "Empty"
      lun               = 0
      disk_size_gb      = "1023"
    }

    storage_data_disk {
      name            = element(azurerm_managed_disk.rg.*.name, count.index)
      managed_disk_id = element(azurerm_managed_disk.rg.*.id, count.index)
      create_option   = "Attach"
      lun             = 1
      disk_size_gb    = element(azurerm_managed_disk.rg.*.disk_size_gb, count.index)
    }

    os_profile {
      computer_name  = "K8SCluster"
      admin_username = "admcloud"
      admin_password = "FbQcV8n7oSlPIv9CTFQE"
    }

    os_profile_linux_config {
      disable_password_authentication = false
    }

    tags = {
      environment = "K8s"
    }
  }
