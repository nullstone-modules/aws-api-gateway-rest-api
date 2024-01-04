data "ns_connection" "api-gateway" {
  name     = "api-gateway"
  contract = "ingress/aws/api-gateway"
}

locals {
  public_urls = [for u in data.ns_connection.api-gateway.outputs.public_urls : { url = "${u}/${var.path}" }]
  domain_name = data.ns_connection.api-gateway.outputs.domain_name
}
