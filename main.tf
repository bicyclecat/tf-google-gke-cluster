provider "google" {
  # Configuration options
  project = var.google_project
  region  = var.google_region
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.this.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.this.cluster_ca_certificate)
}

resource "google_container_cluster" "this" {
  name     = var.gke_cluster_name
  location = var.google_region

  initial_node_count       = 1
  remove_default_node_pool = true

  workload_identity_config {
    workload_pool = "${var.google_project}.svc.id.goog"
  }
  node_config {
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    machine_type = var.machine_type
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size_gb
  }
}

resource "google_container_node_pool" "this" {
  name       = var.pool_name
  cluster    = google_container_cluster.this.id
  node_count = var.num_nodes

  node_config {
    preemptible  = true
    machine_type = var.machine_type
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size_gb
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

module "gke_auth" {
  depends_on = [
    google_container_cluster.this
  ]
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version              = ">= 24.0.0"
  project_id           = var.google_project
  cluster_name         = google_container_cluster.this.name
  location             = var.google_region
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = abspath("${path.root}/kubeconfig")
  file_permission = "0400"

}