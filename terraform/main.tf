terraform {
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.0" }
  }
}

variable "project_id" { type = string }
variable "region" {
  type    = string
  default = "europe-west3"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpc" {
  name                    = "shop-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "shop-subnet"
  network       = google_compute_network.vpc.id
  region        = var.region
  ip_cidr_range = "10.10.0.0/20"
}

# Autopilot keeps the cluster small and cheap; HTTP load balancing comes via Ingress
resource "google_container_cluster" "gke" {
  name             = "shop-cluster"
  location         = var.region
  network          = google_compute_network.vpc.id
  subnetwork       = google_compute_subnetwork.subnet.id
  enable_autopilot = true
}

resource "google_artifact_registry_repository" "images" {
  repository_id = "shop"
  location      = var.region
  format        = "DOCKER"
}

output "cluster_name" { value = google_container_cluster.gke.name }
