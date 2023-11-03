# Primary Cluster
module "primary-cluster" { # TODO use autopilot
  name                    = "primary"
  project_id              = module.project-services.project_id
  source                  = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  version                 = "18.0.0"
  regional                = false
  region                  = var.primary_region
  network                 = "default" # TODO use non default
  subnetwork              = "default" # TODO use non default
  ip_range_pods           = ""
  ip_range_services       = ""
  identity_namespace      = "enabled"
  zones                   = var.primary_zones
  release_channel         = "REGULAR"
  cluster_resource_labels = { "mesh_id" : "proj-${data.google_project.project.number}" }
  node_pools = [
    {
      name         = "default-node-pool"
      autoscaling  = false
      auto_upgrade = true
      node_count   = 3
      machine_type = "e2-standard-4"
    },
  ]

}

# Secondary Cluster 
module "secondary-cluster" { # TODO use autopilot
  name                    = "secondary"
  project_id              = module.project-services.project_id
  source                  = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  version                 = "18.0.0"
  regional                = false
  region                  = var.secondary_region
  network                 = "default" # TODO use non default
  subnetwork              = "default" # TODO use non default
  ip_range_pods           = ""
  ip_range_services       = ""
  zones                   = var.secondary_zones
  release_channel         = "REGULAR"
  cluster_resource_labels = { "mesh_id" : "proj-${data.google_project.project.number}" }

  node_pools = [
    {
      name         = "default-node-pool"
      autoscaling  = false
      auto_upgrade = true

      node_count   = 3
      machine_type = "e2-standard-4"
    },
  ]

}