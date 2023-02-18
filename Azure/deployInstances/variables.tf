variable "rg_name" {
}

variable "ssh_key_pub" {
    sensitive   = true
}

variable "nb_master"{
    default = 0
}

variable "profil_master" {
    default = "Standard_D2s_v3"
}

variable "nb_worker"{
    default = 0
}

variable "profil_worker" {
    default = "Standard_D2s_v3"
}
