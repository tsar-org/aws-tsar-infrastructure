# minecraft cloudwatch
resource "aws_cloudwatch_log_group" "minecraft_log_group" {
  name              = "/tsar/ecs/minecraft"
  retention_in_days = 30
}
