resource "aws_api_gateway_rest_api" "this" {
  name = "${local.resource_name}-api"

  endpoint_configuration {
    types = ["EDGE"]
  }
  put_rest_api_mode = contains(local.endpoint_types, "PRIVATE") ? "merge" : "overwrite"

  tags = local.tags
}

resource "aws_api_gateway_method" "root-any" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_rest_api.this.root_resource_id
  authorization = "NONE"
  http_method   = "ANY"
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

resource "aws_api_gateway_integration" "root-integration" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_rest_api.this.root_resource_id
  http_method             = aws_api_gateway_method.root-any.http_method
  integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = local.invoke_arn
}

resource "aws_api_gateway_integration" "proxy-integration" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy-any.http_method
  integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = local.invoke_arn
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.root-any.id,
      aws_api_gateway_resource.proxy.id,
      aws_api_gateway_method.proxy-any.id,
      aws_api_gateway_integration.root-integration.id,
      aws_api_gateway_integration.proxy-integration.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "default" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "default"
}

resource "aws_apigatewayv2_api_mapping" "this" {
  api_id          = aws_api_gateway_rest_api.this.id
  domain_name     = local.domain_name
  api_mapping_key = var.path
  stage           = aws_api_gateway_stage.default.stage_name
}
