provider "google" {
  version = "4.52.0"
  project = "" #GCP project name.
  region  = "" #GCP region name.
}

resource "google_compute_instance" "default" {
  name         = "" #GCP instance name.
  machine_type = "" #GCP machine type.
  zone         = "" #GCP zone type.

  boot_disk {
    initialize_params {
      image = "" #OS image
    }
  }

  network_interface {
    network = "default" #Network interface
  }
}