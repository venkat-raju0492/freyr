############ security group for VPC endpoint



resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "${var.project}-vpc-endpoint-sg-${var.env}"
  description = "Security Group for vpc endpoint"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.vpc_endpoint_allowed_cidrs
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, tomap({
    Name = "${var.project}-vpc-endpoint-sg-${var.env}"
  }))
}


############ ecs iam role and policy

resource "aws_iam_policy" "ecs-task-policy" {
  name = "${var.project}-ecs-policy-${var.env}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ssm:GetParameter",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        "Resource": "*"
      }
    ]
}
EOF
}

resource "aws_iam_role" "ecs-task-role" {
  name = "${var.project}-ecs-role-${var.env}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
            "Service": [
                "ecs-tasks.amazonaws.com"
            ]
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

  tags = merge(var.common_tags, tomap({
    Name = "${var.project}-ecs-role-${var.env}"
  }))
}

resource "aws_iam_role_policy_attachment" "ecs-policy-attachement" {
  role       = aws_iam_role.ecs-task-role.name
  policy_arn = aws_iam_policy.ecs-task-policy.arn
}

############# ecs security group

resource "aws_security_group" "asg-sg" {
  name        = "${var.project}-asg-sg-${var.env}"
  description = "${var.project}-asg-sg-${var.env}"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.ecs_container_port
    to_port         = var.ecs_container_port
    protocol        = "tcp"
    cidr_blocks     = var.ecs_allowed_cidr
    description     = "ALB access to the ASG"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, tomap({
    Name = "${var.project}-asg-sg-${var.env}"
  }))
}


##### Setup cloudwatch log group role ARN for API Gateway

resource "aws_iam_role" "apigateway_cloudwatch" {
  name = "APIGatewayCloudWatchLogsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apigateway_logs_policy" {
  role       = aws_iam_role.apigateway_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

