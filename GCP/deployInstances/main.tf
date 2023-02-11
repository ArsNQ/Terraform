provider "google" {
  version = "4.52.0"
  project = var.project-name
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "vm_instance" {
  count        = var.counts
  name         = "terraform-instance-0${count.index}"
  machine_type = var.machine-type
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = var.rhel-9
    }
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }

  network_interface {
    network = google_compute_network.network.self_link
    subnetwork = google_compute_subnetwork.subnet_network.self_link
    access_config {
      // Ephemeral public IP
    }
  }
  tags = [var.firewall-target-tag]
}