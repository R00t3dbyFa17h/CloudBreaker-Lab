provider "aws" {
  region = "us-east-1"
}

# 1. Create the Bucket (Same Logic)
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "cloudbreaker-secure-data-${random_id.bucket_suffix.hex}"
  force_destroy = true
}

# 2. THE FIX: Explicitly BLOCK all public access
resource "aws_s3_bucket_public_access_block" "secure" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 3. THE FIX: No Public Bucket Policy
# (We simply do not attach a policy that allows Principal: "*")
