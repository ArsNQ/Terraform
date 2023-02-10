variable "region" {
  type = string
  default = "us-central1"
}

variable "zone" {
  type = string
  default = "us-central1-a"
}

variable "project-name" {
  type = string
  default = ""
}

variable "counts" {
  type = string
  default = "3"
}

variable "machine-type" {
  type = string
  default = "e2-small"
}

variable "image" {
  # debian-cloud/debian-9
  # debian-cloud/debian-10
  # debian-cloud/debian-11
  # ubuntu-os-cloud/family/ubuntu-2204-lts
  # windows-cloud/windows-server-2019
  type = string
  default = "debian-cloud/debian-10"
}