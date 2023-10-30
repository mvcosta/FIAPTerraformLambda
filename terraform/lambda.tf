resource "aws_iam_role" "auth_lambda_exec" {
  name = "auth-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "auth_lambda_policy" {
  role       = aws_iam_role.auth_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "secret_access" {
  name = "LambdaSecretAccess"

  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Action   = ["secretsmanager:GetSecretValue"],
          Effect   = "Allow",
          Resource = "*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "s3_lambda_secret_access" {
  role       = aws_iam_role.auth_lambda_exec.name
  policy_arn = aws_iam_policy.secret_access.arn
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_vpc_access_execution" {
  role       = aws_iam_role.auth_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


resource "aws_lambda_function" "auth" {
  function_name = "auth"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_auth.key

  runtime = "python3.8"
  handler = "lambda.lambda_handler"

  source_code_hash = data.archive_file.lambda_auth.output_base64sha256

  role = aws_iam_role.auth_lambda_exec.arn

  vpc_config {
    subnet_ids = [
      "${data.terraform_remote_state.app.outputs.private_subnet_a}",
      "${data.terraform_remote_state.app.outputs.private_subnet_b}",
    ]
    security_group_ids = ["${data.terraform_remote_state.app.outputs.cluster_security_group}"]
  }
}

resource "aws_cloudwatch_log_group" "auth" {
  name = "/aws/lambda/${aws_lambda_function.auth.function_name}"

  retention_in_days = 5
}

data "archive_file" "lambda_auth" {
  type = "zip"

  source_dir  = "../${path.module}/python"
  output_path = "../${path.module}/auth.zip"
}

resource "aws_s3_object" "lambda_auth" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "auth.zip"
  source = data.archive_file.lambda_auth.output_path

  etag = filemd5(data.archive_file.lambda_auth.output_path)
}
