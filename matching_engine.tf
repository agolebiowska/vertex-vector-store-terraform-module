data "google_compute_network" "vertex_network" {
  project = var.project_id
  name    = var.vpc
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_storage_bucket" "bucket" {
  project                     = var.project_id
  name                        = var.bucket_name
  location                    = var.location
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "data" {
  name    = "indexes/init.json"
  bucket  = google_storage_bucket.bucket.name
  content = <<EOF
{"id": "0", "embedding": [${join(", ", [for _ in range(var.index_config.dimensions) : 0.0])}]}
EOF
}

resource "google_vertex_ai_index" "index" {
  project      = var.project_id
  region       = var.location
  display_name = var.index_name
  description  = "Vertex AI Vector Store Index"
  metadata {
    contents_delta_uri = "gs://${google_storage_bucket.bucket.name}/indexes"
    config {
      dimensions                  = var.index_config.dimensions
      approximate_neighbors_count = var.index_config.approximate_neighbors_count
      shard_size                  = var.index_config.shard_size
      distance_measure_type       = var.index_config.distance_measure_type
      algorithm_config {
        tree_ah_config {
          leaf_node_embedding_count    = var.index_config.leaf_node_embedding_count
          leaf_nodes_to_search_percent = var.index_config.leaf_nodes_to_search_percent
        }
      }
    }
  }
  index_update_method = "BATCH_UPDATE"
}

resource "google_vertex_ai_index_endpoint" "index_endpoint" {
  project      = var.project_id
  display_name = var.index_endpoint_name
  description  = "Vertex AI Vector Store Index Endpoint"
  region       = var.location
  network      = "projects/${data.google_project.project.number}/global/networks/${data.google_compute_network.vertex_network.name}"
  depends_on = [
    google_service_networking_connection.vertex_vpc_connection
  ]
}

resource "google_service_networking_connection" "vertex_vpc_connection" {
  network                 = data.google_compute_network.vertex_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.vertex_range.name]
}

resource "google_compute_global_address" "vertex_range" {
  project       = var.project_id
  name          = "peering-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20 // 24 can get exhausted
  network       = data.google_compute_network.vertex_network.id
}
