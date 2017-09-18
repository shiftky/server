#
# /users
#
## resource
resource "aws_api_gateway_resource" "users" {
  rest_api_id = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  parent_id   = "${aws_api_gateway_rest_api.incident-app-team-a.root_resource_id}"
  path_part   = "users"
}

## method
resource "aws_api_gateway_method" "post_users" {
  rest_api_id   = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  resource_id   = "${aws_api_gateway_resource.users.id}"
  http_method   = "POST"
  authorization = "NONE"
}

## method response
resource "aws_api_gateway_method_response" "post_users_200" {
  rest_api_id = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  resource_id = "${aws_api_gateway_resource.users.id}"
  http_method = "${aws_api_gateway_method.post_users.http_method}"

  response_models = {
    "application/json" = "Empty"
  }

  status_code = "200"
}

## integration
resource "aws_api_gateway_integration" "post_users" {
  rest_api_id             = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  resource_id             = "${aws_api_gateway_resource.users.id}"
  http_method             = "${aws_api_gateway_method.post_users.http_method}"
  type                    = "AWS"
  integration_http_method = "POST"
  content_handling        = "CONVERT_TO_TEXT"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${lookup(var.apex_function_arns, "post_users")}/invocations"
}

## integration response
resource "aws_api_gateway_integration_response" "post_users_200" {
  rest_api_id = "${aws_api_gateway_rest_api.incident-app-team-a.id}"
  resource_id = "${aws_api_gateway_resource.users.id}"
  http_method = "${aws_api_gateway_method.post_users.http_method}"
  status_code = "${aws_api_gateway_method_response.post_users_200.status_code}"
}

#
# Lambda Permission
#
resource "aws_lambda_permission" "post_users_allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${lookup(var.apex_function_arns, "post_users")}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.incident-app-team-a.id}/*/POST/users"
}
