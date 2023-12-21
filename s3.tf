resource "aws_s3_bucket" "projectx-firehose_s3_bucket" {
  bucket = "projectx-firehose-s3-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "projectx-firehose_s3_bucket_versioning" {
  bucket = aws_s3_bucket.projectx-firehose_s3_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}
