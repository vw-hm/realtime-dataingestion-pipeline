# IAM Role for Kinesis Firehose
resource "aws_iam_role" "firehose_role" {
  name = "projectx-firehose-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "firehose_s3_policy" {
  name        = "projectx-firehose-s3-policy"
  description = "IAM policy for Kinesis Firehose to write to S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:AbortMultipartUpload", "s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:PutObject"],
        Effect   = "Allow",
        Resource = ["arn:aws:s3:::${aws_s3_bucket.projectx-firehose_s3_bucket.bucket}/*", "arn:aws:s3:::${aws_s3_bucket.projectx-firehose_s3_bucket.bucket}"]
      },
      {
        Action   = ["lambda:*"],
        Effect   = "Allow",
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_policy_attachment" {
  policy_arn = aws_iam_policy.firehose_s3_policy.arn
  role       = aws_iam_role.firehose_role.name
}

# Kinesis Data Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "firehose_stream" {
  name        = "projectx-s3-delivery-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.projectx-firehose_s3_bucket.arn
    buffer_size       = 1     
    buffer_interval   = 60
  
    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.transform-lambda-function.arn}:$LATEST"
        }
      }

  }
  }
}