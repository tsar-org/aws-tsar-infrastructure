data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "tls_certificate" "github_actions" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}
