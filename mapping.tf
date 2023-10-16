resource "aws_apigatewayv2_api" "this" {
  name                         = local.resource_name
  protocol_type                = "HTTP"
  disable_execute_api_endpoint = true
  target                       = local.function_arn
  tags                         = local.tags
}

resource "aws_apigatewayv2_api_mapping" "this" {
  api_id          = aws_apigatewayv2_api.this.id
  domain_name     = local.domain_name
  api_mapping_key = var.path
  stage           = "$default"
}
