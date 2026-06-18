data "ns_connection" "cognito-user-pool" {
  name     = "cognito-user-pool"
  contract = "datastore/aws/cognito"
  optional = true
}

locals {
  cognito_user_pool_id  = try(data.ns_connection.cognito-user-pool.outputs.user_pool_id, "")
  enable_cognito        = local.cognito_user_pool_id != ""
  cognito_user_pool_arn = "arn:${local.partition}:cognito-idp:${local.region}:${local.account_id}:userpool/${local.cognito_user_pool_id}"

  // When a cognito user pool is connected, secure all methods with a cognito authorizer.
  authorization = local.enable_cognito ? "COGNITO_USER_POOLS" : "NONE"
  authorizer_id = local.enable_cognito ? aws_api_gateway_authorizer.cognito[0].id : null
}

resource "aws_api_gateway_authorizer" "cognito" {
  count = local.enable_cognito ? 1 : 0

  name          = "${local.resource_name}-cognito"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.this.id
  provider_arns = [local.cognito_user_pool_arn]
}
