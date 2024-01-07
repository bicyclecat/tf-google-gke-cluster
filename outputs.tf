# ${path.module} is an interpolated string in Terraform, which references the path to the current
# module. In this case, it returns the path to the directory containing the current module.

output "cluster_data" {
  value       = {
    # kubeconfig = "${path.module}/kubeconfig"
    kubeconfig    = abspath("${path.root}/kubeconfig")
    kubeconfig_id = local_file.kubeconfig.id
    node_pool_id  = google_container_node_pool.this.id
    cluster_id    = google_container_cluster.this.id
    cluster_name  = var.gke_cluster_name
  }
  description = "The path to the kubeconfig file"
}