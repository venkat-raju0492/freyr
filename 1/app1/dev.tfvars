application_memory     = 512
application_cpu        = 256
ecs_container_port     = 8080
vpc_id                = "vpc-07dd7c61001d399f5"
vpc_endpoint_allowed_cidrs = ["10.0.64.0/20"]
ecs_allowed_cidr      = ["10.0.0.0/20"]
private_subnet_ids     = ["subnet-03c5f33df23eff7f5","subnet-0ab2e483a13826dc1","subnet-003c746b85d21220b"]

api_throttling_burst_limit                 = 5000

api_throttling_rate_limit                  = 10000
ecs_launch_type                         = "FARGATE" 
ecs_service_min_count               = "1"
ecs_service_max_count               = "2"
ecs_service_desired_count           = "1"

capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE_SPOT",
      weight            = 1,
      base              = 2
    }
]

