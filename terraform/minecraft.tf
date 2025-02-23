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
  desired_count                      = 1
  launch_type                        = "FARGATE"
  enable_execute_command             = true
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  network_configuration {
    subnets          = [aws_subnet.subnet.id]
    security_groups  = [aws_security_group.minecraft_security_group.id]
    assign_public_ip = true
  }
}
