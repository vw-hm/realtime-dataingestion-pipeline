resource "aws_iam_role" "role_for_lambda" {
  name = "projectx-send-event-kafka-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy_attachement" {
  role       = "${aws_iam_role.role_for_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda-additional-policy" {
  name = "projectx-lambda-additional-policy"
policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "sqs:*",
          "ec2:*",
          "kafka:*",
          "vpc:*",
          "firehose:*"
        ],
        "Resource": "*"
      } 
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "lambda-additional-policy-attachment" {
  role       = aws_iam_role.role_for_lambda.name
  policy_arn = aws_iam_policy.lambda-additional-policy.arn
}

resource "aws_security_group" "producer-lambda-sg" {
  name        = "${var.environment}-producer-lambda-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = "${aws_vpc.vpc.id}"
  depends_on  = [aws_vpc.vpc]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic to any destination
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic to any destination
  }

  tags = {
    Environment = "${var.environment}"
  }
}