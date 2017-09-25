data "aws_caller_identity" "current" {}

resource "aws_api_gateway_rest_api" "incident-app-team-a" {
  name = "incident-app-team-a"
}

resource "aws_iam_role_policy_attachment" "dynamodb-lambda" {
  role       = "${element(split("/",var.apex_function_role), 1)}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
