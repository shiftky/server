data "aws_caller_identity" "current" {}

resource "aws_api_gateway_rest_api" "incident-app-team-a" {
  name = "incident-app-team-a"
}
