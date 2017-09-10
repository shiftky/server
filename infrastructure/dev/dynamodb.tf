resource "aws_dynamodb_table" "alert_table" {
  name           = "Alert"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "OrgName"
  range_key      = "CreatedAt"

  local_secondary_index {
    name            = "OrgNameAlertIdIndex"
    range_key       = "AlertId"
    projection_type = "ALL"
  }

  local_secondary_index {
    name            = "OrgNameStatusIndex"
    range_key       = "Status"
    projection_type = "ALL"
  }

  local_secondary_index {
    name            = "OrgNameIsOpenIndex"
    range_key       = "IsOpen"
    projection_type = "ALL"
  }

  attribute {
    name = "OrgName"
    type = "S"
  }

  attribute {
    name = "CreatedAt"
    type = "S"
  }

  attribute {
    name = "AlertId"
    type = "S"
  }

  attribute {
    name = "Status"
    type = "S"
  }

  attribute {
    name = "IsOpen"
    type = "S"
  }

  tags {
    Name        = "Alert Table"
    Environment = "development"
  }
}
