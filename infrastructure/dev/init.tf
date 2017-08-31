terraform {
  backend "s3" {
    bucket = "incident-app-team-a-tfstate"
    key = "incident-app-team-a-dev.tfstate"
    region = "ap-northeast-1"
  }
}
