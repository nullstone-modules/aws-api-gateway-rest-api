variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

variable "path" {
  type        = string
  description = <<EOF
The path to route to this application. Any requests to the API Gateway beginning with this path will be routed to this application.
EOF
}
