variable "google_project" {
  type        = string
  description = "GCP project name"
}

variable "google_region" {
  type        = string
  default     = "us-central1-a"
  description = "GCP region to use"
}

variable "num_nodes" {
  type        = number
  default     = 1
  description = "GKE nodes number"
}

variable "machine_type" {
  type        = string
  default     = "e2-micro"
  description = "GKE Machine type"
}

variable "disk_type" {
  type        = string
  default     = "pd-standard"
  description = "GKE Machine disk type"
}

variable "disk_size_gb" {
  type        = string
  default     = 10
  description = "GKE Machine disk size in GB"
}

variable "gke_cluster_name" {
  type        = string
  default     = "main"
  description = "GKE cluster name"
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Deletion protection. False value allows Terraform to destroy the cluster"
}

variable "pool_name" {
  type        = string
  default     = "main"
  description = "GKE pool name"
}
