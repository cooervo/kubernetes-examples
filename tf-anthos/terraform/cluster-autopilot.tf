
# resource "google_container_cluster" "cluster_autopilot" {
  
#   name               = "cluster-autopilot-${var.environment}"
#   location           = var.region
#   project            = var.project_id
#   enable_autopilot = true

#   resource_labels             = {
#           "mesh_id" = "proj-699756517758"
#         }
  
#   lifecycle {
#     ignore_changes = [
#       # Ignore changes to min-master-version as that gets changed
#       # after deployment to minimum precise version Google has
#       min_master_version,
#     ]
#   }
# }

# module "asm-secondary" {
#   source            = "terraform-google-modules/kubernetes-engine/google//modules/asm"
#   project_id        = var.project_id
#   cluster_name      = google_container_cluster.cluster_autopilot.name
#   cluster_location  = google_container_cluster.cluster_autopilot.location
#   enable_cni        = true
#   enable_fleet_registration = true
#   enable_mesh_feature = true
# }


# resource "google_gke_hub_membership" "anthos_registration_for_cluster_autopilot" {
#   provider      = google-beta
#   project = var.project_id
#   membership_id = google_container_cluster.cluster_autopilot.name
#   endpoint {
#     gke_cluster {
#       resource_link = "//container.googleapis.com/${google_container_cluster.cluster_autopilot.id}"
#     }
#   }
# }