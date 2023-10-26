resource "aws_api_gateway_rest_api" "this" {
  name = "${local.resource_name}-api"

  endpoint_configuration {
    types = ["EDGE"]
  }
  put_rest_api_mode = contains(var.endpoint_types, "PRIVATE") ? "merge" : "overwrite"

  tags = local.tags
}

resource "aws_api_gateway_method" "root-any" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_rest_api.this.root_resource_id
  authorization = "NONE"
  http_method = "ANY"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy-any" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.proxy.id
  authorization = "NONE"
  http_method   = "ANY"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_rest_api.this.root_resource_id
  http_method             = aws_api_gateway_method.root-any.http_method
  integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = local.function_arn
}

resource "aws_apigatewayv2_api_mapping" "this" {
  api_id          = aws_api_gateway_rest_api.this.id
  domain_name     = local.domain_name
  api_mapping_key = var.path
  stage           = "$default"
}
