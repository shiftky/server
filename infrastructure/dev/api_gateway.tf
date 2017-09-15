data "aws_caller_identity" "current" {}

resource "aws_api_gateway_rest_api" "incident-app-team-a" {
  name = "incident-app-team-a"
}

#
# deployment
#
resource "aws_api_gateway_deployment" "incident-app-team-a" {
  depends_on = [
    "aws_api_gateway_method.get_alerts",
    "aws_api_gateway_method.post_alerts_mackerel",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  stage_name  = "development"
}
