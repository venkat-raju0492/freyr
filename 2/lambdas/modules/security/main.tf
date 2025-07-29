
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