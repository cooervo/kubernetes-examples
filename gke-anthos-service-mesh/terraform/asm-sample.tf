data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

data "google_project" "project" {
  project_id = var.project_id
}

module "gke" {
  source            = "terraform-google-modules/kubernetes-engine/google//"
  project_id              = var.project_id
  name                    = "test-prefix-cluster"
  regional                = false
  region                  = var.region
  zones                   = var.zones
  release_channel         = "REGULAR"
  network                 = "default"
  subnetwork              = "default"
  ip_range_pods           = ""
  ip_range_services       = ""
  network_policy          = false
  cluster_resource_labels = { "mesh_id" : "proj-${data.google_project.project.number}" }
  identity_namespace      = "${var.project_id}.svc.id.goog"
  deletion_protection     = false
  node_pools = [
    {
        service_account = google_service_account.iam_sa.email
      name         = "asm-node-pool"
      autoscaling  = false
      auto_upgrade = true
      node_count   = 2
      machine_type = "e2-standard-4"
    },
  ]
}

module "asm" {
  source            = "terraform-google-modules/kubernetes-engine/google//modules/asm"
  project_id                = var.project_id
  cluster_name              = module.gke.name
  cluster_location          = module.gke.location
  multicluster_mode         = "connected"
  enable_cni                = true
  enable_fleet_registration = true
  enable_mesh_feature       = true
}