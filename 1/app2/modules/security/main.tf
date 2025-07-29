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


####### Iam role for lambda function

resource "aws_iam_policy" "lambda-policy" {
  name = "${var.project}-lambda-${var.env}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "lambda:InvokeFunction",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
      }
    ]
}
EOF
}

resource "aws_iam_role" "lambda-role" {
  name = "${var.project}-lambda-role-${var.env}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
            "Service": [
                "lambda.amazonaws.com"
            ]
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

  tags = merge(var.common_tags, tomap({
    Name = "${var.project}-lambda-role-${var.env}"
  }))
}

resource "aws_iam_role_policy_attachment" "lambda-iam-policy-attachement" {
  role       = aws_iam_role.lambda-role.name
  policy_arn = aws_iam_policy.lambda-policy.arn
}