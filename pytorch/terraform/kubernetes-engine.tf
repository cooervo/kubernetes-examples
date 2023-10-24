variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

# GKE cluster
data "google_container_engine_versions" "gke_version" {
  location       = var.region
  version_prefix = "1.27."
}


resource "google_container_cluster" "cluster" {
  name     = "gke-${var.environment}"
  location = var.region
  enable_autopilot = true
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# # Separately Managed Node Pool
# resource "google_container_node_pool" "nodes" {
#   name     = google_container_cluster.cluster.name
#   location = var.region
#   cluster  = google_container_cluster.cluster.name
  
#   version    = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
#   node_count = var.gke_num_nodes

#   node_config {
#     disk_size_gb = 80

#     oauth_scopes = [
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#       "https://www.googleapis.com/auth/trace.append",
#       "https://www.googleapis.com/auth/service.management.readonly",
#       "https://www.googleapis.com/auth/devstorage.read_only",
#       "https://www.googleapis.com/auth/servicecontrol",
#     ]

#     labels = {
#       env = var.project_id
#     }

#     # preemptible  = true
#     machine_type = "n1-standard-1"
#     tags         = ["gke-node", "gke-${var.environment}"]
#     metadata = {
#       disable-legacy-endpoints = "true"
#     }
#   }
# }