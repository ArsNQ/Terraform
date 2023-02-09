provider "google" {
  version = "3.0.0"
  project = "" #GCP project name.
  region  = "" #GCP region name.
}

resource "google_compute_instance" "example" {
  name         = "" #GCP instance name.
  machine_type = "" #GCP machine type.

  boot_disk {
    initialize_params {
      image = "" #OS image
    }
  }

  network_interface {
    network = "default" #Network interface
  }
}