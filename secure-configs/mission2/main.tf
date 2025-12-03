provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "secure_victim" {
  name = "cloudbreaker-intern-secure"
  force_destroy = true
}

resource "aws_iam_user_policy" "secure_policy" {
  name = "intern-policy-secure"
  user = aws_iam_user.secure_victim.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadOnlyAccess"
        Effect = "Allow"
        Action = [
          "s3:List*",
          "s3:Get*",
          "ec2:Describe*"
        ]
        Resource = "*"
      }
      # THE FIX: We removed the "TheFatalFlaw" block entirely.
    ]
  })
}
