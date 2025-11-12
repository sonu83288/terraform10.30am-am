# ------------------------------
# Provider
# ------------------------------
provider "aws" {
  region = "us-west-2"
}

# ------------------------------
# IAM Role for Lambda
# ------------------------------
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ------------------------------
# Lambda Function
# ------------------------------
resource "aws_lambda_function" "example_lambda" {
  function_name = "scheduled-lambda"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec_role.arn
   timeout       = 900
   memory_size   = 128

  filename      = "lambda_function.zip"

  # Environment variables (optional)
  environment {
    variables = {
      ENV = "dev"
    }
  }
}

# ------------------------------
# EventBridge (Schedule Rule)
# ------------------------------
resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name                = "lambda-schedule"
  description         = "Run Lambda every 5 minutes"
  #schedule_expression = "rate(5 minutes)"
  schedule_expression = "cron(0/5 * * * ? *)"

}

# ------------------------------
# EventBridge Target
# ------------------------------
resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule      = aws_cloudwatch_event_rule.every_five_minutes.name
  target_id = "lambda"
  arn       = aws_lambda_function.example_lambda.arn
}

# ------------------------------
# Lambda Permission for EventBridge
# ------------------------------
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_five_minutes.arn
}
