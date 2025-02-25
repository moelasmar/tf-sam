module "lambda_function_hello" {
  source        = "terraform-aws-modules/lambda/aws"
  version       = "~> 6.0"
  timeout       = 300
  source_path   = "${path.module}/src/hello/"
  function_name = "app-responder"
  handler       = "app.handler"
  runtime       = "python3.9"
  create_sam_metadata = true
  publish       = true
  allowed_triggers = {
    APIGatewayAny = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
    }
  }
}

module "lambda_function_auth" {
  source        = "terraform-aws-modules/lambda/aws"
  version       = "~> 6.0"
  timeout       = 300
  source_path   = "${path.module}/src/auth/"
  function_name = "authorizer"
  handler       = "app.auth_handler"
  runtime       = "python3.9"
  publish       = true
  create_sam_metadata = true
    allowed_triggers = {
      APIGatewayAny = {
        service    = "apigateway"
        source_arn = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_api_gateway_rest_api.api.id}/*/*/*"
      }
    }
}
