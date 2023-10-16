data "ns_connection" "api-gateway" {
  name     = "api-gateway"
  contract = "block/aws/ingress:api-gateway"
}

locals {
  public_urls = data.ns_connection.api-gateway.outputs.public_urls
  domain_name = data.ns_connection.api-gateway.outputs.domain_name
}