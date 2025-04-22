# ECS Task Definition
resource "aws_ecs_task_definition" "minecraft_task" {
  family             = "minecraft-ecs-task"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "minecraft"
    image     = "itzg/minecraft-server"
    essential = true
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group         = "/tsar/ecs/minecraft",
        awslogs-region        = data.aws_region.current.name,
        awslogs-stream-prefix = "minecraft"
      }
    },
    portMappings = [
      {
        protocol      = "tcp"
        containerPort = 25565
        hostPort      = 25565
      }
    ]
    environment = [
      {
        name  = "EULA"
        value = "TRUE"
      },
      {
        name  = "VERSION"
        value = "LATEST"
      },
      # https://docker-minecraft-server.readthedocs.io/en/latest/configuration/jvm-options/#memory-limit
      {
        name : "MEMORY"
        value : ""
      },
      {
        name : "JVM_XX_OPTS"
        value : "-XX:MaxRAMPercentage=90"
      }
    ],
    mountPoints = [
      {
        sourceVolume  = "minecraft-world-data-efs"
        containerPath = "/data"
      }
    ],
    healthCheck = {
      command     = ["CMD-SHELL", "mc-health"],
      interval    = 30,
      timeout     = 5,
      retries     = 3,
      startPeriod = 60
    },
    restartPolicy = {
      enabled          = true,
      ignoredExitCodes = [0],
    }
  }])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 2048
  memory                   = 4096
  volume {
    name = "minecraft-world-data-efs"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.minecraft_efs.id
      root_directory = "/"
    }
  }
}

# ECS Service
resource "aws_ecs_service" "minecraft_service" {
  name                               = "tsar-minecraft-ecs-service"
  cluster                            = aws_ecs_cluster.minecraft_cluster.id
  task_definition                    = aws_ecs_task_definition.minecraft_task.arn
  desired_count                      = 0
  launch_type                        = "FARGATE"
  enable_execute_command             = true
  force_new_deployment               = true
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  load_balancer {
    target_group_arn = aws_lb_target_group.nlb_for_minecraft.arn
    container_name   = "minecraft"
    container_port   = 25565
  }

  network_configuration {
    subnets = [
      aws_subnet.subnet_1.id,
      aws_subnet.subnet_2.id
    ]
    security_groups  = [aws_security_group.minecraft_security_group.id]
    assign_public_ip = true
  }
}

resource "aws_security_group" "minecraft_security_group" {
  name        = "tsar-minecraft-security-group"
  description = "tsar minecraft server security group"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "minecraft_security_rule_in" {
  from_port         = 25565
  to_port           = 25565
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.minecraft_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "minecraft_security_rule_out" {
  ip_protocol       = "-1"
  security_group_id = aws_security_group.minecraft_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
}
