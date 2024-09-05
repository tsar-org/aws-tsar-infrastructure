output "secret_value" {
  value     = nonsensitive(data.sops_file.secrets.data)
  sensitive = false
}
