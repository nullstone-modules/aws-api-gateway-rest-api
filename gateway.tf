data "ns_connection" "api-gateway" {
  name     = "api-gateway"
  contract = "ingress/aws/api-gateway"
}

locals {
  public_urls = [for u in data.ns_connection.api-gateway.outputs.public_urls : { url = u }]
  domain_name = data.ns_connection.api-gateway.outputs.domain_name
  endpoint_types = data.ns_connection.api-gateway.outputs.endpoint_types
}