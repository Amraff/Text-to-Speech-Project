resource "aws_lambda_function" "new_post" {
  function_name = "polly-new-post"
  filename      = "${path.module}/../deploy/new_post.zip"
  handler       = "handler.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_new_post_role.arn

  environment {
    variables = {
      DB_TABLE_NAME = aws_dynamodb_table.posts.name
      SNS_TOPIC     = aws_sns_topic.post_topic.arn
    }
  }

  source_code_hash = filebase64sha256("${path.module}/../deploy/new_post.zip")
}

resource "aws_lambda_function" "convert_to_audio" {
  function_name = "polly-convert-to-audio"
  filename      = "${path.module}/../deploy/convert_to_audio.zip"
  handler       = "convert_to_audio.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_convert_role.arn

  environment {
    variables = {
      DB_TABLE_NAME = aws_dynamodb_table.posts.name
      BUCKET_NAME   = aws_s3_bucket.mp3_bucket.bucket
    }
  }

  source_code_hash = filebase64sha256("${path.module}/../deploy/convert_to_audio.zip")
}

resource "aws_lambda_function" "get_post" {
  function_name = "polly-get-post"
  filename      = "${path.module}/../deploy/get_post.zip"
  handler       = "get_post.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_get_role.arn

  environment {
    variables = {
      DB_TABLE_NAME = aws_dynamodb_table.posts.name
    }
  }

  source_code_hash = filebase64sha256("${path.module}/../deploy/get_post.zip")
}

# SNS subscription of convert_to_audio Lambda
resource "aws_sns_topic_subscription" "convert_sub" {
  topic_arn = aws_sns_topic.post_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.convert_to_audio.arn
}

# Allow SNS to invoke the convert lambda
resource "aws_lambda_permission" "allow_sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.convert_to_audio.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.post_topic.arn
}

# ✅ Allow API Gateway to invoke the new_post Lambda
resource "aws_lambda_permission" "apigw_invoke_new_post" {
  statement_id  = "AllowAPIGatewayInvokeNewPost"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.new_post.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = aws_api_gateway_rest_api.api.execution_arn
}

# ✅ Allow API Gateway to invoke the convert_to_audio Lambda
resource "aws_lambda_permission" "apigw_invoke_convert_to_audio" {
  statement_id  = "AllowAPIGatewayInvokeConvertToAudio"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.convert_to_audio.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = aws_api_gateway_rest_api.api.execution_arn
}

# ✅ Allow API Gateway to invoke the get_post Lambda
resource "aws_lambda_permission" "apigw_invoke_get_post" {
  statement_id  = "AllowAPIGatewayInvokeGetPost"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_post.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = aws_api_gateway_rest_api.api.execution_arn
}