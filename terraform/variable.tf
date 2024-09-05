data "sops_file" "secrets" {
  source_file = "../secret.enc.yaml"
  input_type  = "yaml"
}
