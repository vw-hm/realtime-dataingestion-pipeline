data "archive_file" "consumer-lambda-layers-zip" {
  type        = "zip"
  source_file = "lambda/src/consumer_main.py"
  output_path = "lambda/packages/consumer_lambda_function.zip"
}

resource "aws_lambda_function" "consumer-lambda-function" {
  filename         = "lambda/packages/consumer_lambda_function.zip"
  function_name    = "projectx-kafka-consumer"
  role             = "${aws_iam_role.role_for_lambda.arn}"
  handler          = "consumer_main.handle"
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
    FirehoseDeliveryStream = aws_kinesis_firehose_delivery_stream.firehose_stream.name
    }
  }

  depends_on = [aws_lambda_layer_version.python37-pandas-layer, aws_kinesis_firehose_delivery_stream.firehose_stream]
}

resource "aws_lambda_permission" "allow_kafka" {
  statement_id  = "AllowExecutionFromKafka"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.consumer-lambda-function.arn

  principal = "kafka.amazonaws.com"
}

resource "aws_lambda_event_source_mapping" "msk_trigger" {
  event_source_arn  = aws_msk_cluster.kafka.arn
  function_name     = aws_lambda_function.consumer-lambda-function.function_name
  starting_position = "LATEST"  # You can adjust this based on your requirements
  topics = ["demo_testing2"]
  batch_size = 10
}