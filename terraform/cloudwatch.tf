resource "aws_cloudwatch_event_rule" "icebreaker_schedule_rule" {
  name        = "send-icebreaker"
  description = "Send an icebreaker message to slack via lambda"

  schedule_expression = "cron(* * * * ? *)"

}

resource "aws_cloudwatch_event_target" "icebreaker_schedule" {
  rule      = aws_cloudwatch_event_rule.icebreaker_schedule_rule.name
  target_id = "lambda"
  arn       = aws_lambda_function.test_lambda.arn
}

resource "aws_lambda_permission" "icebreaker_schedule_rule" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.icebreaker_schedule_rule.arn
}