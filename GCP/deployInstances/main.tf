provider "google" {
  version = "4.44.1"
  project = var.project-name
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network-001"
}

resource "google_compute_instance" "vm_instance" {
  count        = var.counts
  name         = "terraform-instance-0${count.index}"
  machine_type = var.machine-type
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = var.debian-10
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}
