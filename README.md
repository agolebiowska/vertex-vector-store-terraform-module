# Vertex AI Vector Store Terraform module

## Prerequisites
- VPC
- `servicenetworking.googleapis.com` enabled

## What it does
- Creates a GCS bucket with the initial embedding
- Creates Vector Store Index
- Creates Vector Store Index **private** Endpoint 
- Configures VPC peering with Vertex AI service
