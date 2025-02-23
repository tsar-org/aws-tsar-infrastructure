# EFS File System
resource "aws_efs_file_system" "minecraft_efs" {
  creation_token = "tsar-minecraft-efs"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

# EFS Mount Target
resource "aws_efs_mount_target" "minecraft_efs_mount_target" {
  file_system_id  = aws_efs_file_system.minecraft_efs.id
  subnet_id       = aws_subnet.subnet_1.id
  security_groups = [aws_security_group.minecraft_efs_security_group.id]
}

# EFS Buckup Policy
resource "aws_efs_backup_policy" "minecraft_efs_backup_policy" {
  file_system_id = aws_efs_file_system.minecraft_efs.id
  backup_policy {
    status = "ENABLED"
  }
}

resource "aws_security_group" "minecraft_efs_security_group" {
  name        = "tsar-minecraft-efs-security-group-for-ecs"
  description = "security rule for ecs"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "minecraft_efs_security_rule_in" {
  from_port         = 2049
  to_port           = 2049
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.minecraft_efs_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "minecraft_efs_security_rule_out" {
  ip_protocol       = "-1"
  security_group_id = aws_security_group.minecraft_efs_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
}
