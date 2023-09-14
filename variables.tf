variable "project_id" {
  description = "Google Cloud project ID."
  type        = string
}

variable "vpc" {
  description = "VPC name."
  type        = string
}

variable "location" {
  description = "Region where resources will be created."
  type        = string
}

variable "index_id" {
  description = "Index ID. Index with this ID will be created."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9_]+$", var.index_id))
    error_message = "Index ID must contain only lowercase letters, numbers, and underscores."
  }
}

variable "index_name" {
  description = "Index name."
  type        = string
}

variable "index_endpoint_name" {
  description = "Index endpoint name."
  type        = string
}

variable "bucket_name" {
  description = "Google Cloud Storage bucket name. Bucket with this name will be created."
  type        = string
}

variable "index_config" {
  description = "Configuration for the index."
  type = map(object({
    dimensions                   = number
    shard_size                   = string
    distance_measure_type        = string
    leaf_node_embedding_count    = number
    leaf_nodes_to_search_percent = number
  }))
  default = {
    dimensions                   = 768
    shard_size                   = "SHARD_SIZE_SMALL"
    distance_measure_type        = "DOT_PRODUCT_DISTANCE"
    leaf_node_embedding_count    = 500
    leaf_nodes_to_search_percent = 7
  }
}
