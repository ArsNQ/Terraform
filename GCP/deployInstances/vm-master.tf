resource "google_compute_instance" "vm_instance_master" {
  count        = var.count-master
  name         = "kubernetes-master-0${count.index}"
  machine_type = var.machine-type
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = var.debian-10
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
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

