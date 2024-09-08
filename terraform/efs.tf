# EFS File System
resource "aws_efs_file_system" "minecraft_efs" {
  creation_token = "tsar-minecraft-efs"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "tsar-minecraft-efs"
  }
}

# EFS Mount Target
resource "aws_efs_mount_target" "minecraft_efs_mount_target" {
  file_system_id  = aws_efs_file_system.minecraft_efs.id
  subnet_id       = aws_subnet.subnet.id
  security_groups = [aws_security_group.minecraft_efs_security_group.id]
}

# EFS Buckup Policy
resource "aws_efs_backup_policy" "minecraft_efs_backup_policy" {
  file_system_id = aws_efs_file_system.minecraft_efs.id
  backup_policy {
    status = "ENABLED"
  }
}
