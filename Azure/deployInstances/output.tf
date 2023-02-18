output "public_ip_master" {
    value = ["${azurerm_public_ip.public_ip_master.*.ip_address}"]
}
output "public_ip_worker" {
    value = ["${azurerm_public_ip.public_ip_worker.*.ip_address}"]
}