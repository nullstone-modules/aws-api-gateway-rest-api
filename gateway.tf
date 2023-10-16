data "ns_connection" "api-gateway" {
  name     = "api-gateway"
  contract = "block/aws/ingress:api-gateway"
}
