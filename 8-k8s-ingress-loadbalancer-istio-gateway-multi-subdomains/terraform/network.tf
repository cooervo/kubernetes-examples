resource "google_compute_network" "vpc" {
  name                    = "vpc"
  auto_create_subnetworks = false

}

resource "google_compute_subnetwork" "subnet" {
  name = "subnet"

  # Check environments/{mosaic_env}/variables.tfvars for environment specific ranges
  ip_cidr_range = var.main_network_cidr
  network       = google_compute_network.vpc.id
  region        = var.region

  # Private Google Access: Allows VM instances which only have internal IP addresses
  # to reach Google APIs and services. Source: https://cloud.google.com/architecture/best-practices-vpc-design#default-gateway
  private_ip_google_access = true

}

// needed to allow VM instances without external IP to access internet
resource "google_compute_router" "router" {
  name    = "router"
  region  = var.region
  network = google_compute_network.vpc.id
}


// needed to allow VM instances without external IP to access internet
resource "google_compute_router_nat" "nat" {
  name                               = "router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_firewall" "allow_http_egress" {
  name    = "allow-http-egress"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges      = ["0.0.0.0/0"]
  destination_ranges = ["0.0.0.0/0"]
}

