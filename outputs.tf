output "public_urls" {
  value = { for public_url in local.public_urls: url => public_url }
}

output "permissions" {
  value = [
    {
      sid_prefix = "AllowGatewayAccess"
      action     = "lambda:InvokeFunction"
      principal  = "apigateway.amazonaws.com"
      source_arn = "${aws_apigatewayv2_api.this.execution_arn}/*/${aws_apigatewayv2_api_mapping.this.stage}"
    }
  ]
}
