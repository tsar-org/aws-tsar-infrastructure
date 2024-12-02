# Security group for minecraft server
resource "aws_security_group" "minecraft_security_group" {
  name        = "tsar-minecraft-security-group-for-ces"
  description = "security rule for ALB"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "tsar-minecraft-security-group-for-ces"
  }
}

# Security group rule for minecraft server ingress
resource "aws_vpc_security_group_ingress_rule" "minecraft_security_rule_in" {
  from_port         = 25565
  to_port           = 25565
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.minecraft_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
}

# Security group rule for minecraft server egress
resource "aws_vpc_security_group_egress_rule" "minecraft_security_rule_out" {
  ip_protocol       = "-1"
  security_group_id = aws_security_group.minecraft_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
}

# Security group for minecraft ecs mounting efs
resource "aws_security_group" "minecraft_efs_security_group" {
  name        = "tsar-minecraft-efs-security-group-for-ecs"
  description = "security rule for ecs"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "tsar-minecraft-efs-security-group-for-ecs"
  }
}

# Security group rule for minecraft ecs mounting efs ingress
resource "aws_vpc_security_group_ingress_rule" "minecraft_efs_security_rule_in" {
  from_port         = 2049
  to_port           = 2049
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.minecraft_efs_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
}

# Security group rule for minecrafjt ecs mounting efs egress
resource "aws_vpc_security_group_egress_rule" "minecraft_efs_security_rule_out" {
  ip_protocol       = "-1"
  security_group_id = aws_security_group.minecraft_efs_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
}
