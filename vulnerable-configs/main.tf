provider "aws" {
  region = "us-east-1"
}

# 1. Create a random suffix so your bucket name is unique globally
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# 2. Create the Bucket
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "cloudbreaker-public-data-${random_id.bucket_suffix.hex}"
  force_destroy = true
}

# 3. THE MISCONFIGURATION: Explicitly turning OFF public access blocking
resource "aws_s3_bucket_public_access_block" "vulnerable" {
  bucket = aws_s3_bucket.vulnerable_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 4. THE EXPLOIT PATH: A policy allowing "Principal: *" (Everyone) to read
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.vulnerable_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.vulnerable]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.vulnerable_bucket.arn}/*"
      },
    ]
  })
}
