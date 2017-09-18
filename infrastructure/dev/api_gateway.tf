data "aws_caller_identity" "current" {}

resource "aws_api_gateway_rest_api" "incident-app-team-a" {
  name = "incident-app-team-a"
}

#
# /alerts
#
## resource
resource "aws_api_gateway_resource" "alerts" {
  rest_api_id = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  parent_id   = "${aws_api_gateway_rest_api.incident-app-team-a.root_resource_id}"
  path_part   = "alerts"
}

## method
resource "aws_api_gateway_method" "get_alerts" {
  rest_api_id   = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  resource_id   = "${aws_api_gateway_resource.alerts.id}"
  http_method   = "GET"
  authorization = "NONE"
}

## method response
resource "aws_api_gateway_method_response" "get_alerts_200" {
  rest_api_id = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  resource_id = "${aws_api_gateway_resource.alerts.id}"
  http_method = "${aws_api_gateway_method.get_alerts.http_method}"

  response_models = {
    "application/json" = "Empty"
  }

  status_code = "200"
}

## integration
resource "aws_api_gateway_integration" "get_alerts" {
  rest_api_id             = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  resource_id             = "${aws_api_gateway_resource.alerts.id}"
  http_method             = "${aws_api_gateway_method.get_alerts.http_method}"
  type                    = "AWS"
  integration_http_method = "POST"
  content_handling        = "CONVERT_TO_TEXT"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${lookup(var.apex_function_arns, "get_alerts")}/invocations"
}

## integration response
resource "aws_api_gateway_integration_response" "get_alerts_200" {
  rest_api_id = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  resource_id = "${aws_api_gateway_resource.alerts.id}"
  http_method = "${aws_api_gateway_method.get_alerts.http_method}"
  status_code = "${aws_api_gateway_method_response.get_alerts_200.status_code}"
}

#
# /alerts/mackerel
#
## resource
resource "aws_api_gateway_resource" "alerts_mackerel" {
  rest_api_id = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  parent_id   = "${aws_api_gateway_resource.alerts.id}"
  path_part   = "mackerel"
}

## method
resource "aws_api_gateway_method" "post_alerts_mackerel" {
  rest_api_id   = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  resource_id   = "${aws_api_gateway_resource.alerts_mackerel.id}"
  http_method   = "POST"
  authorization = "NONE"
}

## method response
resource "aws_api_gateway_method_response" "post_alerts_mackerel_200" {
  rest_api_id = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  resource_id = "${aws_api_gateway_resource.alerts_mackerel.id}"
  http_method = "${aws_api_gateway_method.post_alerts_mackerel.http_method}"

  response_models = {
    "application/json" = "Empty"
  }

  status_code = "200"
}

## integration
resource "aws_api_gateway_integration" "post_alerts_mackerel" {
  rest_api_id             = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  resource_id             = "${aws_api_gateway_resource.alerts_mackerel.id}"
  http_method             = "${aws_api_gateway_method.post_alerts_mackerel.http_method}"
  type                    = "AWS"
  integration_http_method = "POST"
  content_handling        = "CONVERT_TO_TEXT"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${lookup(var.apex_function_arns, "post_alerts")}/invocations"
}

## integration response
resource "aws_api_gateway_integration_response" "post_alerts_200" {
  rest_api_id = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  resource_id = "${aws_api_gateway_resource.alerts_mackerel.id}"
  http_method = "${aws_api_gateway_method.post_alerts_mackerel.http_method}"
  status_code = "${aws_api_gateway_method_response.post_alerts_mackerel_200.status_code}"
}

#
# deployment
#
resource "aws_api_gateway_deployment" "incident-app-team-a" {
  depends_on = [
    "aws_api_gateway_method.get_alerts",
    "aws_api_gateway_method.post_alerts_mackerel",
    "aws_api_gateway_method.post_users",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  stage_name  = "development"
}

#
# Lambda Permission
#
resource "aws_lambda_permission" "get_alerts_allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${lookup(var.apex_function_arns, "get_alerts")}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.incident-app-team-a.id}/*/GET/alerts"
}

resource "aws_lambda_permission" "post_alerts_allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${lookup(var.apex_function_arns, "post_alerts")}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.incident-app-team-a.id}/*/POST/alerts/mackerel"
}
