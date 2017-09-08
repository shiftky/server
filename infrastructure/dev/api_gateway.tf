variable "aws_region" {
  type = "string"
}

variable "apex_function_arns" {
  type = "map"
}

resource "aws_api_gateway_rest_api" "incident-app-team-a" {
  name = "incident-app-team-a"
}

resource "aws_api_gateway_resource" "alerts" {
  rest_api_id = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  parent_id   = "${aws_api_gateway_rest_api.incident-app-team-a.root_resource_id}"
  path_part   = "alerts"
}

resource "aws_api_gateway_method" "get_alerts" {
  rest_api_id   = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  resource_id   = "${aws_api_gateway_resource.alerts.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_alerts" {
  rest_api_id             = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  resource_id             = "${aws_api_gateway_resource.alerts.id}"
  http_method             = "${aws_api_gateway_method.get_alerts.http_method}"
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${lookup(var.apex_function_arns, "get_alerts")}/invocations"
}

resource "aws_api_gateway_deployment" "incident-app-team-a" {
  depends_on  = ["aws_api_gateway_method.get_alerts"]
  rest_api_id = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  stage_name  = "development"
}
