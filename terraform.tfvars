project_id          = "gcp-prj-id"
vpc                 = "default"
location            = "us-central1"
index_id            = "must_be_underscored"
index_name          = "test-idx"
index_endpoint_name = "sample-endpoint"
bucket_name         = "gagata-me-test"

index_config = {
  dimensions                   = 768
  shard_size                   = "SHARD_SIZE_SMALL"
  distance_measure_type        = "DOT_PRODUCT_DISTANCE"
  leaf_node_embedding_count    = 500
  leaf_nodes_to_search_percent = 7
}
