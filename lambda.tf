locals {
  msk_brokers_string = aws_msk_cluster.kafka.bootstrap_brokers
  msk_brokers_list   = split(",", local.msk_brokers_string)
}

data "archive_file" "lambda-layers-zip" {
  type        = "zip"
  source_file = "lambda/src/main.py"
  output_path = "lambda/packages/lambda_function.zip"
}

resource "aws_lambda_function" "lambda-function" {
  filename         = "lambda/packages/lambda_function.zip"
  function_name    = "projectx-kafka-producer"
  role             = "${aws_iam_role.role_for_lambda.arn}"
  handler          = "main.handle"
  source_code_hash = "${data.archive_file.lambda-layers-zip.output_base64sha256}"
  runtime          = "python3.7"
  timeout          = 120
  memory_size      = 128
  layers           = ["${aws_lambda_layer_version.python37-pandas-layer.arn}"]
  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]
    security_group_ids = [aws_security_group.producer-lambda-sg.id]
  }

  environment {
   variables = {
    MSKBroker1 = local.msk_brokers_list[0],
    MSKBroker2 = local.msk_brokers_list[1],
    }
  }
  replace_security_groups_on_destroy = true
  depends_on = [aws_msk_cluster.kafka]

}

resource "aws_lambda_layer_version" "python37-pandas-layer" {
  filename            = "lambda/packages/Python3-pandas.zip"
  layer_name          = "Python3-pandas"
  source_code_hash    = "${filebase64sha256("lambda/packages/Python3-pandas.zip")}"
  compatible_runtimes = ["python3.6", "python3.7"]
}

resource "aws_lambda_permission" "allow_sqs" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-function.arn

  principal = "sqs.amazonaws.com"
}


resource "aws_lambda_event_source_mapping" "trigger-lambda-from-sqs" {
  event_source_arn  = aws_sqs_queue.queue.arn
  function_name     = aws_lambda_function.lambda-function.arn
  batch_size        = 5
}