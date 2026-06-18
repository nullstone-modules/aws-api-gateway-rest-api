# aws-api-gateway-rest-api
Creates an API Gateway REST API and mapping so that requests to a path are routed to an application.

## Connections

### cognito-user-pool (optional)
Contract: `datastore/aws/cognito`

When a Cognito user pool is connected, the API Gateway secures all routes with a Cognito user pool authorizer
(`COGNITO_USER_POOLS`). When the connection is absent, the routes remain open (`NONE`).
