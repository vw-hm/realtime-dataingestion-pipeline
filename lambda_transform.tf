data "archive_file" "lambda-transform-zip" {
  type        = "zip"
  source_file = "lambda/src/transform_lambda.py"
  output_path = "lambda/packages/transform_lambda_function.zip"
}

resource "aws_lambda_function" "transform-lambda-function" {
  filename         = "lambda/packages/transform_lambda_function.zip"
  function_name    = "projectx-transform-lambda"
  role             = "${aws_iam_role.role_for_lambda.arn}"
  handler          = "transform_lambda.lambda_handler"
  source_code_hash = "${data.archive_file.lambda-transform-zip.output_base64sha256}"
  runtime          = "python3.7"
  timeout          = 120
  memory_size      = 128
}

resource "aws_lambda_permission" "allow_firehose" {
  statement_id  = "AllowExecutionFromFirehose"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.transform-lambda-function.arn

  principal = "firehose.amazonaws.com"
}
