provider "aws" {
  region = "us-east-1"
}

# 1. Create the User
resource "aws_iam_user" "victim" {
  name = "cloudbreaker-intern"
  force_destroy = true
}

# 2. Create Access Keys (So we can log in as them)
resource "aws_iam_access_key" "victim_keys" {
  user = aws_iam_user.victim.name
}

# 3. THE VULNERABILITY: A "Read Only" policy with ONE fatal flaw
resource "aws_iam_user_policy" "vulnerable_policy" {
  name = "intern-policy"
  user = aws_iam_user.victim.name

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
      },
      {
        Sid    = "TheFatalFlaw"
        Effect = "Allow"
        Action = "iam:PutUserPolicy"
        Resource = aws_iam_user.victim.arn
      }
    ]
  })
}

# 4. Output the keys so we can hack them
output "intern_access_key" {
  value = aws_iam_access_key.victim_keys.id
}
output "intern_secret_key" {
  value = aws_iam_access_key.victim_keys.secret
  sensitive = true
}
