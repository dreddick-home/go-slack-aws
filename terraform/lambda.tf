resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_lambda_function" "test_lambda" {
  filename      = "../function.zip"
  function_name = "aws_go"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "main"
  publish       = "true"


  runtime          = "go1.x"
  source_code_hash = filebase64sha256("../function.zip")

  environment {
    variables = {
      CHANNEL_ID = var.channel_id
      TOKEN      = var.token

    }
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}


resource "aws_lambda_alias" "test_lambda_alias" {
  name             = "test"
  description      = "Test environment"
  function_name    = aws_lambda_function.test_lambda.arn
  function_version = var.environments.test.version


}