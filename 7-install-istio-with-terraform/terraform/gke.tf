locals {
  # The service account manually created for terraform to be able to execute GCP commands
  terraform_service_account = "service-account-tf@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_container_cluster" "cluster" {
  name = "cluster"

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  enable_autopilot = true
  allow_net_admin  = true

  location = var.region
  project  = var.project_id

  deletion_protection = false
  node_config {
    service_account = local.terraform_service_account
  }

  lifecycle {
    # Add ignores otherwise terraform will mark the cluster as needing replacement/detroy when not needed or already automatically done by GKE, istio, etc.
    # official documentation: https://www.terraform.io/docs/language/meta-arguments/lifecycle.html#ignore_changes
    # more documentation:     https://fabianlee.org/2023/05/06/gke-terraform-lifecycle-ignore_changes-to-manage-external-changes-to-gke-cluster/
    ignore_changes = [
      initial_node_count,
      min_master_version, # Ignore when GKE autoupgrades to minimum version: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#min_master_version
      resource_labels,    # Ignore changes to resource labels for example autoinjected labels by Istio, Anthos Service Mesh, etc.
      dns_config,
      node_config, # needed since we want to set service account with least privileges as done above at node_config.service_account instead of default service account: https://registry.terraform.io/providers/hashicorp/google/4.84.0/docs/guides/using_gke_with_terraform 
    ]


  }
}
