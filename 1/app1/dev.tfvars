application_memory     = 512
application_cpu        = 256
ecs_container_port     = 8080
vpc_id                = "vpc-0b106afce00afa862"
vpc_endpoint_allowed_cidrs = ["10.0.64.0/20"]
ecs_allowed_cidr      = ["10.0.0.0/20"]
private_subnet_ids     =  ["subnet-0964a9ea4eeb3e77d","subnet-0ba0f387d18ca0e10","subnet-08b0a47ee47d88a61",]

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

