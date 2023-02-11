resource "google_compute_network" "network" {
  name                    = var.network-name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_network" {
  name          = var.subnetwork-name
  region        = var.region
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.network.name
}

resource "google_compute_firewall" "firewall" {
  name    = var.firewall-name
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.firewall-target-tag]
}