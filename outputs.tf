output "vector_search_index" {
  value = {
    id   = google_vertex_ai_index.index.id
    name = google_vertex_ai_index.index.name
  }
  description = "Vector Search Index"
}

output "vector_search_index_endpoint" {
  value = {
    id   = google_vertex_ai_index_endpoint.index_endpoint.id
    name = google_vertex_ai_index_endpoint.index_endpoint.name
  }
  description = "Vector Search Index endpoint"
}
