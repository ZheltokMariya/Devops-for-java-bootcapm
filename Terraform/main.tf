terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.27"
    }
  }
}

provider "google" {
  project     = "airy-cycle-453512-b4"
  region      = "europe-central2"
  credentials = "./keys.json"
}

resource "google_compute_network" "network" {
  name                    = "network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "subnetwork"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.network.self_link
  region        = "europe-central2"
}

resource "google_compute_firewall" "icmp" {
  name      = "icmp"
  network   = google_compute_network.network.self_link
  direction = "INGRESS"
  priority  = "65534"
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "http" {
  name      = "http"
  network   = google_compute_network.network.self_link
  direction = "INGRESS"
  priority  = "1000"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "egress" {
  name      = "egress"
  network   = google_compute_network.network.self_link
  direction = "EGRESS"
  priority  = "1000"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "https" {
  name      = "https"
  network   = google_compute_network.network.self_link
  direction = "INGRESS"
  priority  = "1000"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "ssh" {
  name      = "ssh"
  network   = google_compute_network.network.self_link
  direction = "INGRESS"
  priority  = "1000"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "ubuntu" {
  name         = "ubuntu"
  machine_type = "e2-micro"
  zone         = "europe-central2-b"

  tags = ["ubuntu", "http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  metadata_startup_script = file("startup_script.sh")

  network_interface {
    network    = google_compute_network.network.self_link
    subnetwork = google_compute_subnetwork.subnetwork.self_link
    access_config {

    }
  }
}

resource "google_compute_instance" "debian" {
  name         = "debian"
  machine_type = "e2-micro"
  zone         = "europe-central2-b"

  tags = ["debian"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = google_compute_network.network.self_link
    subnetwork = google_compute_subnetwork.subnetwork.self_link
  }
}