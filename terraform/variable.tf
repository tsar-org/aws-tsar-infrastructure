data "sops_file" "secrets" {
  source_file = "../secret.enc.yaml"
  input_type  = "yaml"
}

# variable "aws_region" {
#   type        = string
#   default     = "ap-northeast-1" // Tokyo
#   description = "AWS region"
# }
