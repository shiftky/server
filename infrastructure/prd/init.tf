terraform {
  backend "s3" {
    bucket = "incident-app-team-a-tfstate"
    key = "incident-app-team-a-prd.tfstate"
    region = "ap-northeast-1"
  }
}
