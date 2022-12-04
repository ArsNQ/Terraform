provider "google" {
  version = "4.44.1"
  project = "<project-name>"
  region  = "<region>"
  zone    = "<zone>"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_instance" "vm_instance" {
  count = 4
  name         = "terraform-instance-0${count.index}"
  machine_type = "f1-micro"
  zone         = "<zone>"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}
