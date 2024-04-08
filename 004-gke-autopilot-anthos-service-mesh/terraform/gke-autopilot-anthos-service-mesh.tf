data "google_project" "proj" {
  project_id = var.project_id
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-public-cluster"
  project_id                 = var.project_id
  name                       = "gke-autopilot-cluster-${var.environment}"
  region                     = var.region
  zones                      = var.zones

  network                 = google_compute_network.vpc.name
  subnetwork              = google_compute_subnetwork.subnet.name

  ip_range_pods              = ""
  ip_range_services          = ""

  horizontal_pod_autoscaling = true
  # filestore_csi_driver       = false

  # needed for Anthos Service Mesh fleet registration
  cluster_resource_labels = { "mesh_id" : "proj-${data.google_project.proj.number}" }
  
  service_account         = google_service_account.iam_sa.email

}

data "google_client_config" "gcp_access_config" {}


provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.gcp_access_config.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "anthos-service-mesh" {
  source            = "terraform-google-modules/kubernetes-engine/google//modules/asm"
  project_id                = var.project_id
  cluster_name              = module.gke.name
  cluster_location          = module.gke.location
  multicluster_mode         = "connected"
  enable_cni                = true
  enable_fleet_registration = true
  # enable_mesh_feature       = true

  depends_on = [ module.gke ]
}