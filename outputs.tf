output "public_urls" {
  value = local.public_urls
}

output "permissions" {
  value = [
    {
      sid_prefix = "AllowGatewayAccess"
      action     = "lambda:InvokeFunction"
      principal  = "apigateway.amazonaws.com"
      source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*"
    }
  ]
}
